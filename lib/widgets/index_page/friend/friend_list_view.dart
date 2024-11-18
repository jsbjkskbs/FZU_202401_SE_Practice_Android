import 'package:dio/dio.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:fulifuli_app/pages/space.dart';
import 'package:fulifuli_app/widgets/index_page/friend/friend_item.dart';

import '../../../global.dart';
import '../../../model/user.dart';
import '../../../utils/toastification.dart';

class FriendListView extends StatefulWidget {
  const FriendListView({super.key});

  static const String uniqueKey = "friend";

  @override
  State<StatefulWidget> createState() {
    return _FriendListViewState();
  }
}

class _FriendListViewState extends State<FriendListView> {
  int pageNum = 0;
  bool isEnd = false;
  final EasyRefreshController _controller = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  @override
  void initState() {
    super.initState();
    if (Global.cachedMapUserList[FriendListView.uniqueKey] == null) {
      Global.cachedMapUserList[FriendListView.uniqueKey] = const MapEntry([], false);
    }
    var widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((callback) {
      if (Global.cachedMapUserList[FriendListView.uniqueKey]!.key.isEmpty) {
        _controller.callRefresh();
      }
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
          Global.cachedMapUserList[FriendListView.uniqueKey] = const MapEntry([], false);
          isEnd = false;
          Response response;
          response = await Global.dio.get('/api/v1/relation/friend/list', data: {
            'page_num': 0,
            'page_size': 10,
          });
          if (response.data['code'] == Global.successCode) {
            var list = <User>[];
            for (var item in response.data['data']['items']) {
              var user = User.fromJson(item);
              Response r;
              r = await Global.dio.get('/api/v1/user/follower_count', data: {
                'user_id': user.id,
              });
              if (r.data['code'] == Global.successCode) {
                user.followerCount = r.data['data']['follower_count'];
              } else {
                user.followerCount = 0;
              }
              list.add(user);
              Global.cachedMapUser[user.id!] = user;
            }

            isEnd = response.data['data']['is_end'];
            if (isEnd) {
              if (context.mounted) {
                ToastificationUtils.showSimpleToastification(context, '没有更多数据了');
              }
            }
            Global.cachedMapUserList[FriendListView.uniqueKey] = MapEntry(list, isEnd);
            setState(() {});
          }
          _controller.finishRefresh();
        },
        onLoad: () async {
          if (isEnd) {
            ToastificationUtils.showSimpleToastification(context, '没有更多数据了');
            _controller.finishLoad();
            return;
          }
          Response response;
          response = await Global.dio.get('/api/v1/relation/friend/list', data: {
            'page_num': pageNum,
            'page_size': 10,
          });
          if (response.data['code'] == Global.successCode) {
            var list = <User>[];
            for (var item in response.data['data']['items']) {
              var user = User.fromJson(item);
              Response r;
              r = await Global.dio.get('/api/v1/user/follower_count', data: {
                'user_id': user.id,
              });
              if (r.data['code'] == Global.successCode) {
                user.followerCount = r.data['data']['follower_count'];
              } else {
                user.followerCount = 0;
              }
              list.add(user);
              Global.cachedMapUser[user.id!] = user;
            }

            isEnd = response.data['data']['is_end'];
            if (isEnd) {
              if (context.mounted) {
                ToastificationUtils.showSimpleToastification(context, '没有更多数据了');
              }
            } else {
              pageNum++;
            }
            Global.cachedMapUserList[FriendListView.uniqueKey] =
                MapEntry([...Global.cachedMapUserList[FriendListView.uniqueKey]!.key, ...list], isEnd);
            setState(() {});
          }
          _controller.finishLoad();
        },
        child: ListView.separated(
            itemBuilder: (context, index) {
              return FriendItem(
                  onTap: () {
                    Navigator.of(context).pushNamed(SpacePage.routeName, arguments: {
                      'user_id': Global.cachedMapUserList[FriendListView.uniqueKey]!.key[index].id,
                    });
                  },
                  userId: Global.cachedMapUserList[FriendListView.uniqueKey]!.key[index].id!);
            },
            separatorBuilder: (context, index) => const Divider(),
            itemCount: Global.cachedMapUserList[FriendListView.uniqueKey]!.key.length));
  }
}
