import 'package:dio/dio.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:fulifuli_app/global.dart';
import 'package:fulifuli_app/pages/video.dart';
import 'package:fulifuli_app/widgets/search_page/search_page_video_item.dart';

import '../../model/video.dart';
import '../../utils/toastification.dart';

class SearchPageVideoTabsView extends StatefulWidget {
  const SearchPageVideoTabsView({super.key, required this.currentIndex, required this.assignedIndex, required this.keyword});

  static const String uniqueKey = "search-video";
  final String keyword;
  final int currentIndex;
  final int assignedIndex;

  @override
  State<StatefulWidget> createState() {
    return _SearchPageVideoTabsViewState();
  }
}

class _SearchPageVideoTabsViewState extends State<SearchPageVideoTabsView> {
  int pageNum = 0;
  late List<Video> videoList = [];
  final EasyRefreshController _controller = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  @override
  void initState() {
    super.initState();
    var widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((callback) {
      _controller.callRefresh();
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
        footer: const MaterialFooter(),
        controller: _controller,
        onRefresh: () async {
          pageNum = 0;
          videoList = [];
          Global.cachedMapVideoList[SearchPageVideoTabsView.uniqueKey] = const MapEntry([], false);
          Response response;
          response = await Global.dio.get('/api/v1/video/search', data: {
            "keyword": widget.keyword,
            "page_size": 10,
            "page_num": pageNum,
          });
          if (response.data["code"] != Global.successCode) {
            if (context.mounted) {
              ToastificationUtils.showSimpleToastification(context, response.data["msg"]);
            }
            return;
          }
          var list = <Video>[];
          for (var item in response.data["data"]["items"]) {
            list.add(Video.fromJson(item));
          }
          videoList = [...videoList, ...list];
          Global.cachedMapVideoList[SearchPageVideoTabsView.uniqueKey] = MapEntry(list, response.data["data"]["is_end"]);
          pageNum++;
          if (response.data["data"]["is_end"]) {
            if (context.mounted) {
              ToastificationUtils.showSimpleToastification(context, "没有更多了");
            }
          }
          setState(() {});
          _controller.finishRefresh();
        },
        onLoad: () async {
          if (Global.cachedMapVideoList.containsKey(SearchPageVideoTabsView.uniqueKey)) {
            videoList = Global.cachedMapVideoList[SearchPageVideoTabsView.uniqueKey]!.key;
            var isEnd = Global.cachedMapVideoList[SearchPageVideoTabsView.uniqueKey]!.value;
            if (isEnd) {
              ToastificationUtils.showSimpleToastification(context, "没有更多了");
              _controller.finishLoad();
              return;
            }
          }
          Response response;
          response = await Global.dio.get('/api/v1/video/search', data: {
            "keyword": widget.keyword,
            "page_size": 10,
            "page_num": pageNum,
          });
          if (response.data["code"] != Global.successCode) {
            if (context.mounted) {
              ToastificationUtils.showSimpleToastification(context, response.data["msg"]);
            }
            return;
          }
          var list = <Video>[];
          for (var item in response.data["data"]["items"]) {
            list.add(Video.fromJson(item));
          }
          videoList = [...videoList, ...list];
          Global.cachedMapVideoList[SearchPageVideoTabsView.uniqueKey] = MapEntry(list, response.data["data"]["is_end"]);
          pageNum++;
          if (response.data["data"]["is_end"]) {
            if (context.mounted) {
              ToastificationUtils.showSimpleToastification(context, "没有更多了");
            }
          }
          setState(() {});
          _controller.finishLoad();
        },
        child: ListView.separated(
            itemBuilder: (context, index) => ListBody(
                  children: [
                    SearchPageVideoItem(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                          return VideoPage(videoId: videoList[index].id!);
                        }));
                      },
                      data: videoList[index],
                    )
                  ],
                ),
            separatorBuilder: (context, index) => const Divider(),
            itemCount: videoList.length));
  }
}
