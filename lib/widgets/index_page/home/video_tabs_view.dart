import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:fulifuli_app/global.dart';
import 'package:fulifuli_app/utils/toastification.dart';

import '../../../model/video.dart';
import '../../../utils/option_grid_view.dart';
import '../../video_card.dart';

class VideoTabsView extends StatefulWidget {
  const VideoTabsView(
      {super.key,
      required this.controller,
      required this.currentIndex,
      required this.onUpdate,
      required this.assignedIndex,
      this.category});

  final ScrollController controller;
  final int currentIndex;
  final Function onUpdate;
  final int assignedIndex;
  final String? category;

  @override
  State<VideoTabsView> createState() {
    return _VideoTabsViewState();
  }
}

class _VideoTabsViewState extends State<VideoTabsView> {
  static const int _n = 10;
  late List<Video> videoList;
  int offset = 0;
  bool isEnd = false;
  final EasyRefreshController _easyRefreshController = EasyRefreshController(
    controlFinishLoad: true,
    controlFinishRefresh: true,
  );

  @override
  void initState() {
    super.initState();
    videoList = Global.cachedVideoList[widget.assignedIndex.toString()]!.key;
    isEnd = Global.cachedVideoList[widget.assignedIndex.toString()]!.value;
    WidgetsBinding widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((_) {
      if (videoList.isEmpty && widget.currentIndex == widget.assignedIndex) {
        _easyRefreshController.callRefresh();
      }
    });
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
    return EasyRefresh.builder(
        header: BezierCircleHeader(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Theme.of(context).scaffoldBackgroundColor,
          springRebound: true,
        ),
        footer: BezierFooter(
          foregroundColor: Theme.of(context).scaffoldBackgroundColor,
          backgroundColor: Theme.of(context).primaryColor,
          spinWidget: SizedBox(
            width: 25,
            height: 25,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).scaffoldBackgroundColor),
              strokeWidth: 4,
            ),
          ),
          springRebound: true,
        ),
        controller: _easyRefreshController,
        onRefresh: () async {
          await Future<void>.delayed(const Duration(milliseconds: 500));
          if (isEnd) {
            if (context.mounted) {
              ToastificationUtils.showSimpleToastification(context, '没有更多了');
            }
            _easyRefreshController.finishRefresh();
            _easyRefreshController.resetHeader();
            return;
          }
          if (!mounted) {
            return;
          }
          if (Global.self.accessToken != null && Global.self.accessToken!.isNotEmpty) {
            Global.dio.get('/api/v1/video/custom/feed', data: {
              "offset": offset,
              "n": _n,
              if (widget.category != null) "category": widget.category,
            }).then((data) {
              List<Video> list = [];
              for (var item in data.data["data"]["items"]) {
                list.add(Video.fromJson(item));
              }
              if (list.isEmpty) {
                isEnd = true;
                if (context.mounted) {
                  ToastificationUtils.showSimpleToastification(context, '没有更多了');
                }
              } else {
                offset += _n;
              }
              videoList = [...list, ...videoList];
              Global.cachedVideoList[widget.assignedIndex.toString()] = MapEntry(videoList, isEnd);
              setState(() {});
            });
          } else {
            Global.dio.get('/api/v1/video/feed', data: {
              "offset": offset,
              "n": _n,
              if (widget.category != null) "category": widget.category,
            }).then((data) {
              List<Video> list = [];
              for (var item in data.data["data"]["items"]) {
                list.add(Video.fromJson(item));
              }
              if (list.isEmpty) {
                isEnd = true;
                if (context.mounted) {
                  ToastificationUtils.showSimpleToastification(context, '没有更多了');
                }
              } else {
                offset += _n;
              }
              videoList = [...list, ...videoList];
              Global.cachedVideoList[widget.assignedIndex.toString()] = MapEntry(videoList, isEnd);
              setState(() {});
            });
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
          if (Global.self.accessToken != null && Global.self.accessToken!.isNotEmpty) {
            Global.dio.get('/api/v1/video/custom/feed', data: {
              "offset": offset,
              "n": _n,
              if (widget.category != null) "category": widget.category,
            }).then((data) {
              List<Video> list = [];
              for (var item in data.data["data"]["items"]) {
                list.add(Video.fromJson(item));
              }
              if (list.isEmpty) {
                isEnd = true;
                if (context.mounted) {
                  ToastificationUtils.showSimpleToastification(context, '没有更多了');
                }
              } else {
                offset += _n;
              }
              videoList = [...videoList, ...list];
              Global.cachedVideoList[widget.assignedIndex.toString()] = MapEntry(videoList, isEnd);
              setState(() {});
            });
          } else {
            Global.dio.get('/api/v1/video/feed', data: {
              "offset": offset,
              "n": _n,
              if (widget.category != null) "category": widget.category,
            }).then((data) {
              List<Video> list = [];
              for (var item in data.data["data"]["items"]) {
                list.add(Video.fromJson(item));
              }
              if (list.isEmpty) {
                isEnd = true;
                if (context.mounted) {
                  ToastificationUtils.showSimpleToastification(context, '没有更多了');
                }
              } else {
                offset += _n;
              }
              videoList = [...videoList, ...list];
              Global.cachedVideoList[widget.assignedIndex.toString()] = MapEntry(videoList, isEnd);
              setState(() {});
            });
          }
          _easyRefreshController.finishLoad();
          _easyRefreshController.resetFooter();
          if (isEnd) {
            return IndicatorResult.noMore;
          }
          return IndicatorResult.success;
        },
        childBuilder: (BuildContext context, ScrollPhysics physics) {
          return OptionGridView(
            physics: physics,
            itemCount: videoList.length,
            rowCount: 2,
            controller: widget.controller,
            itemBuilder: (context, index) {
              return VideoCard(video: videoList[index]);
            },
          );
        });
  }
}
