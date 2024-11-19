import 'package:flutter/material.dart';
import 'package:fulifuli_app/widgets/comment_popup.dart';
import 'package:like_button/like_button.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../test.dart';
import '../utils/number_converter.dart';
import 'icons/def.dart';

class DynamicCard extends StatefulWidget {
  const DynamicCard({super.key});

  @override
  State<DynamicCard> createState() {
    return _DynamicCardState();
  }
}

class _DynamicCardState extends State<DynamicCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              const Padding(
                  padding: EdgeInsets.only(left: 16, top: 8),
                  child: TDImage(
                    assetUrl: 'assets/images/default_avatar.gif',
                    width: 56,
                    height: 56,
                    type: TDImageType.circle,
                  )),
              const SizedBox(width: 8),
              Column(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('用户名',
                            style: TextStyle(
                                fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor)),
                        const SizedBox(height: 8),
                        Text('2021-09-01',
                            style:
                                TextStyle(fontSize: Theme.of(context).textTheme.bodySmall!.fontSize, color: Theme.of(context).hintColor)),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
          const SizedBox(height: 16),
          GestureDetector(
              onTap: () {
                CommentPopup.show(context, MediaQuery.of(context).size.width, MediaQuery.of(context).size.height * 0.8,
                    oType: '', commentId: '', oId: '');
              },
              child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 32,
                    child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              longText,
                              style: TextStyle(
                                fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                              ),
                            ),
                          ],
                        )),
                  ))),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: LikeButton(
                  likeBuilder: (bool isLiked) {
                    return !isLiked
                        ? Icon(DisplayIcons.like,
                            size: Theme.of(context).textTheme.headlineSmall!.fontSize, color: Theme.of(context).unselectedWidgetColor)
                        : Icon(DisplayIcons.like_filled,
                            size: Theme.of(context).textTheme.headlineSmall!.fontSize, color: Theme.of(context).primaryColor);
                  },
                  circleColor: CircleColor(start: Theme.of(context).unselectedWidgetColor, end: Theme.of(context).primaryColor),
                  bubblesColor: BubblesColor(
                    dotPrimaryColor: Theme.of(context).primaryColor,
                    dotSecondaryColor: Theme.of(context).secondaryHeaderColor,
                  ),
                  likeCount: 9999,
                  countBuilder: (int? count, bool isLiked, String text) {
                    return Text(
                      NumberConverter.convertNumber(count!),
                      style: TextStyle(
                        fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
                        fontWeight: FontWeight.bold,
                        color: isLiked ? Theme.of(context).primaryColor : Theme.of(context).unselectedWidgetColor,
                      ),
                    );
                  },
                ),
              ),
              GestureDetector(
                onTap: () {
                  CommentPopup.show(context, MediaQuery.of(context).size.width, MediaQuery.of(context).size.height * 0.8,
                      oType: '', commentId: '', oId: '');
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(DisplayIcons.comment,
                          size: Theme.of(context).textTheme.headlineSmall!.fontSize, color: Theme.of(context).unselectedWidgetColor),
                      const SizedBox(width: 4),
                      Text('9999',
                          style: TextStyle(
                              fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).unselectedWidgetColor)),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(DisplayIcons.report,
                        size: Theme.of(context).textTheme.headlineSmall!.fontSize, color: Theme.of(context).unselectedWidgetColor),
                    const SizedBox(width: 4),
                    Text('举报',
                        style: TextStyle(
                            fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).unselectedWidgetColor)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
