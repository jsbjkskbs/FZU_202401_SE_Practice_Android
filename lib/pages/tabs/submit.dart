import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fulifuli_app/global.dart';
import 'package:fulifuli_app/pkg/chewie/chewie.dart';
import 'package:fulifuli_app/utils/file_type_judge.dart';
import 'package:fulifuli_app/utils/language_reflect.dart';
import 'package:fulifuli_app/utils/reverse_color.dart';
import 'package:fulifuli_app/utils/toastification.dart';
import 'package:fulifuli_app/widgets/icons/def.dart';
import 'package:fulifuli_app/widgets/video_page/custom_controls/custom_controls.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:video_player/video_player.dart';

import '../../generated/l10n.dart';

class SubmitPage extends StatefulWidget {
  const SubmitPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SubmitPageState();
  }

  void dispose() {}
}

class _SubmitPageState extends State<SubmitPage> {
  File? video;
  bool _playerReady = false;
  bool _onUploading = false;
  double _uploadingPercent = 0.0;
  VideoPlayerController? _playerController;
  ChewieController? _chewieController;
  late String _selectedCategory = "";
  late String _selectedCategoryInner = "";
  late List<TDTag> tags = [];
  late ButtonStyle _shardButtonStyle;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _popupController = TextEditingController();

  @override
  void dispose() {
    if (_playerController != null) {
      _playerController!.dispose();
    }
    if (_chewieController != null) {
      _chewieController!.dispose();
    }
    if (video != null) {
      video = null;
    }
    _titleController.dispose();
    _descriptionController.dispose();
    _popupController.dispose();
    super.dispose();
  }

  Future<File?> _pickFile() async {
    var result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.video,
    );
    if (result != null) {
      File file = File(result.files.single.path!);
      if (FileTypeJudge.isVideo(file)) {
        return file;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    _shardButtonStyle = ElevatedButton.styleFrom(
      elevation: 0,
      overlayColor: Theme.of(context).primaryColor,
      shadowColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
      iconColor: Theme.of(context).textTheme.bodyLarge!.color,
    );
    return Scaffold(
        body: Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  video != null && _playerController != null && _chewieController != null && _playerReady
                      ? ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width,
                            maxHeight: MediaQuery.of(context).size.width / 16 * 9,
                          ),
                          child: Chewie(
                            controller: _chewieController!,
                          ),
                        )
                      : _getUnselectedWidget(context)
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        return [
                          _getTitleInputBox(context),
                          _getDescriptionBox(context),
                          _getCategorySelector(context),
                          _getTagInserter(context),
                        ][index];
                      },
                      separatorBuilder: (context, index) => const Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Divider(),
                          ),
                      itemCount: 4)),
              const SizedBox(height: 80)
            ],
          ),
        ),
        bottomSheet: _onUploading ? _getBottomSheet(context) : _getBottomSheet(context));
  }

  Widget _getUnselectedWidget(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width / 16 * 9,
      child: GestureDetector(
        onTap: () async {
          File? file = await _pickFile();
          if (file != null) {
            video = file;
            _playerController = VideoPlayerController.file(video!);
            if (_playerController != null) {
              _chewieController = ChewieController(
                videoPlayerController: _playerController!,
                autoPlay: false,
                looping: false,
                allowMuting: false,
                allowPlaybackSpeedChanging: true,
                allowFullScreen: true,
                showControls: true,
                showOptions: false,
                showControlsOnInitialize: false,
                aspectRatio: 16 / 9,
                materialProgressColors: context.mounted
                    ? ChewieProgressColors(
                        playedColor: Theme.of(context).primaryColor,
                        handleColor: Theme.of(context).primaryColor,
                        backgroundColor: Theme.of(context).dividerColor,
                        bufferedColor: Theme.of(context).unselectedWidgetColor,
                      )
                    : ChewieProgressColors(
                        playedColor: Colors.transparent,
                        handleColor: Colors.transparent,
                        backgroundColor: Colors.transparent,
                        bufferedColor: Colors.transparent,
                      ),
                placeholder: Container(
                  color: context.mounted ? Theme.of(context).cardColor : Colors.transparent,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                customControls: const CustomControls(),
                deviceOrientationsOnEnterFullScreen: [
                  DeviceOrientation.landscapeLeft,
                  DeviceOrientation.landscapeRight,
                ],
                deviceOrientationsAfterFullScreen: [
                  DeviceOrientation.portraitUp,
                  DeviceOrientation.portraitDown,
                ],
              );
              _playerController!.initialize().then((value) {
                setState(() {
                  _playerReady = true;
                });
              });
            }
            setState(() {});
          }
        },
        child: Container(
            color: Theme.of(context).cardColor,
            child: DottedBorder(
              color: Theme.of(context).dividerColor,
              strokeWidth: 4,
              dashPattern: const [4, 8],
              borderPadding: const EdgeInsets.all(4),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(DisplayIcons.upload_video, size: 48),
                    Text(
                      S.current.submit_select_video_hint,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                        fontWeight: FontWeight.bold,
                        fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                      ),
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }

  void reset() {
    if (video != null) {
      video = null;
    }
    if (_playerController != null) {
      _playerController!.pause();
    }
    _titleController.clear();
    _descriptionController.clear();
    _popupController.clear();
    _selectedCategory = "";
    _selectedCategoryInner = "";
    tags.clear();
    setState(() {});
  }

  Widget _getBottomSheet(BuildContext context) {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: !_onUploading
          ? Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: ElevatedButton(
                    onPressed: () {
                      reset();
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 4,
                      overlayColor: Theme.of(context).cardColor,
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          DisplayIcons.clear,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(S.current.submit_clear_button, style: const TextStyle(color: Colors.white))
                      ],
                    )),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 4,
                    overlayColor: Theme.of(context).cardColor,
                    backgroundColor: Theme.of(context).cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: video == null
                      ? () {
                          ToastificationUtils.showSimpleToastification(S.current.submit_video_not_selected);
                        }
                      : () async {
                          _onUploading = true;
                          setState(() {});
                          if (!_checkMessageFilled(context)) {
                            _onUploading = false;
                            setState(() {});
                            return;
                          }
                          List<String> labels = [];
                          for (var tag in tags) {
                            labels.add(tag.text);
                          }
                          Response response;
                          response = await Global.dio.post('/api/v1/video/publish', data: {
                            'title': _titleController.text,
                            'description': _descriptionController.text,
                            'category': _selectedCategoryInner,
                            'labels': labels,
                          });
                          debugPrint(response.data.toString());
                          if (response.data['code'] == Global.successCode) {
                            if (context.mounted) {
                              ToastificationUtils.showSimpleToastification(S.current.submit_video_uploading_hint);
                            }
                            var uploadUrl = response.data['data']['upload_url'];
                            var uploadKey = response.data['data']['upload_key'];
                            var uptoken = response.data['data']['uptoken'];
                            var uFile = await MultipartFile.fromFile(video!.path);
                            FormData formData = FormData.fromMap({
                              "file": uFile,
                              "key": uploadKey,
                              "token": uptoken,
                            });
                            response = await Global.dio.post(
                              uploadUrl,
                              data: formData,
                              onSendProgress: (int sent, int total) {
                                _uploadingPercent = 1.0 * sent / total;
                                debugPrint('sent: $sent, total: $total');
                                setState(() {});
                              },
                            );
                            if (response.statusCode == 200) {
                              if (context.mounted) {
                                ToastificationUtils.showSimpleToastification(S.current.submit_video_uploading_success);
                              }
                              reset();
                              setState(() {
                                _onUploading = false;
                              });
                            } else {
                              setState(() {
                                _onUploading = false;
                              });
                            }
                          } else {
                            setState(() {
                              _onUploading = false;
                            });
                          }
                        },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(DisplayIcons.post,
                          color: video == null ? Theme.of(context).unselectedWidgetColor : Theme.of(context).primaryColor),
                      const SizedBox(width: 4),
                      Text(S.current.submit_submit_button,
                          style: TextStyle(color: video == null ? Theme.of(context).unselectedWidgetColor : Theme.of(context).primaryColor))
                    ],
                  ),
                ),
              ),
            ])
          : Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                SizedBox(
                  height: 32,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LinearPercentIndicator(
                        width: MediaQuery.of(context).size.width - 32,
                        percent: _uploadingPercent > 1 ? 1 : _uploadingPercent,
                        animation: true,
                        animateFromLastPercent: true,
                        animationDuration: 1000,
                        center: Text(
                          '${((_uploadingPercent > 1 ? 1 : _uploadingPercent) * 100).toStringAsFixed(2)}%',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyMedium!.color,
                            fontWeight: FontWeight.bold,
                            fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                          ),
                        ),
                        lineHeight: Theme.of(context).textTheme.bodyMedium!.fontSize! * 1.5,
                        backgroundColor: Theme.of(context).dividerColor,
                        barRadius: const Radius.circular(8),
                        progressColor: Theme.of(context).primaryColor,
                        trailing: _uploadingPercent >= 1
                            ? const Icon(Icons.done, color: Colors.green)
                            : const Icon(Icons.cloud_upload_outlined, color: Colors.blue),
                      )
                    ],
                  ),
                ),
                SizedBox(
                    height: 16,
                    child: AnimatedTextKit(repeatForever: true, animatedTexts: [
                      TypewriterAnimatedText(
                        S.current.submit_video_uploading_hint_bottom,
                        speed: const Duration(milliseconds: 200),
                        textStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                        ),
                      ),
                    ])),
                const SizedBox()
              ]),
            ),
    );
  }

  Widget _getTitleInputBox(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.title,
                ),
                const SizedBox(width: 8),
                Text(
                  S.current.submit_video_title_hint,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                    fontWeight: FontWeight.bold,
                    fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                  ),
                ),
              ],
            ),
            TDInput(
                controller: _titleController,
                hintText: S.current.submit_video_title_input_hint,
                autofocus: false,
                maxLength: 32,
                additionInfo: S.current.submit_video_title_additional_hint(_titleController.text.length, 32),
                additionInfoColor: _titleController.text.length >= 32 ? Colors.red : Theme.of(context).hintColor,
                onClearTap: () {
                  _titleController.clear();
                  setState(() {});
                },
                onChanged: (value) {
                  setState(() {});
                },
                textStyle: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                  fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                ),
                rightBtn: _titleController.text.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          _titleController.clear();
                        },
                        icon: const Icon(Icons.clear),
                      )),
          ],
        ));
  }

  Widget _getDescriptionBox(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.description),
              const SizedBox(width: 8),
              Text(
                S.current.submit_video_description_hint,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  fontWeight: FontWeight.bold,
                  fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                ),
              ),
            ],
          ),
          TDTextarea(
            controller: _descriptionController,
            hintText: S.current.submit_video_description_input_hint,
            autofocus: false,
            minLines: 4,
            additionInfo: S.current.submit_video_title_additional_hint(_descriptionController.text.length, 256),
            additionInfoColor: _descriptionController.text.length >= 256 ? Colors.red : Theme.of(context).hintColor,
            maxLength: 256,
            onChanged: (value) {
              setState(() {});
            },
            textStyle: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium!.color,
              fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
            ),
          )
        ],
      ),
    );
  }

  Widget _getCategorySelector(BuildContext context) {
    return ElevatedButton(
      style: _shardButtonStyle,
      onPressed: () {
        DropDownState(DropDown(
          searchHintText: S.current.home_top_bar_search,
          data: [
            for (var category in Global.categoryList)
              SelectedListItem(
                  name: LanguageReflect.categoryReflect(category),
                  value: category,
                  isSelected: _selectedCategory.isNotEmpty && _selectedCategoryInner == category)
          ],
          enableMultipleSelection: false,
          onSelected: (item) {
            setState(() {
              _selectedCategory = item.first.name;
              _selectedCategoryInner = item.first.value!;
            });
          },
        )).showModal(context);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.category),
              const SizedBox(width: 8),
              Text(
                S.current.submit_video_category_hint,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  fontWeight: FontWeight.bold,
                  fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                ),
              ),
            ],
          ),
          Padding(
              padding: const EdgeInsets.only(right: 16),
              child: _selectedCategory.isEmpty
                  ? Icon(
                      Icons.arrow_forward_ios,
                      size: Theme.of(context).textTheme.bodyLarge!.fontSize,
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).dividerColor,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          _selectedCategory,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                          ),
                        ),
                      )))
        ],
      ),
    );
  }

  Widget _getTagInserter(BuildContext context) {
    return ElevatedButton(
      style: _shardButtonStyle,
      onPressed: () {
        Navigator.of(context).push(TDSlidePopupRoute(
            modalBarrierColor: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(0.2),
            slideTransitionFrom: SlideTransitionFrom.bottom,
            builder: (context) {
              return StatefulBuilder(builder: (context, setBuilderState) {
                return SafeArea(
                    child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                    const SizedBox(height: 16),
                    Material(
                      child: Text(S.current.submit_video_tag_additional_hint(tags.length),
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                            fontWeight: FontWeight.bold,
                            fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                          )),
                    ),
                    Material(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [for (var tag in tags) tag],
                            ),
                          ),
                        )),
                    const SizedBox(height: 16),
                    Material(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: SizedBox(
                        height: 100,
                        child: TDInput(
                            controller: _popupController,
                            type: TDInputType.normal,
                            leftLabel: S.current.submit_popup_tag_label,
                            leftLabelStyle: TextStyle(
                              color: Theme.of(context).textTheme.bodyLarge!.color,
                              fontWeight: FontWeight.bold,
                              fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                            ),
                            hintText: S.current.submit_popup_tag_hint,
                            hintTextStyle: TextStyle(
                              color: Theme.of(context).hintColor,
                              fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                            ),
                            maxLength: 16,
                            additionInfo: S.current.submit_popup_additional_hint(16),
                            additionInfoColor: _popupController.text.length >= 16 ? Colors.red : Theme.of(context).hintColor,
                            autofocus: true,
                            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                            onChanged: (value) {
                              setBuilderState(() {});
                            },
                            onSubmitted: (value) {
                              if (value.isNotEmpty) {
                                if (tags.any((element) => element.text == value)) {
                                  ToastificationUtils.showSimpleToastification(S.current.submit_video_tag_duplicate);
                                } else {
                                  var inColor = ColorUtils.getRandomModerateColor();
                                  tags.add(TDTag(value,
                                      isLight: true,
                                      style: TDTagStyle(
                                        textColor: Colors.grey[800],
                                        backgroundColor: inColor.withOpacity(0.5),
                                        fontWeight: FontWeight.bold,
                                        font: Font(size: 16, lineHeight: 2),
                                        border: 2,
                                        borderRadius: const BorderRadius.all(Radius.circular(4)),
                                        borderColor: inColor.withOpacity(0.5),
                                      ),
                                      icon: Icons.bookmark_added,
                                      padding: const EdgeInsets.all(8),
                                      size: TDTagSize.large,
                                      isOutline: true,
                                      needCloseIcon: true, onCloseTap: () {
                                    tags.removeWhere((element) => element.text == value);
                                    setState(() {});
                                    setBuilderState(() {});
                                  }));
                                  _popupController.clear();
                                  setState(() {});
                                  setBuilderState(() {});
                                }
                              }
                            }),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Material(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: ElevatedButton(
                              onPressed: () {
                                tags.clear();
                                setState(() {});
                                setBuilderState(() {});
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 4,
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                                iconColor: Theme.of(context).textTheme.bodyLarge!.color,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 24, right: 24),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.clear, color: Colors.white),
                                    const SizedBox(width: 8),
                                    Text(
                                      S.current.submit_popup_clear_button,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                                iconColor: Theme.of(context).textTheme.bodyLarge!.color,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 24, right: 24),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.done,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      S.current.submit_popup_confirm_button,
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ]),
                ));
              });
            }));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Icons.tag),
                  const SizedBox(width: 8),
                  Text(
                    S.current.submit_video_tag_hint,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                      fontWeight: FontWeight.bold,
                      fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                    ),
                  ),
                ],
              ),
              Padding(
                  padding: const EdgeInsets.only(right: 13),
                  child: Icon(
                    Icons.add,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ))
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [for (var tag in tags) tag],
              ),
            ),
          )
        ],
      ),
    );
  }

  bool _checkMessageFilled(BuildContext context) {
    if (_titleController.text.isEmpty) {
      ToastificationUtils.showSimpleToastification(S.current.submit_video_title_empty);
      return false;
    }
    if (_descriptionController.text.isEmpty) {
      ToastificationUtils.showSimpleToastification(S.current.submit_video_description_empty);
      return false;
    }
    if (_selectedCategory.isEmpty) {
      ToastificationUtils.showSimpleToastification(S.current.submit_video_category_empty);
      return false;
    }
    if (tags.isEmpty) {
      ToastificationUtils.showSimpleToastification(S.current.submit_video_tag_empty);
      return false;
    }
    return true;
  }
}
