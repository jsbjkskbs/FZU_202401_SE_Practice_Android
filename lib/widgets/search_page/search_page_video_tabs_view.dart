import 'package:dio/dio.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:fulifuli_app/global.dart';
import 'package:fulifuli_app/pages/video.dart';
import 'package:fulifuli_app/widgets/empty_placeholder.dart';
import 'package:fulifuli_app/widgets/load_footer.dart';
import 'package:fulifuli_app/widgets/search_page/search_page_video_item.dart';

import '../../model/video.dart';

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
  late String key = SearchPageVideoTabsView.uniqueKey;
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
      if (!Global.cachedMapVideoList.containsKey(key)) {
        Global.cachedMapVideoList[key] = const MapEntry([], false);
      }
      if (Global.cachedMapVideoList[key]!.key.isEmpty && Global.cachedMapVideoList[key]!.value == false) {
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
          Global.cachedMapVideoList[key] = const MapEntry([], false);

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
            itemBuilder: (context, index) => ListBody(
                  children: [
                    Global.cachedMapVideoList.containsKey(key) && Global.cachedMapVideoList[key]!.key.isNotEmpty
                        ? SearchPageVideoItem(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                return VideoPage(videoId: Global.cachedMapVideoList[key]!.key[index].id!);
                              }));
                            },
                            data: Global.cachedMapVideoList[key]!.key[index],
                          )
                        : const EmptyPlaceHolder()
                  ],
                ),
            separatorBuilder: (context, index) => const Divider(),
            itemCount: Global.cachedMapVideoList.containsKey(key) && Global.cachedMapVideoList[key]!.key.isNotEmpty
                ? Global.cachedMapVideoList[key]!.key.length
                : 1));
  }

  Future<String?> _fetchData() async {
    if (!Global.cachedMapVideoList.containsKey(key)) {
      Global.cachedMapVideoList[key] = const MapEntry([], false);
    }

    Response response;
    response = await Global.dio.get('/api/v1/video/search', data: {
      "keyword": widget.keyword,
      "page_size": 10,
      "page_num": pageNum,
    });
    if (response.data["code"] != Global.successCode) {
      return response.data["msg"];
    }
    List<Video> list = [];
    for (var item in response.data["data"]["items"]) {
      list.add(Video.fromJson(item));
    }
    if (response.data["data"]["is_end"]) {
      isEnd = true;
    } else {
      pageNum++;
    }
    Global.cachedMapVideoList[key] = MapEntry([...Global.cachedMapVideoList[key]!.key, ...list], isEnd);
    return null;
  }
}
