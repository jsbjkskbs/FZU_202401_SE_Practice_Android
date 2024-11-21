import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fulifuli_app/global.dart';
import 'package:fulifuli_app/utils/number_converter.dart';
import 'package:fulifuli_app/utils/toastification.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../generated/l10n.dart';
import '../../model/user.dart';

class SearchPageUserItem extends StatefulWidget {
  const SearchPageUserItem({super.key, required this.onTap, required this.user});

  final Function onTap;
  final User user;

  @override
  State<StatefulWidget> createState() {
    return _SearchPageUserItemState();
  }
}

class _SearchPageUserItemState extends State<SearchPageUserItem> {
  Widget _getFollowButton(BuildContext context) {
    var elStyle = ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        backgroundColor: widget.user.isFollowed! ? Theme.of(context).dialogBackgroundColor : Theme.of(context).primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
        overlayColor: widget.user.isFollowed! ? Theme.of(context).dialogBackgroundColor : Theme.of(context).primaryColor);
    var icon = widget.user.isFollowed! ? Icons.check : Icons.add;
    var text = widget.user.isFollowed! ? S.of(context).search_followed : S.of(context).search_follow;
    var iconColor = widget.user.isFollowed! ? Theme.of(context).hintColor : Theme.of(context).scaffoldBackgroundColor;
    var iconSize = Theme.of(context).textTheme.bodySmall!.fontSize;
    var textStyle = TextStyle(
        color: widget.user.isFollowed! ? Theme.of(context).hintColor : Theme.of(context).scaffoldBackgroundColor,
        fontSize: Theme.of(context).textTheme.bodySmall!.fontSize);
    return Padding(
        padding: const EdgeInsets.only(right: 16),
        child: SizedBox(
          height: Theme.of(context).textTheme.bodySmall!.fontSize! * 2.5,
          child: ElevatedButton(
              onPressed: () async {
                Response response;
                response = await Global.dio.post("/api/v1/relation/follow/action",
                    data: {"to_user_id": widget.user.id, "action_type": widget.user.isFollowed! ? 0 : 1});
                if (response.data["code"] == Global.successCode) {
                  widget.user.followerCount = !widget.user.isFollowed! ? widget.user.followerCount! + 1 : widget.user.followerCount! - 1;
                  widget.user.isFollowed = !widget.user.isFollowed!;
                  setState(() {});
                } else {
                  if (context.mounted) {
                    ToastificationUtils.showSimpleToastification(context, response.data["msg"]);
                  }
                }
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
                    width: Theme.of(context).textTheme.bodySmall!.fontSize! * 4.5,
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
    return InkWell(
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
                            imgUrl: widget.user.avatarUrl,
                            errorWidget: TDImage(
                              assetUrl: "assets/images/default_avatar.avif",
                              type: TDImageType.circle,
                              height: Theme.of(context).textTheme.bodyMedium!.fontSize! * 5 + 4,
                            ),
                          )
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
                            '${NumberConverter.convertNumber(widget.user.followerCount!)}${S.of(context).search_follower}',
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
