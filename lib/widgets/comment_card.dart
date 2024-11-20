import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fulifuli_app/global.dart';
import 'package:fulifuli_app/model/comment.dart';
import 'package:fulifuli_app/utils/number_converter.dart';
import 'package:fulifuli_app/widgets/icons/def.dart';
import 'package:fulifuli_app/widgets/report_popup.dart';
import 'package:like_button/like_button.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../utils/toastification.dart';
import 'comment_popup.dart';

class CommentCard extends StatefulWidget {
  const CommentCard({
    super.key,
    required this.comment,
    this.needToShowChildCount = true,
    this.indexCommentKey,
    this.onClickIndexComment,
    this.isObserved = false,
  });

  final bool isObserved;
  final Comment comment;
  final String? indexCommentKey;
  final Function(String)? onClickIndexComment;
  final bool needToShowChildCount;

  @override
  State<CommentCard> createState() {
    return _CommentCardState();
  }
}

class _CommentCardState extends State<CommentCard> {
  bool _isDisliked = false;

  @override
  Widget build(BuildContext context) {
    if (widget.indexCommentKey != null) {
      debugPrint(Global.cachedMapCommentList[widget.indexCommentKey!].toString());
    }
    return AnimatedContainer(
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: widget.isObserved ? Theme.of(context).primaryColor : Colors.transparent,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 8, right: 16),
            child: Row(
              children: [
                TDImage(
                  imgUrl: widget.comment.user!.avatarUrl,
                  errorWidget: const TDImage(
                    assetUrl: 'assets/images/default_avatar.avif',
                    width: 48,
                    height: 48,
                    type: TDImageType.circle,
                  ),
                  width: 48,
                  height: 48,
                  type: TDImageType.circle,
                ),
                const SizedBox(width: 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.comment.user!.name!,
                        style: TextStyle(
                            fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                            decoration: TextDecoration.none)),
                    const SizedBox(height: 4),
                    Text(DateTime.fromMillisecondsSinceEpoch(widget.comment.createdAt! * 1000).toString().substring(0, 19),
                        style: TextStyle(
                            fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                            color: Theme.of(context).hintColor,
                            decoration: TextDecoration.none)),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              showReplyPanel();
            },
            child: Padding(
                padding: const EdgeInsets.only(left: 72, right: 16, bottom: 4),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 32,
                  child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!widget.needToShowChildCount &&
                              Global.cachedMapCommentList.containsKey(widget.indexCommentKey) &&
                              Global.cachedMapCommentList[widget.indexCommentKey]!.key
                                      .indexWhere((element) => element.id == widget.comment.parentId) !=
                                  -1)
                            GestureDetector(
                              onTap: () {
                                widget.onClickIndexComment!(widget.comment.parentId!);
                              },
                              child: Text(
                                '@${Global.cachedMapCommentList[widget.indexCommentKey]!.key.firstWhere((element) => element.id == widget.comment.parentId).user!.name}',
                                style: TextStyle(
                                  fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context).primaryColor,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          Text(
                            widget.comment.content!,
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
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 72),
                  Padding(
                    padding: EdgeInsets.only(
                        right: 16 + (widget.comment.likeCount ?? 0) != 0
                            ? NumberConverter.convertNumber(widget.comment.likeCount ?? 0).toString().length * 8.0
                            : 0),
                    child: LikeButton(
                      mainAxisAlignment: MainAxisAlignment.start,
                      size: 18,
                      circleColor: CircleColor(start: Theme.of(context).unselectedWidgetColor, end: Theme.of(context).primaryColor),
                      bubblesColor: BubblesColor(
                        dotPrimaryColor: Theme.of(context).primaryColor,
                        dotSecondaryColor: Theme.of(context).secondaryHeaderColor,
                      ),
                      onTap: (bool isLiked) async {
                        Response response;
                        response = await Global.dio.post('/api/v1/interact/like/comment/action', data: {
                          "comment_type": widget.comment.oType,
                          "from_media_id": widget.comment.oId,
                          "comment_id": widget.comment.id,
                          "action_type": isLiked ? 0 : 1,
                        });
                        if (response.data["code"] == Global.successCode) {
                          setState(() {
                            widget.comment.likeCount = isLiked ? widget.comment.likeCount! - 1 : widget.comment.likeCount! + 1;
                            widget.comment.isLiked = !isLiked;
                          });
                        } else {
                          if (context.mounted) {
                            ToastificationUtils.showSimpleToastification(context, response.data["msg"]);
                          }
                        }
                        return widget.comment.isLiked;
                      },
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
                      likeCount: widget.comment.likeCount,
                      isLiked: widget.comment.isLiked,
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
                      onPressed: () {
                        setState(() {
                          _isDisliked = !_isDisliked;
                        });
                      },
                      icon: Icon(_isDisliked ? DisplayIcons.dislike_filled : DisplayIcons.dislike,
                          color: _isDisliked ? Theme.of(context).primaryColor : Theme.of(context).unselectedWidgetColor, size: 18)),
                  IconButton(
                      style: ButtonStyle(overlayColor: WidgetStateProperty.all(Colors.transparent)),
                      onPressed: () {
                        showReplyPanel();
                      },
                      icon: Icon(DisplayIcons.comment, color: Theme.of(context).unselectedWidgetColor, size: 18)),
                ],
              ),
              IconButton(
                  style: ButtonStyle(overlayColor: WidgetStateProperty.all(Colors.transparent)),
                  onPressed: () {
                    ReportPopup.show(context, MediaQuery.of(context).size.width, MediaQuery.of(context).size.height * 0.6,
                        oType: 'comment', oId: widget.comment.id!, commentType: widget.comment.oType, fromMediaId: widget.comment.oId);
                  },
                  icon: Icon(DisplayIcons.report_flag, color: Theme.of(context).unselectedWidgetColor, size: 18)),
            ],
          ),
          const SizedBox(height: 4),
          widget.needToShowChildCount && widget.comment.childCount != null && widget.comment.childCount! > 0
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
                      child: GestureDetector(
                        onTap: () {
                          CommentPopup.show(context, MediaQuery.of(context).size.width, MediaQuery.of(context).size.height * 0.75,
                              radius: 16,
                              commentHead: CommentCard(
                                comment: widget.comment,
                                needToShowChildCount: false,
                              ),
                              oType: widget.comment.oType!,
                              oId: widget.comment.oId!,
                              rootId: widget.comment.rootId == '0' ? widget.comment.id : widget.comment.rootId,
                              parentId: widget.comment.id,
                              commentId: widget.comment.id!);
                        },
                        child: Row(
                          children: [
                            Text('查看 ${NumberConverter.convertNumber(widget.comment.childCount!)} 条回复',
                                style: TextStyle(fontSize: 12, color: Theme.of(context).indicatorColor, decoration: TextDecoration.none)),
                            const SizedBox(width: 4),
                            Icon(Icons.arrow_forward_ios, size: 12, color: Theme.of(context).indicatorColor),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox(height: 0),
        ],
      ),
    );
  }

  void showReplyPanel() {
    CommentPopup.showReplyPanel(context,
        hintText: '回复@${widget.comment.user!.name}',
        oType: widget.comment.oType!,
        oId: widget.comment.oId!,
        rootId: widget.comment.rootId == '0' ? widget.comment.id : widget.comment.rootId,
        parentId: widget.comment.id, onSend: () {
      widget.comment.childCount = widget.comment.childCount! + 1;
    });
  }
}
