import 'package:flutter/material.dart';
import 'package:fulifuli_app/global.dart';
import 'package:fulifuli_app/utils/toastification.dart';
import 'package:fulifuli_app/widgets/search_page/search_page_video_item.dart';
import 'package:fulifuli_app/widgets/video_page/video_profile_view.dart';

import '../../model/video.dart';

class VideoIntroductionView extends StatefulWidget {
  const VideoIntroductionView({super.key, required this.vid});

  final String vid;
  static const String cachePrefix = "video_introduction_view";

  @override
  State<StatefulWidget> createState() {
    return _VideoIntroductionViewState();
  }
}

class _VideoIntroductionViewState extends State<VideoIntroductionView> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    if (!Global.cachedMapVideoList.containsKey(VideoIntroductionView.cachePrefix + widget.vid)) {
      Global.dio.get('/api/v1/video/neighbour/feed', data: {
        "video_id": widget.vid,
        "offset": 0,
        "n": 10,
      }).then((data) {
        Global.cachedMapVideoList[VideoIntroductionView.cachePrefix + widget.vid] = const MapEntry([], true);
        if (data.data["code"] != Global.successCode) {
          if (context.mounted) {
            ToastificationUtils.showSimpleToastification(context, data.data["msg"]);
          }
          return;
        }
        var list = <Video>[];
        for (var item in data.data["data"]["items"]) {
          list.add(Video.fromJson(item));
        }
        Global.cachedMapVideoList[VideoIntroductionView.cachePrefix + widget.vid] = MapEntry(list, true);
        setState(() {});
      });
    }
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          height: 8,
          color: Theme.of(context).dialogBackgroundColor,
        );
      },
      itemBuilder: (BuildContext context, int index) {
        return [
          VideoProfileView(
            vid: widget.vid,
          ),
          if (Global.cachedMapVideoList.containsKey(VideoIntroductionView.cachePrefix + widget.vid))
            for (var item in Global.cachedMapVideoList[VideoIntroductionView.cachePrefix + widget.vid]!.key)
              SearchPageVideoItem(
                data: item,
                onTap: () {},
              ),
          if (!Global.cachedMapVideoList.containsKey(VideoIntroductionView.cachePrefix + widget.vid))
            const Padding(padding: EdgeInsets.all(16), child: Text('没有更多了哦~')),
        ][index];
      },
      itemCount: 1 +
          (Global.cachedMapVideoList.containsKey(VideoIntroductionView.cachePrefix + widget.vid)
              ? Global.cachedMapVideoList[VideoIntroductionView.cachePrefix + widget.vid]!.key.length
              : 0),
    );
  }
}
