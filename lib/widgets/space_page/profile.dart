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
      fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width / 5,
                child: Column(
                  children: [
                    Text("0", style: _labelStyle),
                    Text(
                      AppLocalizations.of(context)!.space_follower,
                      style: _labelStyle,
                    ),
                  ],
                )),
            Container(
              height: 32,
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: 1,
                  ),
                ),
              ),
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width / 5,
                child: Column(
                  children: [
                    Text("0", style: _labelStyle),
                    Text(
                      AppLocalizations.of(context)!.space_following,
                      style: _labelStyle,
                    ),
                  ],
                )),
            Container(
              height: 32,
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: 1,
                  ),
                ),
              ),
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width / 5,
                child: Column(
                  children: [
                    Text(
                      NumberConverter.convertNumber(0),
                      style: _labelStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      AppLocalizations.of(context)!.space_like,
                      style: _labelStyle,
                    ),
                  ],
                ))
          ],
        )
      ],
    );
  }
}
