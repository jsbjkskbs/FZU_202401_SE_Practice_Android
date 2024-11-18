import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fulifuli_app/global.dart';
import 'package:fulifuli_app/utils/number_converter.dart';
import 'package:fulifuli_app/utils/toastification.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../../model/user.dart';

class FriendItem extends StatefulWidget {
  const FriendItem({
    super.key,
    required this.onTap,
    required this.userId,
  });

  final Function onTap;
  final String userId;

  @override
  State<StatefulWidget> createState() {
    return _FriendItemState();
  }
}

class _FriendItemState extends State<FriendItem> {
  late User user;

  Widget _getFollowButton(BuildContext context) {
    var elStyle = ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        backgroundColor: user.isFollowed! ? Theme.of(context).disabledColor : Theme.of(context).primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
        overlayColor: user.isFollowed! ? Theme.of(context).disabledColor : Theme.of(context).primaryColor);
    var icon = user.isFollowed! ? Icons.check : Icons.add;
    var text = user.isFollowed! ? AppLocalizations.of(context)!.search_followed : AppLocalizations.of(context)!.search_follow;
    var iconColor = user.isFollowed! ? Theme.of(context).hintColor : Theme.of(context).scaffoldBackgroundColor;
    var iconSize = Theme.of(context).textTheme.bodySmall!.fontSize;
    var textStyle = TextStyle(
        color: user.isFollowed! ? Theme.of(context).hintColor : Theme.of(context).scaffoldBackgroundColor,
        fontSize: Theme.of(context).textTheme.bodySmall!.fontSize);
    return Padding(
        padding: const EdgeInsets.only(right: 16),
        child: SizedBox(
          height: Theme.of(context).textTheme.bodySmall!.fontSize! * 2.5,
          child: ElevatedButton(
              onPressed: () async {
                Response response;
                response = await Global.dio.post('/api/v1/relation/follow/action', data: {
                  'to_user_id': user.id,
                  'action_type': user.isFollowed! ? 0 : 1,
                });
                if (response.data['code'] == Global.successCode) {
                  user.followerCount = !user.isFollowed! ? user.followerCount! + 1 : user.followerCount! - 1;
                  user.isFollowed = !user.isFollowed!;
                } else {
                  if (context.mounted) {
                    ToastificationUtils.showSimpleToastification(context, response.data['msg']);
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
    user = Global.cachedMapUser[widget.userId]!;
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
                              imgUrl: user.avatarUrl)
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
                            user.name!,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${NumberConverter.convertNumber(user.followerCount!)}${AppLocalizations.of(context)!.search_follower}',
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
