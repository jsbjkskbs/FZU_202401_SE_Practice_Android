import 'package:flutter/material.dart';
import 'package:fulifuli_app/utils/toastification.dart';
import 'package:fulifuli_app/widgets/icons/def.dart';

import '../generated/l10n.dart';

class CommentReplyPopupFakeContainer extends StatefulWidget {
  const CommentReplyPopupFakeContainer({super.key, this.hintText = '可以来点评论吗~'});

  final String hintText;

  @override
  State<StatefulWidget> createState() {
    return _CommentReplyPopupFakeContainerState();
  }
}

class _CommentReplyPopupFakeContainerState extends State<CommentReplyPopupFakeContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Padding(
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, top: 8, bottom: 8),
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.825,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Theme.of(context).dialogBackgroundColor,
                    borderRadius: BorderRadius.circular(48),
                  ),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    widget.hintText,
                    style: TextStyle(
                      color: Theme.of(context).unselectedWidgetColor,
                      decoration: TextDecoration.none,
                      fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                      fontWeight: FontWeight.normal,
                    ),
                  ))),
          Expanded(
              child: GestureDetector(
                  onTap: () {
                    ToastificationUtils.showSimpleToastification(context, S.of(context).egg_wa_ao);
                  },
                  child: const Icon(DisplayIcons.cat)))
        ],
      ),
    );
  }
}
