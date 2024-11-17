import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:fulifuli_app/widgets/index_page/friend/friend_item.dart';

import '../../../global.dart';
import '../../../model/user.dart';

class FriendListView extends StatefulWidget {
  const FriendListView({super.key});

  static const String uniqueKey = "friend";

  @override
  State<StatefulWidget> createState() {
    return _FriendListViewState();
  }
}

class _FriendListViewState extends State<FriendListView> {
  List<User> userList = [];
  final EasyRefreshController _controller = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  @override
  void initState() {
    super.initState();

    bool isCached = Global.cachedMapUserList.containsKey(FriendListView.uniqueKey);
    if (!isCached) {
      Global.cachedMapUserList.addEntries([const MapEntry(FriendListView.uniqueKey, MapEntry([], false))]);
      debugPrint('Added new user list with key: ${FriendListView.uniqueKey}');
    }
    userList = Global.cachedMapUserList[FriendListView.uniqueKey]!.key;

    if (isCached) {
      return;
    }

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
          await Future.delayed(const Duration(seconds: 2), () {
            _controller.finishRefresh();
          });
        },
        onLoad: () async {
          await Future.delayed(const Duration(seconds: 2), () {
            _controller.finishLoad();
          });
        },
        child: ListView.separated(
            itemBuilder: (context, index) {
              return FriendItem(onTap: () {});
            },
            separatorBuilder: (context, index) => const Divider(),
            itemCount: userList.length));
  }
}
