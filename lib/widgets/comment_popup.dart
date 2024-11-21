import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:fulifuli_app/widgets/comment_reply_fake_container.dart';
import 'package:fulifuli_app/widgets/comment_reply_popup.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../generated/l10n.dart';
import 'comment_list.dart';

class CommentPopup {
  static Future show(BuildContext context, double width, double height,
      {double? radius,
      Widget? commentHead,
      required String oType,
      required String oId,
      String? rootId,
      String? parentId,
      required String commentId,
      bool isComment = true}) {
    final EasyRefreshController controller = EasyRefreshController(
      controlFinishLoad: true,
      controlFinishRefresh: true,
    );
    final result = Navigator.push(
      context,
      TDSlidePopupRoute(
          modalBarrierColor: Theme.of(context).textTheme.headlineMedium!.color!.withOpacity(0.5),
          builder: (context) {
            return TDPopupBottomDisplayPanel(
                title: S.of(context).comment_popup_title,
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
                          isComment: isComment,
                          easyRefreshController: controller,
                        )),
                        GestureDetector(
                          onTap: () {
                            showReplyPanel(context, oType: oType, oId: oId, rootId: rootId, parentId: parentId, onSend: () {
                              controller.callRefresh();
                            });
                          },
                          child: CommentReplyPopupFakeContainer(
                            hintText: S.of(context).reply_comment_popup_hint,
                          ),
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
                hintText: hintText ?? S.of(context).reply_comment_popup_hint,
              );
            }));
  }
}
