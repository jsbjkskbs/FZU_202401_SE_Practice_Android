import 'package:flutter/material.dart';
import 'package:flutter_popup/flutter_popup.dart';
import 'package:fulifuli_app/model/video.dart';
import 'package:fulifuli_app/utils/reverse_color.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:toastification/toastification.dart';

import '../../../utils/image_shader_mask.dart';

class VideoCard extends StatefulWidget {
  final Video video;

  const VideoCard({super.key, required this.video});

  @override
  State<StatefulWidget> createState() {
    return _VideoCardState();
  }
}

class _VideoCardState extends State<VideoCard> {
  late final Video video = widget.video;

  @override
  Widget build(BuildContext context) {
    return CustomPopup(
        backgroundColor: Theme.of(context).cardColor,
        showArrow: false,
        isLongPress: true,
        content: SizedBox(
            height: 100,
            child: Column(
              children: [
                TextButton(
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0))),
                      minimumSize: WidgetStateProperty.all(const Size(100, 50)),
                    ),
                    onPressed: () {},
                    child: const Text('举报')),
                TextButton(
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0))),
                      minimumSize: WidgetStateProperty.all(const Size(100, 50)),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      toastification.show(
                        context: context,
                        autoCloseDuration: const Duration(milliseconds: 1500),
                        style: ToastificationStyle.simple,
                        title: const Text('将减少此类内容推荐'),
                        alignment: Alignment.center,
                      );
                    },
                    child: const Text('不感兴趣')),
              ],
            )),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: FractionallySizedBox(
            widthFactor: 1,
            child: Card(
              shadowColor: Theme.of(context).indicatorColor,
              color: Theme.of(context).cardColor,
              elevation: 6,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 6),
                  Stack(
                    children: [
                      const GradientImage(
                        height: 120,
                        imgName: 'assets/images/cover.png',
                      ),
                      Positioned(
                        left: 0,
                        bottom: 0,
                        child: Row(
                          children: [
                            const SizedBox(width: 4),
                            HugeIcon(
                              icon: HugeIcons.strokeRoundedYoutube,
                              color: ColorUtils.reversColor(
                                  Theme.of(context).cardColor),
                              size: 20,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              video.viewCount.toString(),
                              style: TextStyle(
                                color: ColorUtils.reversColor(
                                    Theme.of(context).cardColor),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 6),
                  FractionallySizedBox(
                    widthFactor: 0.9,
                    child: Text(
                      video.title,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.headlineLarge?.color,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  FractionallySizedBox(
                      widthFactor: 1,
                      child: Row(
                        children: [
                          const SizedBox(width: 4),
                          HugeIcon(
                            icon: HugeIcons.strokeRoundedUserSquare,
                            color: Theme.of(context).hintColor,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text("作者名字七个字: ${video.userId}",
                              style: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontSize: 12,
                                overflow: TextOverflow.ellipsis,
                              )),
                        ],
                      )),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ));
  }
}
