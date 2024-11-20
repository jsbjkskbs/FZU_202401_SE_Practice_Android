import 'dart:math';

import 'package:dio/dio.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
  int offset = 0;
  UniqueKey _gridViewKey = UniqueKey();
  final EasyRefreshController _easyRefreshController = EasyRefreshController(
    controlFinishLoad: true,
    controlFinishRefresh: true,
  );

  @override
  void initState() {
    super.initState();
    offset = Global.cachedVideoList[widget.assignedIndex.toString()]!.value;
    WidgetsBinding widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((_) async {
      if (Global.cachedVideoList[widget.assignedIndex.toString()]!.key.isEmpty) {
        // _easyRefreshController.callRefresh();
        // avoid refresh action stopped by user
        await _fetchVideoFeedAndAddFront();
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh.builder(
        header: const MaterialHeader(),
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
          if (offset == -1) {
            if (context.mounted) {
              ToastificationUtils.showSimpleToastification(context, AppLocalizations.of(context)!.home_page_no_more);
            }
            offset = Random().nextInt(_n);
            Global.cachedVideoList[widget.assignedIndex.toString()] = MapEntry([], offset);
          }
          var oldLength = Global.cachedVideoList[widget.assignedIndex.toString()]!.key.length;
          await _fetchVideoFeedAndAddFront();
          setState(() {
            _gridViewKey = UniqueKey();
            // force rebuild, otherwise the gridview will not be refreshed
          });
          if (offset == -1) {
            if (context.mounted) {
              ToastificationUtils.showSimpleToastification(context, AppLocalizations.of(context)!.home_page_no_more);
            }
          } else {
            if (context.mounted) {
              ToastificationUtils.showSimpleToastification(
                  context,
                  AppLocalizations.of(context)!
                      .home_page_get_data_count(Global.cachedVideoList[widget.assignedIndex.toString()]!.key.length - oldLength));
            }
          }
          _easyRefreshController.finishRefresh();
        },
        onLoad: () async {
          if (offset == -1) {
            ToastificationUtils.showSimpleToastification(context, AppLocalizations.of(context)!.home_page_no_more);
            _easyRefreshController.finishLoad();
            return;
          }
          var oldLength = Global.cachedVideoList[widget.assignedIndex.toString()]!.key.length;
          await _fetchVideoFeedAndAddBack();
          setState(() {
            // _gridViewKey = UniqueKey();
            // force rebuilding would reset the scroll position, so we just update the list
          });
          if (offset == -1) {
            if (context.mounted) {
              ToastificationUtils.showSimpleToastification(context, AppLocalizations.of(context)!.home_page_no_more);
            }
          } else {
            if (context.mounted) {
              ToastificationUtils.showSimpleToastification(
                  context,
                  AppLocalizations.of(context)!
                      .home_page_get_data_count(Global.cachedVideoList[widget.assignedIndex.toString()]!.key.length - oldLength));
            }
          }
          _easyRefreshController.finishLoad();
        },
        childBuilder: (BuildContext context, ScrollPhysics physics) {
          return OptionGridView(
            key: _gridViewKey,
            physics: physics,
            itemCount: Global.cachedVideoList[widget.assignedIndex.toString()]!.key.length,
            rowCount: 2,
            controller: widget.controller,
            itemBuilder: (context, index) {
              return VideoCard(video: Global.cachedVideoList[widget.assignedIndex.toString()]!.key[index]);
            },
          );
        });
  }

  Future<void> _fetchVideoFeedAndAddFront() async {
    Response response;
    if (Global.self.accessToken != null && Global.self.accessToken!.isNotEmpty) {
      response = await Global.dio.get('/api/v1/video/custom/feed', data: {
        "offset": offset,
        "n": _n,
        if (widget.category != null) "category": widget.category,
      });
      if (response.data["code"] != Global.successCode) {
        return;
      }
      List<Video> list = [];
      for (var item in response.data["data"]["items"]) {
        list.add(Video.fromJson(item));
      }
      if (list.isEmpty) {
        offset = -1;
      } else {
        offset += _n;
      }
      Global.cachedVideoList[widget.assignedIndex.toString()] =
          MapEntry([...list, ...Global.cachedVideoList[widget.assignedIndex.toString()]!.key], offset);
    } else {
      response = await Global.dio.get('/api/v1/video/feed', data: {
        "offset": offset,
        "n": _n,
        if (widget.category != null) "category": widget.category,
      });
      if (response.data["code"] != Global.successCode) {
        return;
      }
      List<Video> list = [];
      for (var item in response.data["data"]["items"]) {
        list.add(Video.fromJson(item));
      }
      if (list.isEmpty) {
        offset = -1;
      } else {
        offset += _n;
      }
      Global.cachedVideoList[widget.assignedIndex.toString()] =
          MapEntry([...list, ...Global.cachedVideoList[widget.assignedIndex.toString()]!.key], offset);
    }
  }

  Future<void> _fetchVideoFeedAndAddBack() async {
    Response response;
    if (Global.self.accessToken != null && Global.self.accessToken!.isNotEmpty) {
      response = await Global.dio.get('/api/v1/video/custom/feed', data: {
        "offset": offset,
        "n": _n,
        if (widget.category != null) "category": widget.category,
      });
      if (response.data["code"] != Global.successCode) {
        return;
      }
      List<Video> list = [];
      for (var item in response.data["data"]["items"]) {
        list.add(Video.fromJson(item));
      }
      if (list.isEmpty) {
        offset = -1;
      } else {
        offset += _n;
      }
      Global.cachedVideoList[widget.assignedIndex.toString()] =
          MapEntry([...Global.cachedVideoList[widget.assignedIndex.toString()]!.key, ...list], offset);
    } else {
      response = await Global.dio.get('/api/v1/video/feed', data: {
        "offset": offset,
        "n": _n,
        if (widget.category != null) "category": widget.category,
      });
      if (response.data["code"] != Global.successCode) {
        return;
      }
      List<Video> list = [];
      for (var item in response.data["data"]["items"]) {
        list.add(Video.fromJson(item));
      }
      if (list.isEmpty) {
        offset = -1;
      } else {
        offset += _n;
      }
      Global.cachedVideoList[widget.assignedIndex.toString()] =
          MapEntry([...Global.cachedVideoList[widget.assignedIndex.toString()]!.key, ...list], offset);
      setState(() {});
    }
  }
}
