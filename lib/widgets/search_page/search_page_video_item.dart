import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fulifuli_app/model/video.dart';
import 'package:fulifuli_app/utils/number_converter.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:vector_graphics/vector_graphics.dart';

class SearchPageVideoItem extends StatelessWidget {
  const SearchPageVideoItem(
      {super.key, required this.onTap, required this.data});

  final Function onTap;
  final Video data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          onTap();
        },
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TDImage(
                assetUrl: data.coverUrl,
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
                            minHeight: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .fontSize! *
                                    3 +
                                4,
                            maxHeight: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .fontSize! *
                                    3 +
                                4),
                        child: Text(
                          data.title,
                          style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .fontSize,
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color,
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
                                SvgPicture(
                                  const AssetBytesLoader(
                                      'assets/icons/author_logo.svg.vec'),
                                  height: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .fontSize,
                                  colorFilter: ColorFilter.mode(
                                      Theme.of(context).hintColor,
                                      BlendMode.srcIn),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 3,
                                  child: Text(
                                    data.userId,
                                    style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .fontSize,
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
                                SvgPicture(
                                  const AssetBytesLoader(
                                      'assets/icons/video_player.svg.vec'),
                                  height: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .fontSize,
                                  colorFilter: ColorFilter.mode(
                                      Theme.of(context).hintColor,
                                      BlendMode.srcIn),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 8,
                                  child: Text(
                                    NumberConverter.convertNumber(
                                        data.viewCount),
                                    style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .fontSize,
                                      color: Theme.of(context).hintColor,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Row(children: [
                                  Text(
                                    DateTime.fromMillisecondsSinceEpoch(
                                            data.createdAt,
                                            isUtc: true)
                                        .toString()
                                        .substring(0, 10),
                                    style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .fontSize,
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
