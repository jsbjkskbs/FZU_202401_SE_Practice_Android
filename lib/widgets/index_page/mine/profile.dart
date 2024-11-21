import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../../generated/l10n.dart';
import '../../../global.dart';
import '../../../pages/space.dart';

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
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
        ),
        onPressed: () {
          if (Global.self.isValidUser()) {
            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
              return SpacePage(
                userId: Global.self.id!,
              );
            }));
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
                  child: TDImage(
                    width: 60.0,
                    height: 60.0,
                    type: TDImageType.circle,
                    imgUrl: Global.self.avatarUrl,
                    errorWidget: const TDImage(
                      width: 60.0,
                      height: 60.0,
                      type: TDImageType.circle,
                      assetUrl: "assets/images/default_avatar.avif",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Global.self.name ?? S.current.mine_profile_login_or_register,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
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
                Text(Global.self.isValidUser() ? S.current.mine_profile_view_profile : "",
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
