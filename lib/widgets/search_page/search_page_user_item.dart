import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fulifuli_app/global.dart';
import 'package:fulifuli_app/utils/number_converter.dart';
import 'package:fulifuli_app/utils/toastification.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../model/user.dart';

class SearchPageUserItem extends StatefulWidget {
  const SearchPageUserItem({super.key, required this.onTap, required this.user, required this.isFollowed});

  final Function onTap;
  final bool isFollowed;
  final User user;

  @override
  State<StatefulWidget> createState() {
    return _SearchPageUserItemState();
  }
}

class _SearchPageUserItemState extends State<SearchPageUserItem> {
  late bool isFollowed = widget.isFollowed;

  Widget _getFollowButton(BuildContext context) {
    var elStyle = ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        backgroundColor: isFollowed ? Theme.of(context).disabledColor : Theme.of(context).primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
        overlayColor: isFollowed ? Theme.of(context).disabledColor : Theme.of(context).primaryColor);
    var icon = isFollowed ? Icons.check : Icons.add;
    var text = isFollowed ? AppLocalizations.of(context)!.search_followed : AppLocalizations.of(context)!.search_follow;
    var iconColor = isFollowed ? Theme.of(context).hintColor : Theme.of(context).scaffoldBackgroundColor;
    var iconSize = Theme.of(context).textTheme.bodySmall!.fontSize;
    var textStyle = TextStyle(
        color: isFollowed ? Theme.of(context).hintColor : Theme.of(context).scaffoldBackgroundColor,
        fontSize: Theme.of(context).textTheme.bodySmall!.fontSize);
    return Padding(
        padding: const EdgeInsets.only(right: 16),
        child: SizedBox(
          height: Theme.of(context).textTheme.bodySmall!.fontSize! * 2.5,
          child: ElevatedButton(
              onPressed: () async {
                Response response;
                response = await Global.dio
                    .post("/api/v1/relation/follow/action", data: {"to_user_id": widget.user.id, "action_type": isFollowed ? 0 : 1});
                if (response.data["code"] == Global.successCode) {
                  isFollowed = !isFollowed;
                  setState(() {});
                } else {
                  if (context.mounted) {
                    ToastificationUtils.showSimpleToastification(context, response.data["msg"]);
                  }
                }
                widget.user.followerCount = isFollowed ? widget.user.followerCount! + 1 : widget.user.followerCount! - 1;
                setState(() {});
              },
              style: elStyle,
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: iconSize,
                    color: iconColor,
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  SizedBox(
                    width: Theme.of(context).textTheme.bodySmall!.fontSize! * 4.2,
                    child: Text(
                      text,
                      style: textStyle,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              )),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: Padding(
          padding: const EdgeInsets.all(4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          TDImage(
                              height: Theme.of(context).textTheme.bodyMedium!.fontSize! * 5 + 4,
                              type: TDImageType.circle,
                              imgUrl: widget.user.avatarUrl)
                        ],
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.user.name!,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${NumberConverter.convertNumber(widget.user.followerCount!)}${AppLocalizations.of(context)!.search_follower}',
                            style: TextStyle(
                              color: Theme.of(context).hintColor,
                              fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                            ),
                          )
                        ],
                      )
                    ],
                  )),
              _getFollowButton(context)
            ],
          )),
    );
  }
}
