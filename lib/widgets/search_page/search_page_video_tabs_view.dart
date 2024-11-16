import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:fulifuli_app/global.dart';
import 'package:fulifuli_app/test.dart';
import 'package:fulifuli_app/widgets/search_page/search_page_video_item.dart';

import '../../model/video.dart';

class SearchPageVideoTabsView extends StatefulWidget {
  const SearchPageVideoTabsView({super.key, required this.currentIndex, required this.assignedIndex});

  static const String uniqueKey = "search-video";
  final int currentIndex;
  final int assignedIndex;

  @override
  State<StatefulWidget> createState() {
    return _SearchPageVideoTabsViewState();
  }
}

class _SearchPageVideoTabsViewState extends State<SearchPageVideoTabsView> {
  late List<Video> videoList = [];
  final EasyRefreshController _controller = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  @override
  void initState() {
    super.initState();
    bool isCached = Global.cachedMapVideoList.containsKey(SearchPageVideoTabsView.uniqueKey);
    if (!isCached) {
      Global.cachedMapVideoList.addEntries([MapEntry(SearchPageVideoTabsView.uniqueKey, MapEntry(videoList, false))]);
      debugPrint('Added new video list with key: ${SearchPageVideoTabsView.uniqueKey}');
    }
    videoList = Global.cachedMapVideoList[SearchPageVideoTabsView.uniqueKey]!.key;

    if (isCached) {
      return;
    }
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
          await Future.delayed(const Duration(seconds: 2), () {
            videoList.addAll(videoListForTest);
            setState(() {});
            _controller.finishRefresh();
          });
        },
        onLoad: () async {
          await Future.delayed(const Duration(seconds: 2), () {
            videoList.addAll(videoListForTest);
            setState(() {});
            _controller.finishLoad();
          });
        },
        child: ListView.separated(
            itemBuilder: (context, index) => ListBody(
                  children: [
                    SearchPageVideoItem(
                      onTap: () {
                        debugPrint('SearchPageVideoItem onTap');
                      },
                      data: videoListForTest[0],
                    )
                  ],
                ),
            separatorBuilder: (context, index) => const Divider(),
            itemCount: videoList.length));
  }
}
