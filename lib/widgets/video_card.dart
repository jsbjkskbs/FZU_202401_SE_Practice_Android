import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_popup/flutter_popup.dart';
import 'package:fulifuli_app/global.dart';
import 'package:fulifuli_app/model/video.dart';
import 'package:fulifuli_app/utils/toastification.dart';
import 'package:fulifuli_app/widgets/icons/def.dart';

import '../utils/image_shader_mask.dart';

class VideoCard extends StatefulWidget {
  final Video video;

  const VideoCard({super.key, required this.video});

  @override
  State<StatefulWidget> createState() {
    return _VideoCardState();
  }
}

class _VideoCardState extends State<VideoCard> {
  late Video video = widget.video;

  @override
  Widget build(BuildContext context) {
    return CustomPopup(
        backgroundColor: Theme.of(context).cardColor,
        showArrow: false,
        isLongPress: true,
        contentPadding: const EdgeInsets.all(0),
        content: SizedBox(
            height: 100,
            child: Column(
              children: [
                TextButton(
                    style: ButtonStyle(
                      alignment: Alignment.centerLeft,
                      shape:
                          WidgetStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(0))),
                      minimumSize: WidgetStateProperty.all(const Size(140, 50)),
                    ),
                    onPressed: () {},
                    child: IntrinsicWidth(
                        child: Row(
                      children: [
                        const Icon(DisplayIcons.report),
                        const SizedBox(width: 4),
                        Text(AppLocalizations.of(context)!.video_card_report),
                      ],
                    ))),
                TextButton(
                    style: ButtonStyle(
                      alignment: Alignment.centerLeft,
                      shape:
                          WidgetStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(0))),
                      minimumSize: WidgetStateProperty.all(const Size(140, 50)),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      ToastificationUtils.showSimpleToastification(context, AppLocalizations.of(context)!.video_card_uninterested_success);
                    },
                    child: IntrinsicWidth(
                        child: Row(
                      children: [
                        const Icon(DisplayIcons.not_interest),
                        const SizedBox(width: 4),
                        Text(AppLocalizations.of(context)!.video_card_uninterested),
                      ],
                    ))),
              ],
            )),
        child: GestureDetector(
          onTap: () async {
            Response r1;
            r1 = await Global.dio.get("/api/v1/video/info", data: {
              "video_id": video.id,
            });
            debugPrint(Global.dio.options.headers.toString());
            debugPrint(r1.data.toString());
            if (r1.data["code"] != Global.successCode) {
              if (context.mounted) {
                ToastificationUtils.showSimpleToastification(context, r1.data["msg"]);
              }
              return;
            }
            video = Video.fromJson(r1.data["data"]);
            Global.cachedMapVideo[video.id!] = video;
            Response response = await Global.dio.get("/api/v1/user/follower_count", data: {
              "user_id": video.user?.id,
            });
            debugPrint("VideoCard: ${response.data}");
            if (response.data["code"] == Global.successCode) {
              video.user!.followerCount = response.data["data"]["follower_count"];
              Global.cachedMapVideo[video.id!] = video;
              if (context.mounted) {
                Navigator.of(context).pushNamed('/video', arguments: {
                  'vid': video.id,
                });
              }
            } else {
              if (context.mounted) {
                ToastificationUtils.showSimpleToastification(context, response.data["msg"]);
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 0),
            child: FractionallySizedBox(
              widthFactor: 1,
              child: Card(
                color: Theme.of(context).cardColor,
                elevation: 2,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 6),
                    Stack(
                      children: [
                        GradientImage(
                          height: 120,
                          imgName: video.coverUrl!,
                        ),
                        Positioned(
                          left: 0,
                          bottom: 0,
                          child: Row(
                            children: [
                              const SizedBox(width: 4),
                              Icon(
                                DisplayIcons.video_player,
                                size: Theme.of(context).textTheme.bodyMedium!.fontSize,
                                color: Theme.of(context).textTheme.bodyMedium!.color,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                video.visitCount.toString(),
                                style: TextStyle(
                                  color: Theme.of(context).textTheme.bodyMedium!.color,
                                  fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
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
                        child: SizedBox(
                          height: Theme.of(context).textTheme.bodyLarge!.fontSize! * 2.7,
                          child: Text(
                            video.title!,
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodyLarge!.color,
                              fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 2,
                          ),
                        )),
                    const SizedBox(
                      height: 6,
                    ),
                    FractionallySizedBox(
                        widthFactor: 1,
                        child: Row(
                          children: [
                            const SizedBox(width: 4),
                            Icon(
                              DisplayIcons.up_er,
                              size: Theme.of(context).textTheme.bodySmall!.fontSize! * 1.6,
                              color: Theme.of(context).hintColor,
                            ),
                            const SizedBox(width: 4),
                            ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 3),
                                child: Text("${video.user?.name}",
                                    style: TextStyle(
                                      color: Theme.of(context).hintColor,
                                      fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                                      overflow: TextOverflow.ellipsis,
                                    )))
                          ],
                        )),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
