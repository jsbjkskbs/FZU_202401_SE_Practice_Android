import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fulifuli_app/global.dart';
import 'package:fulifuli_app/utils/toastification.dart';
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
  int pageNum = 0;
  bool isEnd = false;

  @override
  void initState() {
    super.initState();
    bool isCached = Global.cachedMapVideoList.containsKey(widget.uniqueKey);
    if (!isCached) {
      Global.cachedMapVideoList.addEntries([MapEntry(widget.uniqueKey, MapEntry(videoList, isEnd))]);
    }
    videoList = Global.cachedMapVideoList[widget.uniqueKey]!.key;
    isEnd = Global.cachedMapVideoList[widget.uniqueKey]!.value;

    if (isCached) {
      return;
    }
    var widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((_) {
      if (widget.currentIndex == widget.assignedIndex) {
        Global.dio.get("/api/v1/video/list", data: {
          "user_id": widget.uniqueKey,
          "page_num": pageNum,
          "page_size": 10,
        }).then((data) {
          if (data.data["code"] == Global.successCode) {
            for (var item in data.data["data"]["items"]) {
              videoList.add(Video.fromJson(item));
            }
            isEnd = data.data["data"]["is_end"];
            Global.cachedMapVideoList[widget.uniqueKey] = MapEntry(videoList, isEnd);
            setState(() {
              pageNum++;
            });
          }
        });
      }
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(covariant SpaceVideoTabsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (videoList.isEmpty && widget.currentIndex == widget.assignedIndex) {
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
          videoList.clear();
          pageNum = 0;
          Global.dio.get("/api/v1/video/list", data: {
            "user_id": widget.uniqueKey,
            "page_num": pageNum,
            "page_size": 10,
          }).then((data) {
            if (data.data["code"] == Global.successCode) {
              for (var item in data.data["data"]["items"]) {
                videoList.add(Video.fromJson(item));
              }
              isEnd = data.data["data"]["is_end"];
              Global.cachedMapVideoList[widget.uniqueKey] = MapEntry(videoList, isEnd);
              setState(() {
                pageNum++;
              });
            }
          });
          if (context.mounted) {
            ToastificationUtils.showSimpleToastification(context, '刷新成功');
          }
          _easyRefreshController.finishRefresh();
          _easyRefreshController.resetHeader();
          setState(() {});
        },
        onLoad: () async {
          await Future<void>.delayed(const Duration(milliseconds: 500));
          if (isEnd) {
            if (context.mounted) {
              ToastificationUtils.showSimpleToastification(context, '没有更多了');
            }
            _easyRefreshController.finishLoad();
            _easyRefreshController.resetFooter();
            return IndicatorResult.noMore;
          }
          if (!mounted) {
            return IndicatorResult.noMore;
          }
          Global.dio.get("/api/v1/video/list", data: {
            "user_id": widget.uniqueKey,
            "page_num": pageNum,
            "page_size": 10,
          }).then((data) {
            if (data.data["code"] == Global.successCode) {
              for (var item in data.data["data"]["items"]) {
                videoList.add(Video.fromJson(item));
              }
              isEnd = data.data["data"]["is_end"];
              Global.cachedMapVideoList[widget.uniqueKey] = MapEntry(videoList, isEnd);
              setState(() {
                pageNum++;
              });
            }
          });
          if (context.mounted) {
            ToastificationUtils.showSimpleToastification(context, '加载成功');
          }
          _easyRefreshController.finishLoad();
          _easyRefreshController.resetFooter();
          if (isEnd && context.mounted) {
            ToastificationUtils.showSimpleToastification(context, '没有更多了');
            return IndicatorResult.noMore;
          }
          return IndicatorResult.success;
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
