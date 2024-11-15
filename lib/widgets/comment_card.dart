import 'package:flutter/material.dart';
import 'package:fulifuli_app/test.dart';
import 'package:fulifuli_app/utils/number_converter.dart';
import 'package:fulifuli_app/widgets/icons/def.dart';
import 'package:like_button/like_button.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class CommentCard extends StatefulWidget {
  const CommentCard({
    super.key,
    this.needToShowReplyCount = false,
    this.replyCount = 0,
  });

  final bool needToShowReplyCount;
  final int replyCount;

  @override
  State<CommentCard> createState() {
    return _CommentCardState();
  }
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 8, right: 16),
          child: Row(
            children: [
              const TDImage(
                assetUrl: 'assets/images/default_avatar.gif',
                width: 48,
                height: 48,
                type: TDImageType.circle,
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('用户名',
                      style: TextStyle(
                          fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                          decoration: TextDecoration.none)),
                  const SizedBox(height: 4),
                  Text('2021-09-01',
                      style: TextStyle(
                          fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                          color: Theme.of(context).hintColor,
                          decoration: TextDecoration.none)),
                ],
              ),
            ],
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(left: 72, right: 16, bottom: 4),
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 32,
              child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        longText.substring(0, 100),
                        style: TextStyle(
                          fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  )),
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 72),
                SizedBox(
                  width: 64,
                  child: LikeButton(
                    mainAxisAlignment: MainAxisAlignment.start,
                    size: 18,
                    circleColor: CircleColor(start: Theme.of(context).unselectedWidgetColor, end: Theme.of(context).primaryColor),
                    bubblesColor: BubblesColor(
                      dotPrimaryColor: Theme.of(context).primaryColor,
                      dotSecondaryColor: Theme.of(context).secondaryHeaderColor,
                    ),
                    likeBuilder: (bool isLiked) {
                      return isLiked
                          ? Icon(
                              DisplayIcons.like_filled,
                              color: Theme.of(context).primaryColor,
                              size: 18,
                            )
                          : Icon(
                              DisplayIcons.like,
                              color: Theme.of(context).unselectedWidgetColor,
                              size: 18,
                            );
                    },
                    likeCount: 9999,
                    countBuilder: (int? count, bool isLiked, String text) {
                      return Text(
                        count != null && count > 0 ? NumberConverter.convertNumber(count) : '',
                        style: TextStyle(
                            color: isLiked ? Theme.of(context).primaryColor : Theme.of(context).unselectedWidgetColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.none),
                      );
                    },
                  ),
                ),
                IconButton(
                    style: ButtonStyle(overlayColor: WidgetStateProperty.all(Colors.transparent)),
                    onPressed: () {},
                    icon: Icon(DisplayIcons.dislike, color: Theme.of(context).unselectedWidgetColor, size: 18)),
                IconButton(
                    style: ButtonStyle(overlayColor: WidgetStateProperty.all(Colors.transparent)),
                    onPressed: () {},
                    icon: Icon(DisplayIcons.comment, color: Theme.of(context).unselectedWidgetColor, size: 18)),
              ],
            ),
            IconButton(
                style: ButtonStyle(overlayColor: WidgetStateProperty.all(Colors.transparent)),
                onPressed: () {},
                icon: Icon(DisplayIcons.report_flag, color: Theme.of(context).unselectedWidgetColor, size: 18)),
          ],
        ),
        const SizedBox(height: 4),
        widget.needToShowReplyCount && widget.replyCount > 0
            ? Padding(
                padding: const EdgeInsets.only(left: 72, right: 16, bottom: 16),
                child: Container(
                  width: MediaQuery.of(context).size.width - 88,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Text('查看 ${NumberConverter.convertNumber(widget.replyCount)} 条回复',
                            style: TextStyle(fontSize: 12, color: Theme.of(context).indicatorColor, decoration: TextDecoration.none)),
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_forward_ios, size: 12, color: Theme.of(context).indicatorColor),
                      ],
                    ),
                  ),
                ),
              )
            : const SizedBox(height: 0),
      ],
    );
  }
}
