import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fulifuli_app/utils/number_converter.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class FriendItem extends StatefulWidget {
  const FriendItem({super.key, required this.onTap});

  final Function onTap;
  final bool isFollowed = false;

  @override
  State<StatefulWidget> createState() {
    return _FriendItemState();
  }
}

class _FriendItemState extends State<FriendItem> {
  late bool isFollowed = widget.isFollowed;

  Widget _getFollowButton(BuildContext context) {
    var elStyle = ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        backgroundColor: isFollowed
            ? Theme.of(context).disabledColor
            : Theme.of(context).primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
        overlayColor: isFollowed
            ? Theme.of(context).disabledColor
            : Theme.of(context).primaryColor);
    var icon = isFollowed ? Icons.check : Icons.add;
    var text = isFollowed
        ? AppLocalizations.of(context)!.search_followed
        : AppLocalizations.of(context)!.search_follow;
    var iconColor = isFollowed
        ? Theme.of(context).hintColor
        : Theme.of(context).scaffoldBackgroundColor;
    var iconSize = Theme.of(context).textTheme.bodySmall!.fontSize;
    var textStyle = TextStyle(
        color: isFollowed
            ? Theme.of(context).hintColor
            : Theme.of(context).scaffoldBackgroundColor,
        fontSize: Theme.of(context).textTheme.bodySmall!.fontSize);
    return Padding(
        padding: const EdgeInsets.only(right: 16),
        child: SizedBox(
          height: Theme.of(context).textTheme.bodySmall!.fontSize! * 2.5,
          child: ElevatedButton(
              onPressed: () {
                isFollowed = !isFollowed;
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
                    width:
                        Theme.of(context).textTheme.bodySmall!.fontSize! * 4.2,
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
                              height: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .fontSize! *
                                      5 +
                                  4,
                              type: TDImageType.circle,
                              assetUrl: 'assets/images/default_avatar.gif')
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
                            '用户名',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .fontSize,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${NumberConverter.convertNumber(173881931737)}${AppLocalizations.of(context)!.search_follower}',
                            style: TextStyle(
                              color: Theme.of(context).hintColor,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .fontSize,
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
