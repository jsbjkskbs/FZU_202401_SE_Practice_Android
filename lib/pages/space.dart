import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fulifuli_app/global.dart';
import 'package:fulifuli_app/widgets/empty_placeholder.dart';
import 'package:fulifuli_app/widgets/space_page/space_tabs_container.dart';
import 'package:fulifuli_app/widgets/space_page/space_video_tabs_view.dart';

import '../model/user.dart';
import '../widgets/space_page/profile.dart';
import '../widgets/space_page/space_dynamic_tabs_view.dart';

class SpacePage extends StatefulWidget {
  const SpacePage({super.key, required this.userId});

  static String routeName = '/space';
  final String userId;
  final String uniqueKey = "SpacePage";

  @override
  State<StatefulWidget> createState() {
    return _SpacePageState();
  }
}

class _SpacePageState extends State<SpacePage> {
  late String key = '${widget.uniqueKey}/${widget.userId}';

  @override
  void initState() {
    super.initState();

    WidgetsBinding widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((_) async {
      await _fetchData();
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    Global.cachedMapUser.remove(key);
    Global.cachedMapVideoList.remove('${SpaceVideoTabsView.uniqueKey}/${widget.userId}');
    Global.cachedMapDynamicList.remove('${SpaceDynamicTabsView.uniqueKey}/${widget.userId}');
  }

  @override
  Widget build(BuildContext context) {
    return !Global.cachedMapUser.containsKey(key)
        ? SafeArea(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: const EmptyPlaceHolder(),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text('${Global.cachedMapUser[key]!.name}'),
              centerTitle: true,
            ),
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Profile(keyInCachedMapUser: key),
                ),
                SliverFillRemaining(
                    child: SpaceTabsContainer(
                  uniqueKeySuffix: widget.userId,
                  tabs: [
                    AppLocalizations.of(context)!.space_video,
                    AppLocalizations.of(context)!.space_dynamic,
                  ],
                )),
              ],
            ));
  }

  Future<void> _fetchData() async {
    if (!Global.cachedMapUser.containsKey(key)) {
      Global.cachedMapUser[key] = User();
    }

    var user = Global.cachedMapUser[widget.userId];
    Response response = await Global.dio.get("/api/v1/user/info", data: {
      "user_id": widget.userId,
    });
    if (response.data["code"] == Global.successCode) {
      user = User.fromJson(response.data["data"]);
    }
    response = await Global.dio.get("/api/v1/user/follower_count", data: {
      "user_id": widget.userId,
    });
    if (response.data["code"] == Global.successCode) {
      user!.followerCount = response.data["data"]["follower_count"];
    }
    response = await Global.dio.get("/api/v1/user/following_count", data: {
      "user_id": widget.userId,
    });
    if (response.data["code"] == Global.successCode) {
      user!.followingCount = response.data["data"]["following_count"];
    }
    response = await Global.dio.get("/api/v1/user/like_count", data: {
      "user_id": widget.userId,
    });
    if (response.data["code"] == Global.successCode) {
      user!.likeCount = response.data["data"]["like_count"];
    }
    Global.cachedMapUser[key] = user!;
  }
}
