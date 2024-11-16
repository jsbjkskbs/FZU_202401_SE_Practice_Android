import 'package:flutter/material.dart';
import 'package:fulifuli_app/test.dart';
import 'package:fulifuli_app/widgets/search_page/search_page_video_item.dart';
import 'package:fulifuli_app/widgets/video_page/video_profile_view.dart';

class VideoIntroductionView extends StatefulWidget {
  const VideoIntroductionView({super.key, required this.controller});

  final ScrollController controller;

  @override
  State<StatefulWidget> createState() {
    return _VideoIntroductionViewState();
  }
}

class _VideoIntroductionViewState extends State<VideoIntroductionView> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: widget.controller,
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          height: 8,
          color: Theme.of(context).dialogBackgroundColor,
        );
      },
      itemBuilder: (BuildContext context, int index) {
        return [
          const VideoProfileView(),
          for (var i = 0; i < 10; i++) SearchPageVideoItem(onTap: () {}, data: videoListForTest[0]),
        ][index];
      },
      itemCount: 1 + 10,
    );
  }
}
