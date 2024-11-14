import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserInfoView extends StatefulWidget {
  const UserInfoView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _UserInfoViewState();
  }
}

class _UserInfoViewState extends State<UserInfoView> {
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
                Text("0", style: TextStyle(color: Theme.of(context).primaryColor)),
                Text(AppLocalizations.of(context)!.mine_user_info_like, style: TextStyle(color: Theme.of(context).primaryColor)),
              ],
            ),
          ),
        ),
        const DivideBox(height: 36),
        SizedBox(
            width: MediaQuery.of(context).size.width * 3 / 10,
            child: CupertinoButton(
              onPressed: () {},
              child: Column(
                children: [
                  Text("0", style: TextStyle(color: Theme.of(context).primaryColor)),
                  Text(AppLocalizations.of(context)!.mine_user_info_subscribe, style: TextStyle(color: Theme.of(context).primaryColor)),
                ],
              ),
            )),
        const DivideBox(height: 36),
        SizedBox(
            width: MediaQuery.of(context).size.width * 3 / 10,
            child: CupertinoButton(
              onPressed: () {},
              child: Column(
                children: [
                  Text("0", style: TextStyle(color: Theme.of(context).primaryColor)),
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
