import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_popup/flutter_popup.dart';
import 'package:fulifuli_app/global.dart';
import 'package:fulifuli_app/utils/file_type_judge.dart';
import 'package:fulifuli_app/utils/toastification.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../generated/l10n.dart';
import '../widgets/icons/def.dart';

class DynamicPostPage extends StatefulWidget {
  const DynamicPostPage({super.key});

  static String routeName = '/dynamic/post';

  @override
  State<DynamicPostPage> createState() {
    return _DynamicPostPage();
  }
}

class _DynamicPostPage extends State<DynamicPostPage> {
  final TextEditingController _contentController = TextEditingController();
  List<File>? _files = [];
  List<String?> _imageId = [];
  UniqueKey listViewKey = UniqueKey();
  double _progress = 0;
  double _progressMax = 0;
  bool _isUploading = false;

  @override
  void dispose() {
    super.dispose();
    _contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: _getAppbar(context),
            body: _getBody(context),
            bottomSheet: _isUploading ? _getBottomSheet(context) : _getBottomSheet(context)));
  }

  PreferredSizeWidget _getAppbar(BuildContext context) {
    return AppBar(
        titleSpacing: 0,
        leadingWidth: 0,
        leading: Container(),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    overlayColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    backgroundColor: Colors.transparent,
                    iconColor: Theme.of(context).textTheme.headlineSmall!.color,
                    padding: EdgeInsets.zero),
                child: Icon(Icons.arrow_back_ios_new,
                    size: Theme.of(context).textTheme.headlineSmall!.fontSize, color: Theme.of(context).textTheme.headlineSmall!.color)),
            Text(S.current.dynamic_post_title, style: Theme.of(context).textTheme.headlineSmall),
            CustomPopup(
                contentPadding: const EdgeInsets.all(2),
                content: IntrinsicWidth(
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        TextButton(
                            onPressed: () async {
                              var files = await _pickFile();
                              if (context.mounted) {
                                Navigator.pop(context);
                                if (files == null) {
                                  ToastificationUtils.showSimpleToastification(S.current.dynamic_post_not_select_right_image);
                                } else {
                                  setState(() {
                                    _files = [..._files!, ...files];
                                    debugPrint('files: $_files');
                                  });
                                }
                              }
                            },
                            child: Row(
                              children: [
                                const Icon(Icons.upload_file_outlined),
                                const SizedBox(width: 4),
                                Text(S.current.dynamic_post_upload_image, style: TextStyle(color: Theme.of(context).primaryColor)),
                              ],
                            )),
                      ],
                    ),
                  ),
                ),
                child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Icon(Icons.more_vert,
                        size: Theme.of(context).textTheme.headlineSmall!.fontSize,
                        color: Theme.of(context).textTheme.headlineSmall!.color))),
          ],
        ));
  }

  Widget _getBody(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList.separated(
            itemBuilder: (context, index) {
              return [
                const SizedBox(height: 16),
                TDTextarea(
                    hintText: S.current.dynamic_post_textarea_hint,
                    autofocus: false,
                    minLines: 8,
                    maxLength: 256,
                    additionInfo: '${_contentController.text.length} / 256',
                    additionInfoColor: _contentController.text.length >= 256 ? Colors.red : Theme.of(context).hintColor,
                    controller: _contentController,
                    textStyle: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                      fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                    ),
                    onChanged: (value) {
                      setState(() {});
                    }),
              ][index];
            },
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemCount: 2),
        if (_files != null && _files!.isNotEmpty)
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(S.current.dynamic_post_image_count_hint(_files!.length),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).primaryColor)),
                const Divider(
                  height: 1,
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: SizedBox(
                    height: 160,
                    child: ListView.separated(
                      key: listViewKey,
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) => const SizedBox(width: 8),
                      itemBuilder: (context, index) => CustomPopup(
                          contentPadding: const EdgeInsets.all(2),
                          isLongPress: true,
                          content: TextButton(
                              onPressed: () {
                                setState(() {
                                  _files!.removeAt(index);
                                  listViewKey = UniqueKey();
                                });
                                ToastificationUtils.showSimpleToastification(S.current.dynamic_post_delete_image_success);
                                Navigator.pop(context);
                              },
                              child: IntrinsicHeight(
                                child: IntrinsicWidth(
                                  child: Row(
                                    children: [
                                      const Icon(Icons.delete_forever, color: Colors.red),
                                      const SizedBox(width: 4),
                                      Text(S.current.function_default_delete, style: const TextStyle(color: Colors.red)),
                                    ],
                                  ),
                                ),
                              )),
                          child: GestureDetector(
                            onTap: () {
                              TDImageViewer.showImageViewer(
                                  context: context, images: _files!, defaultIndex: index, closeBtn: true, showIndex: true);
                            },
                            child: TDImage(
                              imageFile: _files![index],
                              height: 160,
                              width: 160,
                            ),
                          )),
                      itemCount: _files!.length,
                    ),
                  ),
                ),
                const Divider(
                  height: 1,
                ),
              ],
            ),
          )
      ],
    );
  }

  Widget _getBottomSheet(BuildContext context) {
    return !_isUploading
        ? SizedBox(
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: ElevatedButton(
                      onPressed: () {
                        _contentController.clear();
                        _files!.clear();
                        setState(() {});
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
                          const Icon(DisplayIcons.clear, color: Colors.white),
                          Text(S.current.function_default_delete, style: const TextStyle(color: Colors.white)),
                        ],
                      )),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: ElevatedButton(
                      onPressed: () async {
                        String? result = await _sendDynamic();
                        if (context.mounted) {
                          if (result == null) {
                            Navigator.pop(context);
                            ToastificationUtils.showSimpleToastification(S.current.dynamic_post_submit_success);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 4,
                        overlayColor: Theme.of(context).cardColor,
                        backgroundColor: Theme.of(context).cardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(DisplayIcons.post, color: Theme.of(context).primaryColor),
                          Text(
                            S.current.function_default_send,
                            style: TextStyle(color: Theme.of(context).primaryColor),
                          )
                        ],
                      )),
                ),
              ],
            ),
          )
        : SizedBox(
            height: 32,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LinearPercentIndicator(
                  width: MediaQuery.of(context).size.width - 32,
                  percent: _progress / _progressMax > 1 ? 1 : _progress / _progressMax,
                  animation: true,
                  animateFromLastPercent: true,
                  animationDuration: 1000,
                  center: Text(
                    '${((_progress / _progressMax > 1 ? 1 : _progress / _progressMax) * 100).toStringAsFixed(2)}%',
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
                  trailing: _progress / _progressMax >= 1
                      ? const Icon(Icons.done, color: Colors.green)
                      : const Icon(Icons.cloud_upload_outlined, color: Colors.blue),
                )
              ],
            ),
          );
  }

  Future<String?> _sendDynamic() async {
    _progress = 0;
    _progressMax = _files!.length.toDouble() + 1.0;
    _isUploading = true;
    _imageId = List.generate(_files!.length, (index) => null);
    Response response;
    if (_files != null && _files!.isNotEmpty) {
      for (var index = 0; index < _files!.length; index++) {
        response = await Global.dio.get('/api/v1/tool/upload/image');
        if (response.data["code"] != Global.successCode) {
          return response.data["msg"];
        }
        var uptoken = response.data["data"]["uptoken"];
        var uploadUrl = response.data["data"]["upload_url"];
        var uploadKey = response.data["data"]["upload_key"];
        var uFile = await MultipartFile.fromFile(_files![index].path);
        var formData = FormData.fromMap({
          "file": uFile,
          "token": uptoken,
          "key": uploadKey,
        });
        _imageId[index] = response.data["data"]["image_id"];
        response = await Global.dio.post(uploadUrl, data: formData);
        if (response.statusCode != 200) {
          return '上传图片失败';
        }
        _progress += 1.0;
        setState(() {});
        await Future.delayed(const Duration(milliseconds: 100));
      }
    }

    if (_imageId.isNotEmpty && _imageId.contains(null)) {
      return '上传图片失败';
    }

    response = await Global.dio.post('/api/v1/activity/publish', data: {
      "content": _contentController.text,
      if (_imageId.isNotEmpty) "image": _imageId.where((element) => element != null).toList(),
    });
    if (response.data["code"] == Global.successCode) {
      _progress += 1.0;
      _isUploading = false;
      setState(() {});
      return null;
    } else {
      return response.data["msg"];
    }
  }

  Future<List<File>?> _pickFile() async {
    var result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );
    var list = <File>[];
    if (result != null) {
      for (var item in result.files) {
        list.add(File(item.path!));
        if (!FileTypeJudge.isImage(list.last)) {
          return null;
        }
      }
      return list;
    }
    return null;
  }
}
