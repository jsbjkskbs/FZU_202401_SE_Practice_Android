import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../utils/number_converter.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  static String routeName = '/profile';

  @override
  State<StatefulWidget> createState() {
    return _ProfileState();
  }
}

class _ProfileState extends State<Profile> {
  late TextStyle _labelStyle;

  @override
  Widget build(BuildContext context) {
    _labelStyle = TextStyle(
      color: Theme.of(context).primaryColor,
      fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width / 16),
            child: GestureDetector(
                onTap: () {
                  TDImageViewer.showImageViewer(
                      context: context,
                      images: [
                        "assets/images/default_avatar.gif",
                        "assets/images/dot.png",
                      ],
                      onIndexChange: (index) {
                        if (index != 0) {
                          Navigator.of(context).pop();
                        }
                      });
                },
                child: TDImage(
                  assetUrl: "assets/images/default_avatar.gif",
                  height: MediaQuery.of(context).size.width / 4,
                  width: MediaQuery.of(context).size.width / 4,
                  type: TDImageType.circle,
                ))),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(),
            SizedBox(
                width: MediaQuery.of(context).size.width / 4,
                child: Column(
                  children: [
                    Text("0",
                        style: _labelStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .fontSize)),
                    Text(
                      AppLocalizations.of(context)!.space_follower,
                      style: _labelStyle,
                    ),
                  ],
                )),
            SizedBox(
                width: MediaQuery.of(context).size.width / 4,
                child: Column(
                  children: [
                    Text("0",
                        style: _labelStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .fontSize)),
                    Text(
                      AppLocalizations.of(context)!.space_following,
                      style: _labelStyle,
                    ),
                  ],
                )),
            SizedBox(
                width: MediaQuery.of(context).size.width / 4,
                child: Column(
                  children: [
                    Text(
                      NumberConverter.convertNumber(0),
                      style: _labelStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize:
                              Theme.of(context).textTheme.bodyLarge!.fontSize),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      AppLocalizations.of(context)!.space_like,
                      style: _labelStyle,
                    ),
                  ],
                )),
            const SizedBox(),
          ],
        ),
        const SizedBox(height: 16.0),
        TextButton(
          onPressed: () {},
          style: ButtonStyle(
            overlayColor: WidgetStateProperty.all(
                Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5)),
            backgroundColor:
                WidgetStateProperty.all(Theme.of(context).primaryColor),
            shape: WidgetStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0))),
          ),
          child: Text(
            "Edit Profile",
            style: TextStyle(
                color: Theme.of(context).scaffoldBackgroundColor,
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
