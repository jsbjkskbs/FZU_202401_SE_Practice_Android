import 'package:flutter/material.dart';
import 'package:fulifuli_app/global.dart';
import 'package:fulifuli_app/widgets/empty_placeholder.dart';
import 'package:fulifuli_app/widgets/search_page/search_page_video_item.dart';
import 'package:fulifuli_app/widgets/video_page/video_profile_view.dart';

import '../../model/video.dart';
import '../../pages/video.dart';

class VideoIntroductionView extends StatefulWidget {
  const VideoIntroductionView({super.key, required this.video, required this.blockScroll});

  final Video video;
  final bool blockScroll;
  static const String cachePrefix = "video_introduction_view";

  @override
  State<StatefulWidget> createState() {
    return _VideoIntroductionViewState();
  }
}

class _VideoIntroductionViewState extends State<VideoIntroductionView> {
  late String key = '${VideoIntroductionView.cachePrefix}/${widget.video.id}';
  bool expanded = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((_) async {
      if (!Global.cachedMapVideoList.containsKey(key)) {
        Global.cachedMapVideoList[key] = const MapEntry([], false);
      }
      await _fetchData();
      debugPrint('video: ${widget.video.toJson()}');
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: widget.blockScroll ? const NeverScrollableScrollPhysics() : const AlwaysScrollableScrollPhysics(),
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          height: 8,
          color: Theme.of(context).dialogBackgroundColor,
        );
      },
      itemBuilder: (BuildContext context, int index) {
        return [
          VideoProfileView(
            video: widget.video,
          ),
          if (Global.cachedMapVideoList.containsKey(key) && Global.cachedMapVideoList[key]!.key.isNotEmpty)
            for (var item in Global.cachedMapVideoList[key]!.key)
              SearchPageVideoItem(
                data: item,
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    return VideoPage(
                      videoId: item.id!,
                    );
                  }));
                },
              ),
          if (!Global.cachedMapVideoList.containsKey(key) || Global.cachedMapVideoList[key]!.key.isEmpty) const EmptyPlaceHolder(),
        ][index];
      },
      itemCount: 1 + (Global.cachedMapVideoList.containsKey(key) ? Global.cachedMapVideoList[key]!.key.length : 1),
    );
  }

  Future<void> _fetchData() async {
    if (!Global.cachedMapVideoList.containsKey(key)) {
      Global.cachedMapVideoList[key] = const MapEntry([], false);
    }
    var response = await Global.dio.get('/api/v1/video/neighbour/feed', data: {
      "video_id": widget.video.id,
      "offset": Global.cachedMapVideoList[key]!.key.length,
      "n": 10,
    });
    if (response.data["code"] != Global.successCode) {
      return response.data["msg"];
    }
    var list = <Video>[];
    for (var item in response.data["data"]["items"]) {
      list.add(Video.fromJson(item));
    }
    Global.cachedMapVideoList[key] = MapEntry(Global.cachedMapVideoList[key]!.key + list, true);
  }
}
