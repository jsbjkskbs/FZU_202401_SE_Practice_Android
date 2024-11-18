import 'package:dio/dio.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:fulifuli_app/global.dart';
import 'package:fulifuli_app/pages/space.dart';
import 'package:fulifuli_app/utils/toastification.dart';
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
  List<User> userList = [];
  int pageNum = 0;
  bool? isEnd;
  final EasyRefreshController _controller = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  @override
  void initState() {
    super.initState();
    var widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((callback) {
      _controller.callRefresh();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
        controller: _controller,
        header: const MaterialHeader(),
        footer: const MaterialFooter(),
        onRefresh: () async {
          _fetchData(context);
          _controller.finishRefresh();
        },
        onLoad: () async {
          _fetchData(context);
          _controller.finishLoad();
        },
        child: ListView.separated(
            itemBuilder: (context, index) {
              return SearchPageUserItem(
                onTap: () {
                  Navigator.of(context).pushNamed(SpacePage.routeName, arguments: {"user_id": userList[index].id});
                },
                user: userList[index],
              );
            },
            separatorBuilder: (context, index) => const Divider(),
            itemCount: userList.length));
  }

  void _fetchData(BuildContext context) async {
    if (Global.cachedMapUserList.containsKey(SearchPageUserTabsView.uniqueKey)) {
      userList = Global.cachedMapUserList[SearchPageUserTabsView.uniqueKey]!.key;
      isEnd = Global.cachedMapUserList[SearchPageUserTabsView.uniqueKey]!.value;
      if (isEnd == null || isEnd!) {
        if (context.mounted) {
          ToastificationUtils.showSimpleToastification(context, "没有更多了");
        }
        setState(() {});
        return;
      }
    }
    Response response;
    response = await Global.dio.get("/api/v1/user/search", data: {
      "keyword": widget.keyword,
      "page_num": pageNum,
      "page_size": 10,
    });
    if (response.data["code"] != Global.successCode) {
      if (context.mounted) {
        ToastificationUtils.showSimpleToastification(context, response.data["msg"]);
        return;
      }
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
    userList = [...userList, ...list];
    Global.cachedMapUserList[SearchPageUserTabsView.uniqueKey] = MapEntry(userList, response.data["data"]["is_end"]);
    pageNum++;
    if (response.data["data"]["is_end"]) {
      isEnd = true;
      if (context.mounted) {
        ToastificationUtils.showSimpleToastification(context, "没有更多了");
      }
    }
    setState(() {});
  }
}
