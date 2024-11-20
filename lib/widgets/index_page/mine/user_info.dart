import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fulifuli_app/global.dart';
import 'package:fulifuli_app/pages/followers.dart';
import 'package:fulifuli_app/pages/following.dart';
import 'package:fulifuli_app/pages/login.dart';
import 'package:fulifuli_app/utils/number_converter.dart';
import 'package:fulifuli_app/utils/toastification.dart';

class UserInfoView extends StatefulWidget {
  const UserInfoView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _UserInfoViewState();
  }
}

class _UserInfoViewState extends State<UserInfoView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((_) {
      if (Global.self.isValidUser()) {
        Global.dio.get('/api/v1/user/follower_count', data: {
          'user_id': Global.self.id,
        }).then((Response response) {
          if (response.data['code'] == Global.successCode) {
            Global.self.followerCount = response.data['data']['follower_count'];
            Global.dio.get('/api/v1/user/following_count', data: {
              'user_id': Global.self.id,
            }).then((Response response) {
              if (response.data['code'] == Global.successCode) {
                Global.self.followingCount = response.data['data']['following_count'];
                Global.dio.get('/api/v1/user/like_count', data: {
                  'user_id': Global.self.id,
                }).then((Response response) {
                  if (response.data['code'] == Global.successCode) {
                    Global.self.likeCount = response.data['data']['like_count'];
                    setState(() {});
                  }
                });
              }
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const DivideBox(height: 36, decoColor: Colors.transparent),
        SizedBox(
          width: MediaQuery.of(context).size.width * 3 / 10,
          child: CupertinoButton(
            onPressed: () {},
            child: Column(
              children: [
                Text(
                    (!Global.self.isValidUser() || (Global.self.isValidUser() && Global.self.likeCount == null))
                        ? "NaN"
                        : NumberConverter.convertNumber(Global.self.likeCount!),
                    style: TextStyle(color: Theme.of(context).primaryColor)),
                Text(AppLocalizations.of(context)!.mine_user_info_like, style: TextStyle(color: Theme.of(context).primaryColor)),
              ],
            ),
          ),
        ),
        const DivideBox(height: 36),
        SizedBox(
            width: MediaQuery.of(context).size.width * 3 / 10,
            child: CupertinoButton(
              onPressed: () {
                if (Global.self.isValidUser()) {
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                    return FollowingPage(userId: Global.self.id!);
                  }));
                } else {
                  ToastificationUtils.showSimpleToastification(context, AppLocalizations.of(context)!.mine_need_login);
                  Navigator.of(context).pushNamed(LoginScreen.routeName);
                }
              },
              child: Column(
                children: [
                  Text(
                      (!Global.self.isValidUser() || (Global.self.isValidUser() && Global.self.likeCount == null))
                          ? "NaN"
                          : NumberConverter.convertNumber(Global.self.followingCount!),
                      style: TextStyle(color: Theme.of(context).primaryColor)),
                  Text(AppLocalizations.of(context)!.mine_user_info_subscribe, style: TextStyle(color: Theme.of(context).primaryColor)),
                ],
              ),
            )),
        const DivideBox(height: 36),
        SizedBox(
            width: MediaQuery.of(context).size.width * 3 / 10,
            child: CupertinoButton(
              onPressed: () {
                if (Global.self.isValidUser()) {
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                    return FollowerPage(userId: Global.self.id!);
                  }));
                } else {
                  ToastificationUtils.showSimpleToastification(context, AppLocalizations.of(context)!.mine_need_login);
                  Navigator.of(context).pushNamed(LoginScreen.routeName);
                }
              },
              child: Column(
                children: [
                  Text(
                      (!Global.self.isValidUser() || (Global.self.isValidUser() && Global.self.likeCount == null))
                          ? "NaN"
                          : NumberConverter.convertNumber(Global.self.followerCount!),
                      style: TextStyle(color: Theme.of(context).primaryColor)),
                  Text(AppLocalizations.of(context)!.mine_user_info_follower, style: TextStyle(color: Theme.of(context).primaryColor)),
                ],
              ),
            )),
        const DivideBox(height: 36, decoColor: Colors.transparent),
      ],
    );
  }
}

class DivideBox extends StatelessWidget {
  const DivideBox({super.key, required this.height, this.decoColor = const Color(0xFFE0E0E0)});

  final double height;
  final Color decoColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: decoColor,
        ),
      ),
    );
  }
}
