import 'package:dio/dio.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:fulifuli_app/pages/space.dart';
import 'package:fulifuli_app/widgets/empty_placeholder.dart';
import 'package:fulifuli_app/widgets/index_page/friend/friend_item.dart';
import 'package:fulifuli_app/widgets/load_footer.dart';

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
    var widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((callback) {
      if (Global.cachedMapUserList[FriendListView.uniqueKey] == null) {
        Global.cachedMapUserList[FriendListView.uniqueKey] = const MapEntry([], false);
      }
      if (Global.cachedMapUserList[FriendListView.uniqueKey]!.key.isEmpty &&
          Global.cachedMapUserList[FriendListView.uniqueKey]!.value == false) {
        _controller.callRefresh();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    // if not necessary, don't remove the cache
    // Global.cachedMapUserList.remove(FriendListView.uniqueKey);
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
        controller: _controller,
        header: const MaterialHeader(),
        footer: LoadFooter.buildInformationFooter(context),
        onRefresh: () async {
          pageNum = 0;
          isEnd = false;
          Global.cachedMapUserList[FriendListView.uniqueKey] = const MapEntry([], false);

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
            _controller.finishLoad(IndicatorResult.noMore, true);
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
              return Global.cachedMapUserList.containsKey(FriendListView.uniqueKey) &&
                      Global.cachedMapUserList[FriendListView.uniqueKey]!.key.isNotEmpty
                  ? FriendItem(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                          return SpacePage(userId: Global.cachedMapUserList[FriendListView.uniqueKey]!.key[index].id!);
                        }));
                      },
                      userId: Global.cachedMapUserList[FriendListView.uniqueKey]!.key[index].id!)
                  : const EmptyPlaceHolder();
            },
            separatorBuilder: (context, index) => const Divider(),
            itemCount: Global.cachedMapUserList.containsKey(FriendListView.uniqueKey) &&
                    Global.cachedMapUserList[FriendListView.uniqueKey]!.key.isNotEmpty
                ? Global.cachedMapUserList[FriendListView.uniqueKey]!.key.length
                : 1));
  }

  Future<String?> _fetchData() async {
    if (!Global.cachedMapUserList.containsKey(FriendListView.uniqueKey)) {
      Global.cachedMapUserList[FriendListView.uniqueKey] = const MapEntry([], false);
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

      if (response.data['data']['is_end']) {
        isEnd = true;
      } else {
        pageNum++;
      }
      Global.cachedMapUserList[FriendListView.uniqueKey] =
          MapEntry([...Global.cachedMapUserList[FriendListView.uniqueKey]!.key, ...list], isEnd);
    } else {
      return response.data['msg'];
    }
    return null;
  }
}
