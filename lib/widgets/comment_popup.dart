import 'package:flutter/material.dart';
import 'package:fulifuli_app/widgets/comment_reply_fake_container.dart';
import 'package:fulifuli_app/widgets/comment_reply_popup.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'comment_list.dart';

class CommentPopup {
  static Future show(BuildContext context, double width, double height, {double? radius, Widget? commentHead}) {
    final result = Navigator.push(
      context,
      TDSlidePopupRoute(
          modalBarrierColor: Theme.of(context).textTheme.headlineMedium!.color!.withOpacity(0.5),
          builder: (context) {
            return TDPopupBottomDisplayPanel(
                title: '评论详情',
                titleColor: Theme.of(context).textTheme.headlineMedium!.color,
                closeColor: Theme.of(context).textTheme.headlineMedium!.color,
                closeClick: () {
                  Navigator.pop(context, true);
                },
                radius: radius,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                child: SizedBox(
                    width: width,
                    height: height,
                    child: Column(
                      children: [
                        Expanded(
                            child: CommentListView(
                          commentHead: commentHead,
                        )),
                        GestureDetector(
                          onTap: () {
                            showReplyPanel(context);
                          },
                          child: const CommentReplyPopupFakeContainer(),
                        ),
                      ],
                    )));
          }),
    );
    return result;
  }

  static showReplyPanel(BuildContext context) {
    Navigator.push(
        context,
        TDSlidePopupRoute(
            modalBarrierColor: Theme.of(context).textTheme.headlineMedium!.color!.withOpacity(0.5),
            builder: (context) {
              return const CommentReplyPopupContainer(maxLength: 256, minLines: 1);
            }));
  }
}
