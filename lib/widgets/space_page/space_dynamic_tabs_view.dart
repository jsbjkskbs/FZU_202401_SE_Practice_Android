import 'package:dio/dio.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fulifuli_app/model/activity.dart';
import 'package:fulifuli_app/utils/toastification.dart';
import 'package:fulifuli_app/widgets/dynamic_card.dart';
import 'package:fulifuli_app/widgets/empty_placeholder.dart';

import '../../global.dart';

class SpaceDynamicTabsView extends StatefulWidget {
  const SpaceDynamicTabsView({
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
  State<SpaceDynamicTabsView> createState() {
    return _SpaceDynamicTabsViewState();
  }
}

class _SpaceDynamicTabsViewState extends State<SpaceDynamicTabsView> {
  final EasyRefreshController _easyRefreshController = EasyRefreshController(
    controlFinishLoad: true,
    controlFinishRefresh: true,
  );

  int pageNum = 0;
  bool isEnd = false;
  static const int pageSize = 10;

  @override
  void initState() {
    super.initState();

    var widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((_) {
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
          Global.cachedMapDynamicList[widget.uniqueKey] = const MapEntry([], false);
          var result = await _fetchData();
          if (result != null) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
            }
          }
          _easyRefreshController.finishRefresh();
          setState(() {});
        },
        onLoad: () async {
          if (isEnd) {
            ToastificationUtils.showSimpleToastification(context, AppLocalizations.of(context)!.home_page_refresher_no_more_text);
            _easyRefreshController.finishLoad();
            return;
          }

          var result = await _fetchData();
          if (result != null) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
            }
          }
          _easyRefreshController.finishLoad();
          setState(() {});
        },
        scrollController: widget.controller,
        childBuilder: (BuildContext context, ScrollPhysics physics) {
          return ListView.separated(
            physics: physics,
            itemCount:
                Global.cachedMapDynamicList.containsKey(widget.uniqueKey) ? Global.cachedMapDynamicList[widget.uniqueKey]!.key.length : 1,
            itemBuilder: (context, index) {
              return Global.cachedMapDynamicList.containsKey(widget.uniqueKey)
                  ? DynamicCard(
                      data: Global.cachedMapDynamicList[widget.uniqueKey]!.key[index],
                    )
                  : const EmptyPlaceHolder();
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider();
            },
          );
        });
  }

  Future<String?> _fetchData() async {
    if (!Global.cachedMapDynamicList.containsKey(widget.uniqueKey)) {
      Global.cachedMapDynamicList[widget.uniqueKey] = const MapEntry([], false);
    }

    Response response;
    response = await Global.dio.get('/api/v1/activity/list', data: {
      "user_id": widget.uniqueKey,
      "page_num": pageNum,
      "page_size": pageSize,
    });
    if (response.data["code"] == Global.successCode) {
      var list = <Activity>[];
      for (var item in response.data["data"]["items"]) {
        list.add(Activity.fromJson(item));
      }
      if (response.data["data"]["is_end"]) {
        isEnd = true;
      } else {
        pageNum++;
      }
      Global.cachedMapDynamicList[widget.uniqueKey] = MapEntry([...Global.cachedMapDynamicList[widget.uniqueKey]!.key, ...list], isEnd);
      return null;
    } else {
      return response.data["message"];
    }
  }
}
