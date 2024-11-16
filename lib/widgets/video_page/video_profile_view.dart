import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../utils/number_converter.dart';
import '../expand_shrink_text.dart';
import '../icons/def.dart';

class VideoProfileView extends StatefulWidget {
  const VideoProfileView({super.key});

  @override
  State<VideoProfileView> createState() => _VideoProfileViewState();
}

class _VideoProfileViewState extends State<VideoProfileView> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Row(
              children: [
                const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: TDImage(
                      assetUrl: 'assets/images/default_avatar.gif',
                      width: 36,
                      height: 36,
                      type: TDImageType.circle,
                    )),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2),
                      child: const Text(
                        '作者名字七个1231sa12313d23字',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, overflow: TextOverflow.ellipsis),
                      ),
                    ),
                    ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2),
                        child: Text(
                          'xxxx万粉丝',
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
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              overlayColor: Colors.transparent,
                              backgroundColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              )),
                          child: IntrinsicWidth(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.add,
                                  size: 14,
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                ),
                                Text(
                                  '关注',
                                  style: TextStyle(fontSize: 14, color: Theme.of(context).scaffoldBackgroundColor),
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
                            child: ExpandShrinkText(
                                '这是一个很长很长很长很长很长很长很长很长很长很长的标题这是一个很长很长很长很长很长很长很长很长很长很长的标题这是一个很长很长很长很长很长很长很长很长很长很长的标题这是一个很长很长很长很长很长很长很长很长很长很长的标题这是一个很长很长很长很长很长很长很长很长很长很长的标题',
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
                            Text(NumberConverter.convertNumber(9999),
                                style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor, overflow: TextOverflow.ellipsis)),
                            const SizedBox(width: 8),
                            Text('2021-09-09',
                                style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor, overflow: TextOverflow.ellipsis)),
                          ],
                        ),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOutCubicEmphasized,
                          child: ExpandShrinkText(
                              '这是一个很长很长很长很长很长很长很长很长很长很长的简介这是一个很长很长很长很长很长很长很长很长很长很长的标题这是一个很长很长很长很长很长很长很长很长很长很长的标题这是一个很长很长很长很长很长很长很长很长很长很长的标题这是一个很长很长很长很长很长很长很长很长很长很长的标题这是一个很长很长很长很长很长很长很长很长很长很长的简介这是一个很长很长很长很长很长很长很长很长很长很长的标题这是一个很长很长很长很长很长很长很长很长很长很长的标题这是一个很长很长很长很长很长很长很长很长很长很长的标题这是一个很长很长很长很长很长很长很长很长很长很长的标题这是一个很长很长很长很长很长很长很长很长很长很长的简介这是一个很长很长很长很长很长很长很长很长很长很长的标题这是一个很长很长很长很长很长很长很长很长很长很长的标题这是一个很长很长很长很长很长很长很长很长很长很长的标题这是一个很长很长很长很长很长很长很长很长很长很长的标题',
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
                                    for (var tag in ['标签1', '标签2', '标签3', '标签4', '标签5', '标签6', '标签7', '标签8', '标签9', '标签10'])
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
                                likeCount: 9999,
                                countPostion: CountPostion.bottom,
                                countBuilder: (int? count, bool isLiked, String text) {
                                  var color = isLiked ? Theme.of(context).primaryColor : Theme.of(context).unselectedWidgetColor;
                                  Widget result;
                                  if (count == 0) {
                                    result = Text(
                                      '点个赞吧',
                                      style: TextStyle(color: color, fontSize: 12),
                                    );
                                  } else {
                                    result = Text(
                                      text,
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
                                    '不喜欢',
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
                                animationDuration: const Duration(milliseconds: 0),
                                likeCountAnimationType: LikeCountAnimationType.none,
                                likeCount: 0,
                                countPostion: CountPostion.bottom,
                                countBuilder: (int? count, bool isLiked, String text) {
                                  var color = Theme.of(context).unselectedWidgetColor;
                                  Widget result;
                                  result = Text(
                                    '举报',
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
