import 'package:dio/dio.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:fulifuli_app/pages/space.dart';

import '../global.dart';
import '../model/user.dart';
import '../utils/toastification.dart';
import '../widgets/search_page/search_page_user_item.dart';

class FollowingPage extends StatefulWidget {
  const FollowingPage({super.key});

  static String routeName = '/following/list';

  @override
  State<StatefulWidget> createState() {
    return _FollowingPageState();
  }
}

class _FollowingPageState extends State<FollowingPage> {
  static const _uniqueKey = "FollowingPage";

  final EasyRefreshController _controller = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );
  List<User> userList = [];
  late String userId;
  int pageNum = 0;
  bool isEnd = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((_) {
      _controller.callRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    userId = args["user_id"];
    if (!Global.cachedMapUserList.containsKey('${_FollowingPageState._uniqueKey}$userId')) {
      Global.cachedMapUserList['$_uniqueKey$userId'] = const MapEntry([], false);
    }

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("粉丝列表"),
        centerTitle: true,
      ),
      body: Center(
          child: EasyRefresh(
              controller: _controller,
              header: const MaterialHeader(),
              footer: const MaterialFooter(),
              onRefresh: () async {
                userList = [];
                pageNum = 0;
                isEnd = false;
                Global.cachedMapUserList['${_FollowingPageState._uniqueKey}$userId'] = const MapEntry([], false);
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
                  itemCount: userList.length))),
    ));
  }

  void _fetchData(BuildContext context) async {
    if (Global.cachedMapUserList.containsKey('${_FollowingPageState._uniqueKey}$userId')) {
      userList = Global.cachedMapUserList['${_FollowingPageState._uniqueKey}$userId']!.key;
      isEnd = Global.cachedMapUserList['${_FollowingPageState._uniqueKey}$userId']!.value;
      if (isEnd) {
        if (context.mounted) {
          ToastificationUtils.showSimpleToastification(context, "没有更多了");
        }
        setState(() {});
        return;
      }
    }
    Response response;
    response = await Global.dio.get("/api/v1/relation/follow/list", data: {
      "user_id": userId,
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
    Global.cachedMapUserList['${_FollowingPageState._uniqueKey}$userId'] = MapEntry(userList, response.data["data"]["is_end"]);
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
