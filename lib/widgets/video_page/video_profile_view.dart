import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fulifuli_app/global.dart';
import 'package:fulifuli_app/pages/space.dart';
import 'package:fulifuli_app/widgets/report_popup.dart';
import 'package:like_button/like_button.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../generated/l10n.dart';
import '../../model/video.dart';
import '../../utils/number_converter.dart';
import '../expand_shrink_text.dart';
import '../icons/def.dart';

class VideoProfileView extends StatefulWidget {
  const VideoProfileView({
    super.key,
    required this.video,
  });

  final Video video;

  @override
  State<VideoProfileView> createState() => _VideoProfileViewState();
}

class _VideoProfileViewState extends State<VideoProfileView> {
  bool expanded = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((callback) async {
      Response response;
      response = await Global.dio.get('/api/v1/user/follower_count', data: {
        "user_id": widget.video.user!.id,
      });
      if (response.data["code"] == Global.successCode) {
        widget.video.user!.followerCount = response.data["data"]["follower_count"];
      } else {
        widget.video.user!.followerCount = 0;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SpacePage(userId: widget.video.user!.id!)),
                    );
                  },
                  child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TDImage(
                        imgUrl: widget.video.user!.avatarUrl,
                        errorWidget: const TDImage(
                          assetUrl: 'assets/images/default_avatar.avif',
                          width: 36,
                          height: 36,
                          type: TDImageType.circle,
                        ),
                        width: 36,
                        height: 36,
                        type: TDImageType.circle,
                      )),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2),
                      child: Text(
                        widget.video.user!.name!,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal, overflow: TextOverflow.ellipsis),
                      ),
                    ),
                    ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2),
                        child: Text(
                          '${NumberConverter.convertNumber(widget.video.user!.followerCount ?? 0)}粉丝',
                          style: TextStyle(fontSize: 10, color: Theme.of(context).hintColor),
                        ))
                  ],
                )
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: SizedBox(
                      height: 30,
                      child: ElevatedButton(
                          onPressed: () async {
                            Response response;
                            response = await Global.dio.post('/api/v1/relation/follow/action',
                                data: {"to_user_id": widget.video.user!.id, "action_type": widget.video.user!.isFollowed! ? 0 : 1});
                            if (response.data["code"] == Global.successCode) {
                              widget.video.user!.followerCount = widget.video.user!.isFollowed!
                                  ? widget.video.user!.followerCount! - 1
                                  : widget.video.user!.followerCount! + 1;
                              widget.video.user!.isFollowed = !widget.video.user!.isFollowed!;
                              setState(() {});
                            }
                          },
                          style: !widget.video.user!.isFollowed!
                              ? ElevatedButton.styleFrom(
                                  overlayColor: Colors.transparent,
                                  backgroundColor: Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.only(left: 16, right: 16))
                              : ElevatedButton.styleFrom(
                                  overlayColor: Colors.transparent,
                                  backgroundColor: Theme.of(context).dialogBackgroundColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.only(left: 16, right: 16)),
                          child: IntrinsicWidth(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.add,
                                  size: 16,
                                  color: !widget.video.user!.isFollowed!
                                      ? Theme.of(context).scaffoldBackgroundColor
                                      : Theme.of(context).hintColor,
                                ),
                                Text(
                                  !widget.video.user!.isFollowed! ? S.current.video_author_follow : S.current.video_author_followed,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: !widget.video.user!.isFollowed!
                                          ? Theme.of(context).scaffoldBackgroundColor
                                          : Theme.of(context).hintColor),
                                )
                              ],
                            ),
                          )),
                    )),
              ],
            ),
          ],
        ),
        Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16, right: MediaQuery.of(context).size.width * 0.01),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.85),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedSize(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOutCubicEmphasized,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                expanded = !expanded;
                              });
                            },
                            child: ExpandShrinkText(widget.video.title!,
                                maxShrinkLine: 1,
                                isExpanded: expanded,
                                style: TextStyle(
                                  fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                                  color: Theme.of(context).textTheme.bodyLarge!.color,
                                )),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(DisplayIcons.video_player, size: 16, color: Theme.of(context).hintColor),
                            const SizedBox(width: 4),
                            Text(NumberConverter.convertNumber(widget.video.visitCount!),
                                style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor, overflow: TextOverflow.ellipsis)),
                            const SizedBox(width: 8),
                            Text(DateTime.fromMillisecondsSinceEpoch(widget.video.createdAt! * 1000).toLocal().toString().substring(0, 16),
                                style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor, overflow: TextOverflow.ellipsis)),
                          ],
                        ),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOutCubicEmphasized,
                          child: ExpandShrinkText(widget.video.description!,
                              maxShrinkLine: 0,
                              isExpanded: expanded,
                              style: TextStyle(
                                fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                                color: Theme.of(context).hintColor,
                              )),
                        ),
                        expanded
                            ? Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Wrap(
                                  children: [
                                    for (var tag in widget.video.labels!)
                                      Padding(
                                        padding: const EdgeInsets.only(right: 8, bottom: 8),
                                        child: TDTag(
                                          tag,
                                          shape: TDTagShape.round,
                                        ),
                                      ),
                                  ],
                                ),
                              )
                            : Container(),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.25,
                              child: LikeButton(
                                isLiked: widget.video.isLiked,
                                onTap: (isLike) async {
                                  Response response;
                                  response = await Global.dio.post('/api/v1/interact/like/video/action',
                                      data: {"video_id": widget.video.id, "action_type": widget.video.isLiked! ? 0 : 1});
                                  if (response.data["code"] == Global.successCode) {
                                    widget.video.likeCount =
                                        widget.video.isLiked! ? widget.video.likeCount! - 1 : widget.video.likeCount! + 1;
                                    widget.video.isLiked = !widget.video.isLiked!;
                                    setState(() {});
                                  }
                                  return widget.video.isLiked!;
                                },
                                size: 28,
                                circleColor:
                                    CircleColor(start: Theme.of(context).primaryColor, end: Theme.of(context).secondaryHeaderColor),
                                bubblesColor: BubblesColor(
                                  dotPrimaryColor: Theme.of(context).primaryColor,
                                  dotSecondaryColor: Theme.of(context).secondaryHeaderColor,
                                ),
                                likeBuilder: (bool isLiked) {
                                  return Icon(
                                    isLiked ? DisplayIcons.like_filled : DisplayIcons.like,
                                    color: isLiked ? Theme.of(context).primaryColor : Theme.of(context).unselectedWidgetColor,
                                    size: 28,
                                  );
                                },
                                likeCount: widget.video.likeCount,
                                countPostion: CountPostion.bottom,
                                countBuilder: (int? count, bool isLiked, String text) {
                                  var color = isLiked ? Theme.of(context).primaryColor : Theme.of(context).unselectedWidgetColor;
                                  Widget result;
                                  if (count == 0) {
                                    result = Text(
                                      S.current.function_default_like_on_zero,
                                      style: TextStyle(color: color, fontSize: 12),
                                    );
                                  } else {
                                    result = Text(
                                      NumberConverter.convertNumber(widget.video.likeCount!),
                                      style: TextStyle(color: color, fontSize: 12),
                                    );
                                  }
                                  return result;
                                },
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.25,
                              child: LikeButton(
                                size: 28,
                                circleColor:
                                    CircleColor(start: Theme.of(context).primaryColor, end: Theme.of(context).secondaryHeaderColor),
                                bubblesColor: BubblesColor(
                                  dotPrimaryColor: Theme.of(context).primaryColor,
                                  dotSecondaryColor: Theme.of(context).secondaryHeaderColor,
                                ),
                                likeBuilder: (bool isLiked) {
                                  return Icon(
                                    isLiked ? DisplayIcons.dislike_filled : DisplayIcons.dislike,
                                    color: isLiked ? Theme.of(context).primaryColor : Theme.of(context).unselectedWidgetColor,
                                    size: 28,
                                  );
                                },
                                animationDuration: const Duration(milliseconds: 0),
                                likeCountAnimationType: LikeCountAnimationType.none,
                                likeCount: 0,
                                countPostion: CountPostion.bottom,
                                countBuilder: (int? count, bool isLiked, String text) {
                                  var color = isLiked ? Theme.of(context).primaryColor : Theme.of(context).unselectedWidgetColor;
                                  Widget result;
                                  result = Text(
                                    S.current.function_default_dislike,
                                    style: TextStyle(color: color, fontSize: 12),
                                  );
                                  return result;
                                },
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.25,
                              child: LikeButton(
                                size: 28,
                                circleColor: const CircleColor(start: Colors.transparent, end: Colors.transparent),
                                bubblesColor: const BubblesColor(
                                  dotPrimaryColor: Colors.transparent,
                                  dotSecondaryColor: Colors.transparent,
                                ),
                                likeBuilder: (bool isLiked) {
                                  return Icon(
                                    DisplayIcons.report,
                                    color: Theme.of(context).unselectedWidgetColor,
                                    size: 28,
                                  );
                                },
                                onTap: (b) async {
                                  ReportPopup.show(context, MediaQuery.of(context).size.width, MediaQuery.of(context).size.height * 0.6,
                                      oType: 'video', oId: widget.video.id!);
                                  return false;
                                },
                                animationDuration: const Duration(milliseconds: 0),
                                likeCountAnimationType: LikeCountAnimationType.none,
                                likeCount: 0,
                                countPostion: CountPostion.bottom,
                                countBuilder: (int? count, bool isLiked, String text) {
                                  var color = Theme.of(context).unselectedWidgetColor;
                                  Widget result;
                                  result = Text(
                                    S.current.function_default_report,
                                    style: TextStyle(color: color, fontSize: 12),
                                  );
                                  return result;
                                },
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      expanded = !expanded;
                    });
                  },
                  child: AnimatedRotation(
                    turns: expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.keyboard_arrow_down_outlined,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}
