import 'package:dio/dio.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:fulifuli_app/global.dart';
import 'package:fulifuli_app/pages/space.dart';
import 'package:fulifuli_app/utils/toastification.dart';
import 'package:fulifuli_app/widgets/empty_placeholder.dart';
import 'package:fulifuli_app/widgets/search_page/search_page_user_item.dart';

import '../../model/user.dart';

class SearchPageUserTabsView extends StatefulWidget {
  const SearchPageUserTabsView({super.key, required this.currentIndex, required this.assignedIndex, required this.keyword});

  static const String uniqueKey = "search-user";
  final String keyword;
  final int currentIndex;
  final int assignedIndex;

  @override
  State<StatefulWidget> createState() {
    return _SearchPageUserTabsViewState();
  }
}

class _SearchPageUserTabsViewState extends State<SearchPageUserTabsView> {
  int pageNum = 0;
  bool isEnd = false;
  final EasyRefreshController _controller = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  @override
  void initState() {
    super.initState();
    var widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((callback) {
      if (!Global.cachedMapUserList.containsKey(SearchPageUserTabsView.uniqueKey)) {
        Global.cachedMapUserList[SearchPageUserTabsView.uniqueKey] = const MapEntry([], false);
      }
      _controller.callRefresh();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    Global.cachedMapUserList.remove(SearchPageUserTabsView.uniqueKey);
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
        controller: _controller,
        header: const MaterialHeader(),
        footer: const MaterialFooter(),
        onRefresh: () async {
          pageNum = 0;
          isEnd = false;
          Global.cachedMapUserList[SearchPageUserTabsView.uniqueKey] = const MapEntry([], false);
          String? result = await _fetchData();
          if (result != null) {
            if (context.mounted) {
              ToastificationUtils.showSimpleToastification(context, result);
            }
            _controller.finishRefresh();
            return;
          }
          setState(() {});
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
            _controller.finishLoad();
            return;
          }
          setState(() {});
          _controller.finishLoad();
        },
        child: ListView.separated(
            itemBuilder: (context, index) {
              return Global.cachedMapUserList.containsKey(SearchPageUserTabsView.uniqueKey) &&
                      Global.cachedMapUserList[SearchPageUserTabsView.uniqueKey]!.key.isNotEmpty
                  ? SearchPageUserItem(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return SpacePage(userId: Global.cachedMapUserList[SearchPageUserTabsView.uniqueKey]!.key[index].id!);
                            },
                          ),
                        );
                      },
                      user: Global.cachedMapUserList[SearchPageUserTabsView.uniqueKey]!.key[index],
                    )
                  : const EmptyPlaceHolder();
            },
            separatorBuilder: (context, index) => const Divider(),
            itemCount: Global.cachedMapUserList.containsKey(SearchPageUserTabsView.uniqueKey) &&
                    Global.cachedMapUserList[SearchPageUserTabsView.uniqueKey]!.key.isNotEmpty
                ? Global.cachedMapUserList[SearchPageUserTabsView.uniqueKey]!.key.length
                : 1));
  }

  Future<String?> _fetchData() async {
    if (!Global.cachedMapUserList.containsKey(SearchPageUserTabsView.uniqueKey)) {
      Global.cachedMapUserList[SearchPageUserTabsView.uniqueKey] = const MapEntry([], false);
    }

    Response response;
    response = await Global.dio.get("/api/v1/user/search", data: {
      "keyword": widget.keyword,
      "page_num": pageNum,
      "page_size": 10,
    });
    if (response.data["code"] != Global.successCode) {
      return response.data["message"];
    }
    List<User> list = [];
    for (var item in response.data["data"]["items"]) {
      var user = User.fromJson(item);
      Response r;
      r = await Global.dio.get("/api/v1/user/follower_count", data: {"user_id": item["id"]});
      if (r.data["code"] != Global.successCode) {
        user.followerCount = -1;
      }
      user.followerCount = r.data["data"]["follower_count"];
      list.add(user);
    }
    if (response.data["data"]["is_end"]) {
      isEnd = true;
    } else {
      pageNum++;
    }
    Global.cachedMapUserList[SearchPageUserTabsView.uniqueKey] =
        MapEntry([...Global.cachedMapUserList[SearchPageUserTabsView.uniqueKey]!.key, ...list], isEnd);
    return null;
  }
}
