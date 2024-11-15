import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'comment_card.dart';
import 'comment_list.dart';

class CommentPopup {
  static void show(BuildContext context, double width, double height) {
    Navigator.push(
      context,
      TDSlidePopupRoute(
          modalBarrierColor: Theme.of(context).textTheme.headlineMedium!.color!.withOpacity(0.5),
          builder: (context) {
            return TDPopupBottomDisplayPanel(
                title: '评论详情',
                titleColor: Theme.of(context).textTheme.headlineMedium!.color,
                closeColor: Theme.of(context).textTheme.headlineMedium!.color,
                closeClick: () {
                  Navigator.pop(context);
                },
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                child: SizedBox(
                    width: width,
                    height: height,
                    child: const CommentListView(
                      commentHead: CommentCard(),
                    )));
          }),
    );
  }
}
