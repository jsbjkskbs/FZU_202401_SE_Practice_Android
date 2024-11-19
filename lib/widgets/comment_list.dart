import 'dart:async';

import 'package:dio/dio.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:fulifuli_app/global.dart';
import 'package:fulifuli_app/utils/toastification.dart';
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
  int pageNum = 0;
  late ScrollController controller = widget.controller ?? ScrollController();
  late ListObserverController listObserverController = ListObserverController(
    controller: controller,
  );
  String observerCommentId = '';
  Timer observerTimer = Timer(const Duration(), () {});

  static const pageSize = 10;

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

    WidgetsBinding widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((_) {
      _controller.callRefresh();
    });
  }

  late final EasyRefreshController _controller;
  late final String key;

  @override
  Widget build(BuildContext context) {
    return EasyRefresh.builder(
      header: const MaterialHeader(),
      footer: BezierFooter(
        foregroundColor: Theme.of(context).scaffoldBackgroundColor,
        backgroundColor: Theme.of(context).primaryColor,
        spinWidget: SizedBox(
          width: 25,
          height: 25,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).scaffoldBackgroundColor),
            strokeWidth: 4,
          ),
        ),
        springRebound: true,
      ),
      controller: _controller,
      onRefresh: () async {
        Global.cachedMapCommentList.remove(key);
        if (widget.isComment) {
          await _fetchDataOfChildComment();
        } else {
          await _fetchData();
        }
        setState(() {});
        if (Global.cachedMapCommentList[key]!.key.isEmpty) {
          if (context.mounted) {
            ToastificationUtils.showSimpleToastification(context, '暂无评论');
          }
        }
        _controller.finishRefresh();
      },
      onLoad: () async {
        if (Global.cachedMapCommentList['${CommentListView.uniqueKey}/${widget.oType}/${widget.oId}']!.value) {
          ToastificationUtils.showSimpleToastification(context, '没有更多了');
          _controller.finishLoad();
          return;
        }
        if (widget.isComment) {
          await _fetchDataOfChildComment();
        } else {
          await _fetchData();
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

  Future<void> _fetchData() async {
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
      var isEnd = response.data["data"]["is_end"];
      if (!isEnd) {
        pageNum++;
      }
      Global.cachedMapCommentList[key] = MapEntry([...Global.cachedMapCommentList[key]!.key, ...list], isEnd);
    }
  }

  Future<void> _fetchDataOfChildComment() async {
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
      var isEnd = response.data["data"]["is_end"];
      if (!isEnd) {
        pageNum++;
      }
      Global.cachedMapCommentList[key] = MapEntry([...Global.cachedMapCommentList[key]!.key, ...list], isEnd);
    }
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
