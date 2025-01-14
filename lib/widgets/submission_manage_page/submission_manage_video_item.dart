import 'package:flutter/material.dart';
import 'package:fulifuli_app/model/video.dart';
import 'package:fulifuli_app/utils/number_converter.dart';
import 'package:fulifuli_app/widgets/icons/def.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class SubmissionManageVideoItem extends StatelessWidget {
  const SubmissionManageVideoItem({super.key, required this.data, required this.badge, required this.onTap});

  final Function onTap;
  final Video data;
  final String badge;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Padding(
          padding: const EdgeInsets.all(4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TDImage(
                imgUrl: data.coverUrl,
                width: MediaQuery.of(context).size.width / 2 - 8,
                height: MediaQuery.of(context).size.width * 9 / 32 - 8,
              ),
              const SizedBox(
                width: 8,
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.width * 9 / 32 - 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width / 2 - 8,
                            minHeight: Theme.of(context).textTheme.bodyMedium!.fontSize! * 3 + 4,
                            maxHeight: Theme.of(context).textTheme.bodyMedium!.fontSize! * 3 + 4),
                        child: Text(
                          data.title!,
                          style: TextStyle(
                            fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                            color: Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2 - 8,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(DisplayIcons.up_er,
                                    size: Theme.of(context).textTheme.bodySmall!.fontSize! * 1.6, color: Theme.of(context).hintColor),
                                const SizedBox(
                                  width: 4,
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 3,
                                  child: Text(
                                    data.user!.name!,
                                    style: TextStyle(
                                      fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                                      color: Theme.of(context).hintColor,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2 - 8,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(DisplayIcons.video_player,
                                    size: Theme.of(context).textTheme.bodySmall!.fontSize! * 1.6, color: Theme.of(context).hintColor),
                                const SizedBox(
                                  width: 4,
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 8,
                                  child: Text(
                                    NumberConverter.convertNumber(data.visitCount!),
                                    style: TextStyle(
                                      fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                                      color: Theme.of(context).hintColor,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Row(children: [
                                  Text(
                                    DateTime.fromMillisecondsSinceEpoch(data.createdAt! * 1000).toString().substring(0, 10),
                                    style: TextStyle(
                                      fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                                      color: Theme.of(context).hintColor,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ])
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  )),
            ],
          ),
        ),
        TDBadge(
          TDBadgeType.square,
          message: badge,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width * 9 / 32,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                onTap();
              },
            ),
          ),
        )
      ],
    );
  }
}
