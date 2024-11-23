import 'package:flutter/material.dart';
import 'package:fulifuli_app/model/video.dart';
import 'package:fulifuli_app/utils/number_converter.dart';
import 'package:fulifuli_app/widgets/icons/def.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../generated/l10n.dart';

class SearchPageVideoItem extends StatelessWidget {
  const SearchPageVideoItem({super.key, required this.onTap, required this.data});

  final Function onTap;
  final Video data;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          onTap();
        },
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TDImage(
                imgUrl: data.coverUrl,
                width: MediaQuery.of(context).size.width / 2 - 8,
                height: MediaQuery.of(context).size.width * 9 / 32 - 8,
                errorWidget: Stack(
                  children: [
                    Center(
                      child: Image.asset('assets/images/error_cover.png',
                          width: MediaQuery.of(context).size.width / 2 - 8,
                          height: MediaQuery.of(context).size.width * 9 / 32 - 8,
                          fit: BoxFit.contain,
                          alignment: Alignment.topCenter),
                    ),
                    Center(
                        child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0, 2),
                            blurRadius: 4,
                          )
                        ],
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            S.current.function_default_image_load_failed,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          )),
                    )),
                  ],
                ),
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
        ));
  }
}
