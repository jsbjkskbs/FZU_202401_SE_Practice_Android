import 'package:dio/dio.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:fulifuli_app/model/activity.dart';
import 'package:fulifuli_app/widgets/dynamic_card.dart';
import 'package:fulifuli_app/widgets/empty_placeholder.dart';

import '../../global.dart';
import '../load_footer.dart';

class SpaceDynamicTabsView extends StatefulWidget {
  const SpaceDynamicTabsView({
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
  static String uniqueKey = "SpaceDynamicTabsView";

  @override
  State<SpaceDynamicTabsView> createState() {
    return _SpaceDynamicTabsViewState();
  }
}

class _SpaceDynamicTabsViewState extends State<SpaceDynamicTabsView> {
  late String key = '${SpaceDynamicTabsView.uniqueKey}/${widget.userId}';
  final EasyRefreshController _easyRefreshController = EasyRefreshController(
    controlFinishLoad: true,
    controlFinishRefresh: true,
  );

  int pageNum = 0;
  bool isEnd = false;
  static const int pageSize = 10;

  @override
  void dispose() {
    super.dispose();
    _easyRefreshController.dispose();
  }

  @override
  void initState() {
    super.initState();

    var widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((_) {
      if (!Global.cachedMapVideoList.containsKey(key)) {
        Global.cachedMapVideoList[key] = const MapEntry([], false);
        setState(() {});
      }
      if (Global.cachedMapVideoList[key]!.key.isEmpty && Global.cachedMapVideoList[key]!.value == false) {
        _easyRefreshController.callRefresh();
      }
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
        footer: LoadFooter.buildInformationFooter(context),
        controller: _easyRefreshController,
        onRefresh: () async {
          pageNum = 0;
          isEnd = false;
          Global.cachedMapDynamicList[key] = const MapEntry([], false);
          var result = await _fetchData();
          if (result != null) {
            _easyRefreshController.finishRefresh();
            return;
          }
          setState(() {});
          _easyRefreshController.finishRefresh();
        },
        onLoad: () async {
          if (isEnd) {
            _easyRefreshController.finishLoad(IndicatorResult.noMore, true);
            return;
          }

          var result = await _fetchData();
          if (result != null) {
            _easyRefreshController.finishLoad();
            return;
          }
          setState(() {});
          _easyRefreshController.finishLoad();
        },
        scrollController: widget.controller,
        childBuilder: (BuildContext context, ScrollPhysics physics) {
          return ListView.separated(
            physics: physics,
            itemCount: Global.cachedMapDynamicList.containsKey(key) && Global.cachedMapDynamicList[key]!.key.isNotEmpty
                ? Global.cachedMapDynamicList[key]!.key.length
                : 1,
            itemBuilder: (context, index) {
              return Global.cachedMapDynamicList.containsKey(key) && Global.cachedMapDynamicList[key]!.key.isNotEmpty
                  ? DynamicCard(
                      data: Global.cachedMapDynamicList[key]!.key[index],
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
    if (!Global.cachedMapDynamicList.containsKey(key)) {
      Global.cachedMapDynamicList[key] = const MapEntry([], false);
    }

    Response response;
    response = await Global.dio.get('/api/v1/activity/list', data: {
      "user_id": widget.userId,
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
      Global.cachedMapDynamicList[key] = MapEntry([...Global.cachedMapDynamicList[key]!.key, ...list], isEnd);
      return null;
    } else {
      return response.data["msg"];
    }
  }
}
