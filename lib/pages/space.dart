import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fulifuli_app/global.dart';
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
    widgetsBinding.addPostFrameCallback((_) {
      if (Global.cachedMapUser.containsKey(userId)) {
        user = Global.cachedMapUser[userId]!;
      } else {
        Global.dio.get("/api/v1/user/info", queryParameters: {"user_id": userId}).then((Response response) {
          if (response.data["code"] == Global.successCode) {
            user = User.fromJson(response.data["data"]);
            Global.cachedMapUser[userId] = user!;
            Global.dio.get("/api/v1/user/follower_count", data: {
              "user_id": userId,
            }).then((Response response) {
              if (response.data["code"] == Global.successCode) {
                Global.cachedMapUser[userId]?.followerCount = response.data["data"]["follower_count"];
                Global.dio.get("/api/v1/user/following_count", data: {
                  "user_id": userId,
                }).then((Response response) {
                  if (response.data["code"] == Global.successCode) {
                    Global.cachedMapUser[userId]?.followingCount = response.data["data"]["following_count"];
                    Global.dio.get("/api/v1/user/like_count", data: {
                      "user_id": userId,
                    }).then((Response response) {
                      if (response.data["code"] == Global.successCode) {
                        Global.cachedMapUser[userId]?.likeCount = response.data["data"]["like_count"];
                        setState(() {});
                      }
                    });
                  }
                });
              }
            });
            setState(() {});
          }
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    Global.cachedMapVideoList.remove(userId);
    Global.cachedMapDynamicList.remove(userId);
    Global.cachedMapUser.remove(userId);
  }

  @override
  Widget build(BuildContext context) {
    dynamic args = ModalRoute.of(context)!.settings.arguments;
    if (args != null && args["user_id"] != null) {
      userId = args['user_id'];
    }
    if (userId.isEmpty) {
      Navigator.of(context).pop();
    }

    return user == null
        ? const Center(
            child: CircularProgressIndicator(),
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
}
