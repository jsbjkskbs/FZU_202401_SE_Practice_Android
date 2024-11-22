import 'package:dio/dio.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:fulifuli_app/pages/video.dart';
import 'package:fulifuli_app/widgets/empty_placeholder.dart';
import 'package:fulifuli_app/widgets/load_footer.dart';

import '../generated/l10n.dart';
import '../global.dart';
import '../model/video.dart';
import '../widgets/search_page/search_page_video_item.dart';

class LikedVideosPage extends StatefulWidget {
  const LikedVideosPage({super.key});

  static const String routeName = '/liked_videos';
  static const String uniqueKey = "likedVideos";

  @override
  State<StatefulWidget> createState() {
    return _LikedVideosPageState();
  }
}

class _LikedVideosPageState extends State<LikedVideosPage> {
  late String key = LikedVideosPage.uniqueKey;
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
    widgetsBinding.addPostFrameCallback((callback) async {
      if (!Global.cachedMapVideoList.containsKey(key)) {
        Global.cachedMapVideoList[key] = const MapEntry([], false);
      }
      if (Global.cachedMapVideoList[key]!.key.isEmpty) {
        await _fetchData();
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    Global.cachedMapVideoList.remove(key);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.liked_video_title),
        centerTitle: true,
      ),
      body: EasyRefresh(
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
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) {
                                  return VideoPage(
                                    videoId: Global.cachedMapVideoList[key]!.key[index].id!,
                                  );
                                }),
                              );
                            },
                            data: Global.cachedMapVideoList[key]!.key[index],
                          )
                        : const EmptyPlaceHolder(),
                  ],
                ),
            separatorBuilder: (context, index) => const Divider(),
            itemCount: Global.cachedMapVideoList.containsKey(key) && Global.cachedMapVideoList[key]!.key.isNotEmpty
                ? Global.cachedMapVideoList[key]!.key.length
                : 1),
      ),
    );
  }

  Future<String?> _fetchData() async {
    if (!Global.cachedMapVideoList.containsKey(key)) {
      Global.cachedMapVideoList[key] = const MapEntry([], false);
    }

    Response response;
    response = await Global.dio.get('/api/v1/interact/like/video/list', data: {
      "user_id": Global.self.id,
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
