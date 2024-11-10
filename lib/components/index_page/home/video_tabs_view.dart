import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fulifuli_app/components/index_page/home/video_card.dart';
import 'package:fulifuli_app/global.dart';

import '../../../model/video.dart';
import '../../../utils/option_grid_view.dart';

class VideoTabsView extends StatefulWidget {
  const VideoTabsView(
      {super.key,
      required this.controller,
      required this.currentIndex,
      required this.onUpdate,
      required this.assignedIndex});

  final ScrollController controller;
  final int currentIndex;
  final Function onUpdate;
  final int assignedIndex;

  @override
  State<VideoTabsView> createState() {
    return _VideoTabsViewState();
  }
}

class _VideoTabsViewState extends State<VideoTabsView> {
  double _lastMoveY = 0;
  late List<Video> videoList = [];
  final EasyRefreshController _easyRefreshController = EasyRefreshController();

  @override
  void initState() {
    super.initState();
    videoList = Global.cachedVideoList[widget.assignedIndex];
  }

  @override
  void didUpdateWidget(covariant VideoTabsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      if (videoList.isEmpty && widget.currentIndex == widget.assignedIndex) {
        _easyRefreshController.callRefresh();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerMove: (PointerMoveEvent event) {
        var position = event.position.distance;
        var delta = position - _lastMoveY;
        if (delta > 0) {
          widget.controller.animateTo(
            widget.controller.position.minScrollExtent,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        } else {
          widget.controller.animateTo(
            widget.controller.position.maxScrollExtent,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        }
        _lastMoveY = position;
      },
      child: EasyRefresh(
        header: MaterialHeader(
          valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
          backgroundColor: Theme.of(context).cardColor,
          completeDuration: const Duration(milliseconds: 500),
        ),
        footer: MaterialFooter(
          valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
          backgroundColor: Theme.of(context).cardColor,
          completeDuration: const Duration(milliseconds: 500),
        ),
        controller: _easyRefreshController,
        enableControlFinishRefresh: true,
        enableControlFinishLoad: true,
        onRefresh: () async {
          await Future<void>.delayed(const Duration(milliseconds: 500));
          if (!mounted) {
            return;
          }
          videoList.add(
            Video(
              id: '1',
              userId: 'user1',
              title: 'Video 21',
              description: 'Description 1',
              category: 'Category 1',
              labels: ['label1', 'label2'],
              coverUrl: 'http://example.com/cover1.jpg',
              videoUrl: 'http://example.com/video1.mp4',
              viewCount: 100,
              likeCount: 10,
              commentCount: 5,
              createdAt: 1633036800,
              updatedAt: 1633123200,
              deletedAt: 0,
              status: 'active',
            ),
          );
          _easyRefreshController.finishRefresh();
          setState(() {});
        },
        onLoad: () async {
          await Future<void>.delayed(const Duration(milliseconds: 4000));
          debugPrint('onLoad');
          if (!mounted) {
            return;
          }
          _easyRefreshController.finishLoad(noMore: false);
        },
        child: OptionGridView(
          itemCount: videoList.length,
          rowCount: 2,
          itemBuilder: (context, index) {
            return VideoCard(video: videoList[index]);
          },
        ),
      ),
    );
  }
}
