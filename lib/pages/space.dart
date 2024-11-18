import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fulifuli_app/global.dart';
import 'package:fulifuli_app/widgets/empty_placeholder.dart';
import 'package:fulifuli_app/widgets/space_page/space_tabs_container.dart';

import '../model/user.dart';
import '../widgets/space_page/profile.dart';

class SpacePage extends StatefulWidget {
  const SpacePage({super.key});

  static String routeName = '/space';

  @override
  State<StatefulWidget> createState() {
    return _SpacePageState();
  }
}

class _SpacePageState extends State<SpacePage> {
  late String userId = "";
  User? user;

  @override
  void initState() {
    super.initState();

    WidgetsBinding widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((_) {});
  }

  @override
  void dispose() {
    super.dispose();
    Global.cachedMapVideoList.remove(userId);
    Global.cachedMapDynamicList.remove(userId);
  }

  @override
  Widget build(BuildContext context) {
    Timer.run(() {
      dynamic args = ModalRoute.of(context)!.settings.arguments;
      if (args != null && args["user_id"] != null) {
        userId = args['user_id'];
      }
      if (userId.isEmpty) {
        Navigator.of(context).pop();
      }
      fetchData(context);
      setState(() {});
    });

    return user == null
        ? const Center(
            child: EmptyPlaceHolder(),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text('${user!.name}'),
              centerTitle: true,
            ),
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Profile(userId: user!.id!),
                ),
                SliverFillRemaining(
                    child: SpaceTabsContainer(
                  uniqueKey: userId,
                  tabs: [
                    AppLocalizations.of(context)!.space_video,
                    AppLocalizations.of(context)!.space_dynamic,
                  ],
                )),
              ],
            ));
  }

  void fetchData(BuildContext context) async {
    if (Global.cachedMapUser.containsKey(userId)) {
      user = Global.cachedMapUser[userId]!;
    } else {
      Response response = await Global.dio.get("/api/v1/user/info", data: {
        "user_id": userId,
      });
      if (response.data["code"] == Global.successCode) {
        user = User.fromJson(response.data["data"]);
      }
    }
    if (user!.followerCount == null) {
      Global.dio.get("/api/v1/user/follower_count", data: {
        "user_id": userId,
      }).then((Response response) {
        user!.followerCount = response.data["data"]["follower_count"];
      });
    }
    if (user!.followingCount == null) {
      Global.dio.get("/api/v1/user/following_count", data: {
        "user_id": userId,
      }).then((Response response) {
        user!.followingCount = response.data["data"]["following_count"];
      });
    }
    if (user!.likeCount == null) {
      Global.dio.get("/api/v1/user/like_count", data: {
        "user_id": userId,
      }).then((Response response) {
        user!.likeCount = response.data["data"]["like_count"];
      });
    }
    Global.cachedMapUser[userId] = user!;
  }
}
