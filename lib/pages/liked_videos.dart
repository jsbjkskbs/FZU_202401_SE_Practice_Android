import 'package:dio/dio.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:fulifuli_app/pages/video.dart';

import '../global.dart';
import '../model/video.dart';
import '../utils/toastification.dart';
import '../widgets/search_page/search_page_video_item.dart';

class LikedVideosPage extends StatefulWidget {
  const LikedVideosPage({super.key});

  static const String routeName = '/liked_videos';

  @override
  State<StatefulWidget> createState() {
    return _LikedVideosPageState();
  }
}

class _LikedVideosPageState extends State<LikedVideosPage> {
  static const String uniqueKey = "liked-videos";

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('赞过的视频'),
        centerTitle: true,
      ),
      body: EasyRefresh(
          header: const MaterialHeader(),
          footer: const MaterialFooter(),
          controller: _controller,
          onRefresh: () async {
            pageNum = 0;
            videoList = [];
            Global.cachedMapVideoList[uniqueKey] = const MapEntry([], false);
            Response response;
            response = await Global.dio.get('/api/v1/interact/like/video/list', data: {
              "user_id": Global.self.id,
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
            Global.cachedMapVideoList[uniqueKey] = MapEntry(list, response.data["data"]["is_end"]);
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
            if (Global.cachedMapVideoList.containsKey(uniqueKey)) {
              videoList = Global.cachedMapVideoList[uniqueKey]!.key;
              var isEnd = Global.cachedMapVideoList[uniqueKey]!.value;
              if (isEnd) {
                ToastificationUtils.showSimpleToastification(context, "没有更多了");
                _controller.finishLoad();
                return;
              }
            }
            Response response;
            response = await Global.dio.get('/api/v1/interact/like/video/list', data: {
              "user_id": Global.self.id,
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
            Global.cachedMapVideoList[uniqueKey] = MapEntry(list, response.data["data"]["is_end"]);
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
                          Navigator.of(context).pushNamed(VideoPage.routeName, arguments: {
                            "vid": videoList[index].id,
                          });
                        },
                        data: videoList[index],
                      )
                    ],
                  ),
              separatorBuilder: (context, index) => const Divider(),
              itemCount: videoList.length)),
    );
  }
}
