import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../global.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ProfileViewState();
  }
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
          elevation: WidgetStateProperty.all<double>(0),
          shadowColor: WidgetStateProperty.all<Color>(Colors.transparent),
          padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
        ),
        onPressed: () {
          if (Global.self.isValidUser()) {
            Navigator.of(context).pushNamed("/my");
          } else {
            Navigator.of(context).pushNamed("/login");
          }
        },
        child: Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 16.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: TDAvatar(
                    size: TDAvatarSize.large,
                    avatarUrl: Global.self.avatarUrl == ""
                        ? null
                        : Global.self.avatarUrl,
                    defaultUrl: "assets/images/default_avatar.gif",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Global.self.name == ""
                            ? AppLocalizations.of(context)!
                                .mine_profile_login_or_register
                            : Global.self.name,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                    Global.self.isValidUser()
                        ? AppLocalizations.of(context)!
                            .mine_profile_view_profile
                        : "",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16.0,
                    )),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(
                  width: 16.0,
                ),
              ],
            )
          ],
        ));
  }
}
