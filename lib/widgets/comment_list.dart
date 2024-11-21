import 'dart:async';

import 'package:dio/dio.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:fulifuli_app/global.dart';
import 'package:fulifuli_app/widgets/load_footer.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

import '../model/comment.dart';
import 'comment_card.dart';

class CommentListView extends StatefulWidget {
  const CommentListView({
    super.key,
    this.commentHead,
    this.controller,
    required this.oType,
    required this.oId,
    this.easyRefreshController,
    this.isComment = false,
  });

  static const String uniqueKey = 'CommentListView';

  final String oType;
  final String oId;
  final EasyRefreshController? easyRefreshController;
  final ScrollController? controller;
  final Widget? commentHead;
  final bool isComment;

  @override
  State<StatefulWidget> createState() {
    return _CommentListViewState();
  }
}

class _CommentListViewState extends State<CommentListView> {
  bool isEnd = false;
  int pageNum = 0;
  static const pageSize = 10;
  late ScrollController controller = widget.controller ?? ScrollController();
  late ListObserverController listObserverController = ListObserverController(
    controller: controller,
  );
  String observerCommentId = '';
  Timer observerTimer = Timer(const Duration(), () {});

  @override
  void initState() {
    super.initState();
    _controller = widget.easyRefreshController ??
        EasyRefreshController(
          controlFinishLoad: true,
          controlFinishRefresh: true,
        );

    if (widget.isComment) {
      key = '${CommentListView.uniqueKey}/${widget.oType}/child_comment/${widget.oId}';
    } else {
      key = '${CommentListView.uniqueKey}/${widget.oType}/${widget.oId}';
    }

    if (!Global.cachedMapCommentList.containsKey(key)) {
      Global.cachedMapCommentList[key] = const MapEntry([], false);
    }

    WidgetsBinding widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((_) async {
      // _controller.callRefresh();
      if (Global.cachedMapCommentList[key]!.key.isEmpty && Global.cachedMapCommentList[key]!.value == false) {
        if (widget.isComment) {
          await _fetchDataOfChildComment();
        } else {
          await _fetchData();
        }
        setState(() {});
      }
    });
  }

  @override
  dispose() {
    super.dispose();
    _controller.dispose();
    // Global.cachedMapCommentList.remove(key);
  }

  late final EasyRefreshController _controller;
  late final String key;

  @override
  Widget build(BuildContext context) {
    return EasyRefresh.builder(
      header: const MaterialHeader(),
      footer: LoadFooter.buildInformationFooter(context),
      controller: _controller,
      onRefresh: () async {
        isEnd = false;
        pageNum = 0;
        Global.cachedMapCommentList.remove(key);
        String? result;
        if (widget.isComment) {
          result = await _fetchDataOfChildComment();
        } else {
          result = await _fetchData();
        }
        if (result != null) {
          _controller.finishRefresh();
          return;
        }
        setState(() {});
        _controller.finishRefresh();
      },
      onLoad: () async {
        if (Global.cachedMapCommentList[key]!.value) {
          _controller.finishLoad(IndicatorResult.noMore, true);
          return;
        }
        String? result;
        if (widget.isComment) {
          result = await _fetchDataOfChildComment();
        } else {
          result = await _fetchData();
        }
        if (result != null) {
          _controller.finishLoad();
          return;
        }
        setState(() {});
        _controller.finishLoad();
      },
      childBuilder: (BuildContext context, ScrollPhysics physics) {
        return ListViewObserver(
            controller: listObserverController,
            child: ListView.separated(
                controller: controller,
                physics: physics,
                separatorBuilder: (_, index) => index >= 2
                    ? Divider(
                        color: Theme.of(context).unselectedWidgetColor,
                        thickness: 0.2,
                      )
                    : const SizedBox(),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const SizedBox();
                  } else if (index == 1) {
                    return widget.commentHead != null
                        ? Column(children: [
                            widget.commentHead!,
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Theme.of(context).dialogBackgroundColor,
                              ),
                            )
                          ])
                        : const SizedBox();
                  }
                  return CommentCard(
                    comment: Global.cachedMapCommentList[key]!.key[index - 2],
                    needToShowChildCount: !widget.isComment,
                    indexCommentKey: widget.isComment ? key : null,
                    onClickIndexComment: _scrollToComment,
                    isObserved: observerCommentId == Global.cachedMapCommentList[key]!.key[index - 2].id,
                  );
                },
                itemCount: Global.cachedMapCommentList.containsKey(key) ? Global.cachedMapCommentList[key]!.key.length + 2 : 2));
      },
    );
  }

  Future<String?> _fetchData() async {
    if (!Global.cachedMapCommentList.containsKey(key)) {
      Global.cachedMapCommentList[key] = const MapEntry([], false);
    }

    Response response;
    response = await Global.dio.get('/api/v1/interact/comment/${widget.oType}/list', data: {
      "${widget.oType}_id": widget.oId,
      "page_size": pageSize,
      "page_num": pageNum,
    });
    if (response.data["code"] == Global.successCode) {
      var list = <Comment>[];
      for (var item in response.data["data"]["items"]) {
        list.add(Comment.fromJson(item));
      }
      if (response.data["data"]["is_end"]) {
        isEnd = true;
      } else {
        pageNum++;
      }
      Global.cachedMapCommentList[key] = MapEntry([...Global.cachedMapCommentList[key]!.key, ...list], isEnd);
    } else {
      return response.data["msg"];
    }
    return null;
  }

  Future<String?> _fetchDataOfChildComment() async {
    if (!Global.cachedMapCommentList.containsKey(key)) {
      Global.cachedMapCommentList[key] = const MapEntry([], false);
    }

    Response response;
    response = await Global.dio.get('/api/v1/interact/${widget.oType}/child_comment/list', data: {
      "comment_id": widget.oId,
      "page_size": pageSize,
      "page_num": pageNum,
    });
    if (response.data["code"] == Global.successCode) {
      debugPrint('child_comment: ${response.data}');
      var list = <Comment>[];
      for (var item in response.data["data"]["items"]) {
        list.add(Comment.fromJson(item));
      }
      if (response.data["data"]["is_end"]) {
        isEnd = true;
      } else {
        pageNum++;
      }
      Global.cachedMapCommentList[key] = MapEntry([...Global.cachedMapCommentList[key]!.key, ...list], isEnd);
    } else {
      return response.data["msg"];
    }
    return null;
  }

  void _scrollToComment(String commentId) {
    var index = Global.cachedMapCommentList[key]!.key.indexWhere((element) => element.id == commentId);
    if (index != -1) {
      listObserverController.animateTo(index: index + 2, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      setState(() {
        observerCommentId = commentId;
      });
      observerTimer.cancel();
      observerTimer = Timer(const Duration(milliseconds: 500), () {
        setState(() {
          observerCommentId = '';
        });
      });
    }
  }
}
