import 'package:flutter/material.dart';
import 'package:fulifuli_app/widgets/comment_reply_fake_container.dart';
import 'package:fulifuli_app/widgets/comment_reply_popup.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'comment_list.dart';

class CommentPopup {
  static Future show(BuildContext context, double width, double height,
      {double? radius,
      Widget? commentHead,
      required String oType,
      required String oId,
      String? rootId,
      String? parentId,
      required String commentId}) {
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
                          oType: oType,
                          oId: commentId,
                          commentHead: commentHead,
                          isComment: true,
                        )),
                        GestureDetector(
                          onTap: () {
                            showReplyPanel(context, oType: oType, oId: oId, rootId: rootId, parentId: parentId, onSend: () {});
                          },
                          child: const CommentReplyPopupFakeContainer(),
                        ),
                      ],
                    )));
          }),
    );
    return result;
  }

  static showReplyPanel(
    BuildContext context, {
    required String oType,
    required String oId,
    required Function onSend,
    String? rootId,
    String? parentId,
    String? hintText,
  }) {
    Navigator.push(
        context,
        TDSlidePopupRoute(
            modalBarrierColor: Theme.of(context).textTheme.headlineMedium!.color!.withOpacity(0.5),
            builder: (context) {
              return CommentReplyPopupContainer(
                maxLength: 256,
                minLines: 1,
                oType: oType,
                oId: oId,
                onSend: onSend,
                parentId: parentId,
                rootId: rootId,
                hintText: hintText ?? '可以来点评论吗~',
              );
            }));
  }
}
