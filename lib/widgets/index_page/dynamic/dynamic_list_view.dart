import 'package:dio/dio.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:fulifuli_app/global.dart';
import 'package:fulifuli_app/model/activity.dart';
import 'package:fulifuli_app/utils/toastification.dart';
import 'package:fulifuli_app/widgets/empty_placeholder.dart';

import '../../dynamic_card.dart';

class DynamicListView extends StatefulWidget {
  const DynamicListView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _DynamicListViewState();
  }
}

class _DynamicListViewState extends State<DynamicListView> {
  bool isEnd = false;
  int pageNum = 0;
  static const pageSize = 10;
  static const _uniqueKey = 'DynamicListView';

  final EasyRefreshController _controller = EasyRefreshController(
    controlFinishLoad: true,
    controlFinishRefresh: true,
  );

  @override
  void initState() {
    super.initState();

    WidgetsBinding widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((_) {
      _controller.callRefresh();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    Global.cachedMapDynamicList.remove(_uniqueKey);
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
        header: const MaterialHeader(),
        footer: const MaterialFooter(),
        controller: _controller,
        onRefresh: () async {
          Global.cachedMapDynamicList.remove(_uniqueKey);
          isEnd = false;
          pageNum = 0;

          String? result = await _fetchData();
          if (result != null) {
            if (context.mounted) {
              ToastificationUtils.showSimpleToastification(context, result);
            }
          } else {
            if (context.mounted) {
              ToastificationUtils.showSimpleToastification(context, '刷新成功');
              setState(() {});
            }
          }
          _controller.finishRefresh();
        },
        onLoad: () async {
          if (isEnd) {
            _controller.finishLoad();
            ToastificationUtils.showSimpleToastification(context, '没有更多了');
            return;
          }
          String? result = await _fetchData();
          if (result != null) {
            if (context.mounted) {
              ToastificationUtils.showSimpleToastification(context, result);
            }
          } else {
            if (context.mounted) {
              ToastificationUtils.showSimpleToastification(context, '加载成功');
              setState(() {});
            }
          }
          _controller.finishLoad();
        },
        child: ListView.separated(
            separatorBuilder: (_, index) => index != 0 ? const SizedBox(height: 16) : const SizedBox(height: 0),
            itemBuilder: (context, index) {
              if (index == 0) {
                return const SizedBox(
                  height: 16,
                );
              }
              return !(Global.cachedMapDynamicList.containsKey(_uniqueKey) && Global.cachedMapDynamicList[_uniqueKey]!.key.isNotEmpty)
                  ? const EmptyPlaceHolder()
                  : DynamicCard(
                      data: Global.cachedMapDynamicList[_uniqueKey]!.key[index - 1],
                    );
            },
            itemCount: Global.cachedMapDynamicList.containsKey(_uniqueKey) ? Global.cachedMapDynamicList[_uniqueKey]!.key.length + 1 : 2));
  }

  Future<String?> _fetchData() async {
    if (!Global.cachedMapDynamicList.containsKey(_uniqueKey)) {
      Global.cachedMapDynamicList[_uniqueKey] = const MapEntry([], false);
    }

    Response response;
    response = await Global.dio.get('/api/v1/activity/feed', data: {
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
      Global.cachedMapDynamicList[_DynamicListViewState._uniqueKey] =
          MapEntry([...Global.cachedMapDynamicList[_uniqueKey]!.key, ...list], isEnd);
      return null;
    } else {
      return response.data["msg"];
    }
  }
}
