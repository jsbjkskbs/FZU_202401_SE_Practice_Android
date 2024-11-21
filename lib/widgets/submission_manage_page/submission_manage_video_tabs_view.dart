import 'package:dio/dio.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:fulifuli_app/global.dart';
import 'package:fulifuli_app/pages/video.dart';
import 'package:fulifuli_app/widgets/empty_placeholder.dart';
import 'package:fulifuli_app/widgets/load_footer.dart';
import 'package:fulifuli_app/widgets/submission_manage_page/submission_manage_video_item.dart';

import '../../model/video.dart';

class SubmissionManageVideoTabsView extends StatefulWidget {
  const SubmissionManageVideoTabsView(
      {super.key, required this.currentIndex, required this.assignedIndex, required this.uniqueKey, required this.querySuffix});

  final String uniqueKey;
  final int currentIndex;
  final int assignedIndex;
  final String querySuffix;

  @override
  State<StatefulWidget> createState() {
    return _SubmissionManageVideoTabsViewState();
  }
}

class _SubmissionManageVideoTabsViewState extends State<SubmissionManageVideoTabsView> {
  int pageNum = 0;
  bool isEnd = false;
  final EasyRefreshController _controller = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  @override
  void initState() {
    super.initState();
    var widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((callback) {
      if (!Global.cachedMapVideoList.containsKey(widget.uniqueKey)) {
        Global.cachedMapVideoList[widget.uniqueKey] = const MapEntry([], false);
      }
      if (Global.cachedMapVideoList[widget.uniqueKey]!.key.isEmpty && Global.cachedMapVideoList[widget.uniqueKey]!.value == false) {
        _controller.callRefresh();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
        header: const MaterialHeader(),
        footer: LoadFooter.buildInformationFooter(context),
        controller: _controller,
        onRefresh: () async {
          pageNum = 0;
          isEnd = false;
          Global.cachedMapVideoList[widget.uniqueKey] = const MapEntry([], false);
          String? result = await _fetchData();
          if (result != null) {
            _controller.finishRefresh();
            return;
          }
          setState(() {});
          _controller.finishRefresh();
        },
        onLoad: () async {
          if (isEnd) {
            _controller.finishLoad(IndicatorResult.noMore, true);
            return;
          }
          String? result = await _fetchData();
          if (result != null) {
            _controller.finishLoad();
            return;
          }
          setState(() {});
          _controller.finishLoad();
        },
        child: ListView.separated(
            itemBuilder: (context, index) => Global.cachedMapVideoList[widget.uniqueKey]!.key.isEmpty
                ? const EmptyPlaceHolder()
                : ListBody(
                    children: [
                      SubmissionManageVideoItem(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return VideoPage(
                                  videoId: Global.cachedMapVideoList[widget.uniqueKey]!.key[index].id!,
                                );
                              },
                            ),
                          );
                        },
                        data: Global.cachedMapVideoList[widget.uniqueKey]!.key[index],
                        badge: Global.cachedMapVideoList[widget.uniqueKey]!.key[index].status!.substring(0, 1).toUpperCase(),
                      )
                    ],
                  ),
            separatorBuilder: (context, index) => const Divider(),
            itemCount: !Global.cachedMapVideoList.containsKey(widget.uniqueKey) || Global.cachedMapVideoList[widget.uniqueKey]!.key.isEmpty
                ? 1
                : Global.cachedMapVideoList[widget.uniqueKey]!.key.length));
  }

  Future<String?> _fetchData() async {
    Response response;
    response = await Global.dio.get("/api/v1/video/submit/${widget.querySuffix}", queryParameters: {
      "page_num": pageNum,
      "page_size": 10,
    });
    if (response.data["code"] == Global.successCode) {
      List<Video> list = [];
      for (var item in response.data["data"]["items"]) {
        list.add(Video.fromJson(item));
      }
      isEnd = response.data["data"]["is_end"];
      if (!isEnd) {
        pageNum++;
      }
      Global.cachedMapVideoList[widget.uniqueKey] = MapEntry([...Global.cachedMapVideoList[widget.uniqueKey]!.key, ...list], isEnd);
      return null;
    } else {
      return response.data["msg"];
    }
  }
}
