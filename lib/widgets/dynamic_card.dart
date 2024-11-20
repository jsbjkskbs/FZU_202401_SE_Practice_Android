import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fulifuli_app/global.dart';
import 'package:fulifuli_app/model/activity.dart';
import 'package:fulifuli_app/pages/space.dart';
import 'package:fulifuli_app/utils/download_file.dart';
import 'package:fulifuli_app/widgets/comment_popup.dart';
import 'package:fulifuli_app/widgets/report_popup.dart';
import 'package:like_button/like_button.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../utils/number_converter.dart';
import '../utils/toastification.dart';
import 'icons/def.dart';

class DynamicCard extends StatefulWidget {
  const DynamicCard({super.key, required this.data});

  final Activity data;

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
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SpacePage(
                                userId: widget.data.user!.id!,
                              )));
                },
                child: Padding(
                    padding: const EdgeInsets.only(left: 16, top: 8),
                    child: TDImage(
                      imgUrl: widget.data.user!.avatarUrl!,
                      errorWidget: const TDImage(
                        assetUrl: 'assets/images/default_avatar.avif',
                        width: 56,
                        height: 56,
                        type: TDImageType.circle,
                      ),
                      width: 56,
                      height: 56,
                      type: TDImageType.circle,
                    )),
              ),
              const SizedBox(width: 8),
              Column(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.data.user!.name!,
                            style: TextStyle(
                                fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor)),
                        const SizedBox(height: 8),
                        Text(DateTime.fromMillisecondsSinceEpoch(widget.data.createdAt! * 1000).toString().substring(0, 19),
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
                    oType: 'activity', commentId: widget.data.id!, oId: widget.data.id!, isComment: false);
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
                              widget.data.content!,
                              style: TextStyle(
                                fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                              ),
                            ),
                          ],
                        )),
                  ))),
          if (widget.data.images != null && widget.data.images!.isNotEmpty) _getImageWidget(),
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
                  likeCount: widget.data.likeCount,
                  isLiked: widget.data.isLiked,
                  onTap: (bool isLiked) async {
                    Response response;
                    response = await Global.dio.post('/api/v1/interact/like/activity/action', data: {
                      "activity_id": widget.data.id,
                      "action_type": isLiked ? 0 : 1,
                    });
                    if (response.data["code"] == Global.successCode) {
                      setState(() {
                        widget.data.isLiked = !isLiked;
                        if (isLiked) {
                          widget.data.likeCount = widget.data.likeCount! - 1;
                        } else {
                          widget.data.likeCount = widget.data.likeCount! + 1;
                        }
                      });
                    }
                    return !isLiked;
                  },
                  countBuilder: (int? count, bool isLiked, String text) {
                    if (count == 0) {
                      return Text(
                        '点个赞吧',
                        style: TextStyle(
                          fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).unselectedWidgetColor,
                        ),
                      );
                    }
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
                      oType: 'activity', commentId: widget.data.id!, oId: widget.data.id!, isComment: false);
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(DisplayIcons.comment,
                          size: Theme.of(context).textTheme.headlineSmall!.fontSize, color: Theme.of(context).unselectedWidgetColor),
                      const SizedBox(width: 4),
                      Text(NumberConverter.convertNumber(widget.data.commentCount!),
                          style: TextStyle(
                              fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).unselectedWidgetColor)),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  ReportPopup.show(context, MediaQuery.of(context).size.width, MediaQuery.of(context).size.height * 0.6,
                      oType: 'activity', oId: widget.data.id!);
                },
                child: SizedBox(
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
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _getImageWidget() {
    return Container(
      height: 144,
      padding: const EdgeInsets.only(top: 16, bottom: 16, left: 4, right: 4),
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  TDImageViewer.showImageViewer(
                      context: context,
                      images: widget.data.images!,
                      defaultIndex: index,
                      showIndex: true,
                      onLongPress: (index) {
                        Navigator.of(context).push(TDSlidePopupRoute(
                          builder: (context) => Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            child: TextButton(
                                onPressed: () async {
                                  String? filepath = await Download.downloadAndSaveImage(
                                      widget.data.images![index], widget.data.images![index].split('/').last.split('?').first);
                                  if (context.mounted) {
                                    if (filepath != null) {
                                      ToastificationUtils.showDownloadSuccess(context, path: filepath);
                                    } else {
                                      ToastificationUtils.showSimpleToastification(context, '图片保存失败');
                                    }
                                    Navigator.of(context).pop();
                                  }
                                },
                                style: ButtonStyle(
                                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                                  ),
                                  padding: WidgetStateProperty.all(const EdgeInsets.only(top: 16, bottom: 16)),
                                ),
                                child: Text(
                                  '保存图片',
                                  style: TextStyle(
                                      fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize, color: Theme.of(context).primaryColor),
                                )),
                          ),
                        ));
                      });
                },
                child: SizedBox(
                  height: 120,
                  child: TDImage(
                    imgUrl: widget.data.images![index],
                    errorWidget: const SizedBox(
                        height: 120,
                        child: Column(
                          children: [
                            Icon(Icons.not_interested_outlined, size: 48),
                            Text('图片加载失败'),
                          ],
                        )),
                    height: 120,
                    width: 120,
                    type: TDImageType.roundedSquare,
                  ),
                ),
              ),
          separatorBuilder: (context, index) => const SizedBox(width: 16),
          itemCount: widget.data.images!.length),
    );
  }
}
