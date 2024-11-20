import 'dart:async';

import 'package:dio/dio.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fulifuli_app/global.dart';
import 'package:fulifuli_app/utils/toastification.dart';
import 'package:fulifuli_app/widgets/empty_placeholder.dart';
import 'package:fulifuli_app/widgets/video_card.dart';

import '../../../model/video.dart';
import '../../../utils/option_grid_view.dart';

class SpaceVideoTabsView extends StatefulWidget {
  const SpaceVideoTabsView({
    super.key,
    required this.controller,
    required this.currentIndex,
    required this.assignedIndex,
    required this.userId,
  });

  final ScrollController? controller;
  final int currentIndex;
  final int assignedIndex;
  final String userId;
  static String uniqueKey = "SpaceVideoTabsView";

  @override
  State<SpaceVideoTabsView> createState() {
    return _SpaceVideoTabsViewState();
  }
}

class _SpaceVideoTabsViewState extends State<SpaceVideoTabsView> {
  late String key = '${SpaceVideoTabsView.uniqueKey}/${widget.userId}';
  final EasyRefreshController _easyRefreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  int pageNum = 0;
  static const int pageSize = 10;
  bool isEnd = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((_) {
      if (!Global.cachedMapVideoList.containsKey(key)) {
        Global.cachedMapVideoList[key] = const MapEntry([], false);
        setState(() {});
      }
      _easyRefreshController.callRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
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
          pageNum = 0;
          Global.cachedMapVideoList.remove(key);
          String? result = await _fetchData();
          if (result != null) {
            if (context.mounted) {
              ToastificationUtils.showSimpleToastification(context, result);
            }
            _easyRefreshController.finishRefresh();
            return;
          }
          setState(() {});
          _easyRefreshController.finishRefresh();
        },
        onLoad: () async {
          if (isEnd) {
            ToastificationUtils.showSimpleToastification(context, AppLocalizations.of(context)!.home_page_refresher_no_more_text);
            _easyRefreshController.finishLoad();
            return;
          }

          String? result = await _fetchData();
          if (result != null) {
            if (context.mounted) {
              ToastificationUtils.showSimpleToastification(context, result);
            }
            _easyRefreshController.finishLoad();
            return;
          }
          setState(() {});
          _easyRefreshController.finishLoad();
        },
        scrollController: widget.controller,
        childBuilder: (BuildContext context, ScrollPhysics physics) {
          return OptionGridView(
            physics: physics,
            itemCount: Global.cachedMapVideoList.containsKey(key) && Global.cachedMapVideoList[key]!.key.isNotEmpty
                ? Global.cachedMapVideoList[key]!.key.length
                : 1,
            rowCount: Global.cachedMapVideoList.containsKey(key) && Global.cachedMapVideoList[key]!.key.isNotEmpty ? 2 : 1,
            itemBuilder: (context, index) {
              return Global.cachedMapVideoList.containsKey(key) && Global.cachedMapVideoList[key]!.key.isNotEmpty
                  ? VideoCard(video: Global.cachedMapVideoList[key]!.key[index])
                  : const EmptyPlaceHolder();
            },
          );
        });
  }

  Future<String?> _fetchData() async {
    if (!Global.cachedMapVideoList.containsKey(key)) {
      Global.cachedMapVideoList[key] = const MapEntry([], false);
    }

    Response response;
    response = await Global.dio.get('/api/v1/video/list', data: {
      "user_id": widget.userId,
      "page_num": pageNum,
      "page_size": pageSize,
    });

    if (response.data["code"] == Global.successCode) {
      var list = <Video>[];
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
    } else {
      return response.data["message"];
    }
  }
}
