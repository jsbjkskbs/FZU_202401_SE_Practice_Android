import 'package:dio/dio.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:fulifuli_app/pages/space.dart';

import '../global.dart';
import '../model/user.dart';
import '../utils/toastification.dart';
import '../widgets/empty_placeholder.dart';
import '../widgets/search_page/search_page_user_item.dart';

class FollowerPage extends StatefulWidget {
  const FollowerPage({super.key, required this.userId});

  static String routeName = '/follower/list';
  static const uniqueKey = "FollowerPage";

  final String userId;

  @override
  State<StatefulWidget> createState() {
    return _FollowerPageState();
  }
}

class _FollowerPageState extends State<FollowerPage> {
  late String key = "${FollowerPage.uniqueKey}/${widget.userId}";

  final EasyRefreshController _controller = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );
  int pageNum = 0;
  bool isEnd = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((_) {
      if (!Global.cachedMapUserList.containsKey(key)) {
        Global.cachedMapUserList[key] = const MapEntry([], false);
      }
      _controller.callRefresh();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    Global.cachedMapUserList.remove(key);
  }

  @override
  Widget build(BuildContext context) {
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
                pageNum = 0;
                isEnd = false;
                Global.cachedMapUserList[key] = const MapEntry([], false);
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
                  ToastificationUtils.showSimpleToastification(context, "没有更多了");
                  _controller.finishLoad();
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
                  return Global.cachedMapUserList.containsKey(key) && Global.cachedMapUserList[key]!.key.isNotEmpty
                      ? SearchPageUserItem(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                              return SpacePage(
                                userId: Global.cachedMapUserList[key]!.key[index].id!,
                              );
                            }));
                          },
                          user: Global.cachedMapUserList[key]!.key[index],
                        )
                      : const EmptyPlaceHolder();
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: Global.cachedMapUserList.containsKey(key) && Global.cachedMapUserList[key]!.key.isNotEmpty
                    ? Global.cachedMapUserList[key]!.key.length
                    : 1,
              ))),
    ));
  }

  Future<String?> _fetchData() async {
    if (!Global.cachedMapUserList.containsKey(key)) {
      Global.cachedMapUserList[key] = const MapEntry([], false);
    }

    Response response;
    response = await Global.dio.get("/api/v1/relation/follower/list", data: {
      "user_id": widget.userId,
      "page_num": pageNum,
      "page_size": 10,
    });
    if (response.data["code"] != Global.successCode) {
      return response.data["msg"];
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
    Global.cachedMapUserList[key] = MapEntry([...Global.cachedMapUserList[key]!.key, ...list], isEnd);
    return null;
  }
}
