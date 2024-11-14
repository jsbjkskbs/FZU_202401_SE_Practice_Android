import 'dart:math';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fulifuli_app/global.dart';
import 'package:fulifuli_app/widgets/video_card.dart';

import '../../../model/video.dart';
import '../../../utils/option_grid_view.dart';

class SpaceVideoTabsView extends StatefulWidget {
  const SpaceVideoTabsView({
    super.key,
    required this.controller,
    required this.currentIndex,
    required this.onUpdate,
    required this.assignedIndex,
    required this.uniqueKey,
  });

  final ScrollController? controller;
  final int currentIndex;
  final Function onUpdate;
  final int assignedIndex;
  final String uniqueKey;

  @override
  State<SpaceVideoTabsView> createState() {
    return _SpaceVideoTabsViewState();
  }
}

class _SpaceVideoTabsViewState extends State<SpaceVideoTabsView> {
  late List<Video> videoList = [];
  late EasyRefreshController _easyRefreshController;

  @override
  void initState() {
    super.initState();
    bool isCached = Global.cachedMapVideoList.containsKey(widget.uniqueKey);
    if (!isCached) {
      Global.cachedMapVideoList.addEntries([MapEntry(widget.uniqueKey, videoList)]);
      debugPrint('Added new video list with key: ${widget.uniqueKey}');
    }
    videoList = Global.cachedMapVideoList[widget.uniqueKey]!;

    if (isCached) {
      return;
    }
    var widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((_) {
      if (widget.currentIndex == widget.assignedIndex) {
        debugPrint('Adding new video item');
        videoList.add(Video(
          id: '1',
          userId: 'user1',
          title: 'Video 1',
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
        ));
      }
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(covariant SpaceVideoTabsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (videoList.isEmpty && widget.currentIndex == widget.assignedIndex) {
      switch (Random().nextInt(3)) {
        case 0:
          videoList.add(Video(
            id: '1',
            userId: 'user1',
            title: 'Video 1',
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
          ));
          break;
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    _easyRefreshController = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );

    TextStyle hintStyle = TextStyle(
      fontSize: Theme.of(context).textTheme.headlineSmall!.fontSize,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).primaryColor,
    );

    return EasyRefresh.builder(
        header: MaterialHeader(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).primaryColor,
          ),
        ),
        footer: ClassicFooter(
          messageStyle: TextStyle(
            fontSize: Theme.of(context).textTheme.labelLarge!.fontSize,
            color: Theme.of(context).primaryColor,
          ),
          textStyle: TextStyle(
            fontSize: Theme.of(context).textTheme.labelLarge!.fontSize,
            color: Theme.of(context).primaryColor,
          ),
          dragText: AppLocalizations.of(context)!.home_page_refresher_drag_text,
          armedText: AppLocalizations.of(context)!.home_page_refresher_armed_text,
          readyText: AppLocalizations.of(context)!.home_page_refresher_ready_text,
          processedText: AppLocalizations.of(context)!.home_page_refresher_processed_text,
          processingText: AppLocalizations.of(context)!.home_page_refresher_processing_text,
          noMoreText: AppLocalizations.of(context)!.home_page_refresher_no_more_text,
          failedText: AppLocalizations.of(context)!.home_page_refresher_failed_text,
          messageText: AppLocalizations.of(context)!.home_page_refresher_message_text,
          iconTheme: IconThemeData(
            color: Theme.of(context).primaryColor,
          ),
        ),
        controller: _easyRefreshController,
        onRefresh: () async {
          await Future<void>.delayed(const Duration(milliseconds: 500));
          if (!mounted) {
            return;
          }
          videoList.add(Video(
            id: '1',
            userId: 'user1',
            title: 'Video 1',
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
          ));
          _easyRefreshController.finishRefresh();
          _easyRefreshController.resetHeader();
          setState(() {});
        },
        onLoad: () async {
          await Future<void>.delayed(const Duration(milliseconds: 4000));
          if (!mounted) {
            return IndicatorResult.noMore;
          }
          _easyRefreshController.finishLoad();
          _easyRefreshController.resetFooter();
          return IndicatorResult.noMore;
        },
        scrollController: widget.controller,
        childBuilder: (BuildContext context, ScrollPhysics physics) {
          return videoList.isEmpty
              ? OptionGridView(
                  itemCount: 1,
                  rowCount: 1,
                  itemBuilder: (_, __) {
                    return SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Image.asset('assets/images/cute/konata_dancing.webp'),
                                Text(
                                  AppLocalizations.of(context)!.space_nothing_hint,
                                  style: hintStyle,
                                ),
                              ],
                            ),
                            const SizedBox(),
                            Text(
                              AppLocalizations.of(context)!.space_nothing_hint_bottom,
                              style: hintStyle,
                            ),
                            const SizedBox()
                          ],
                        ));
                  })
              : OptionGridView(
                  physics: physics,
                  itemCount: videoList.length,
                  rowCount: 2,
                  itemBuilder: (context, index) {
                    return VideoCard(video: videoList[index]);
                  },
                );
        });
  }
}
