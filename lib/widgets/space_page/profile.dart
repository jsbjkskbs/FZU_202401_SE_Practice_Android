import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fulifuli_app/global.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../utils/file_type_judge.dart';
import '../../utils/number_converter.dart';
import '../../utils/toastification.dart';

class Profile extends StatefulWidget {
  const Profile({super.key, required this.userId});

  final String userId;

  @override
  State<StatefulWidget> createState() {
    return _ProfileState();
  }
}

class _ProfileState extends State<Profile> {
  late TextStyle _labelStyle;

  @override
  Widget build(BuildContext context) {
    _labelStyle = TextStyle(
      color: Theme.of(context).primaryColor,
      fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width / 16),
            child: GestureDetector(
                onTap: () {
                  TDImageViewer.showImageViewer(
                      context: context,
                      images: [
                        Global.cachedMapUser[widget.userId]?.avatarUrl != ""
                            ? Global.cachedMapUser[widget.userId]?.avatarUrl
                            : Global.defaultAvatarUrl,
                        "assets/images/dot.png",
                      ],
                      onIndexChange: (index) {
                        if (index != 0) {
                          Navigator.of(context).pop();
                        }
                      });
                },
                child: TDImage(
                  imgUrl: Global.cachedMapUser[widget.userId]?.avatarUrl,
                  errorWidget: TDImage(
                    assetUrl: "assets/images/default_avatar.avif",
                    type: TDImageType.circle,
                    height: MediaQuery.of(context).size.width / 4,
                    width: MediaQuery.of(context).size.width / 4,
                  ),
                  loadingWidget: const CircularProgressIndicator(),
                  height: MediaQuery.of(context).size.width / 4,
                  width: MediaQuery.of(context).size.width / 4,
                  type: TDImageType.circle,
                ))),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(),
            SizedBox(
                width: MediaQuery.of(context).size.width / 4,
                child: Column(
                  children: [
                    Text(
                        Global.cachedMapUser[widget.userId] != null
                            ? NumberConverter.convertNumber(Global.cachedMapUser[widget.userId]!.followerCount ?? 0)
                            : "NaN",
                        style:
                            _labelStyle.copyWith(fontWeight: FontWeight.bold, fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize)),
                    Text(
                      AppLocalizations.of(context)!.space_follower,
                      style: _labelStyle,
                    ),
                  ],
                )),
            SizedBox(
                width: MediaQuery.of(context).size.width / 4,
                child: Column(
                  children: [
                    Text(
                        Global.cachedMapUser[widget.userId] != null
                            ? NumberConverter.convertNumber(Global.cachedMapUser[widget.userId]!.followingCount ?? 0)
                            : "NaN",
                        style:
                            _labelStyle.copyWith(fontWeight: FontWeight.bold, fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize)),
                    Text(
                      AppLocalizations.of(context)!.space_following,
                      style: _labelStyle,
                    ),
                  ],
                )),
            SizedBox(
                width: MediaQuery.of(context).size.width / 4,
                child: Column(
                  children: [
                    Text(
                      Global.cachedMapUser[widget.userId] != null
                          ? NumberConverter.convertNumber(Global.cachedMapUser[widget.userId]!.likeCount ?? 0)
                          : "NaN",
                      style: _labelStyle.copyWith(fontWeight: FontWeight.bold, fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      AppLocalizations.of(context)!.space_like,
                      style: _labelStyle,
                    ),
                  ],
                )),
            const SizedBox(),
          ],
        ),
        const SizedBox(height: 16.0),
        TextButton(
          onPressed: () async {
            Response response;
            if (Global.self.id == widget.userId) {
              response = await Global.dio.get('/api/v1/user/avatar/upload');
              if (response.data["code"] == Global.successCode) {
                debugPrint(response.data.toString());
                var uploadUrl = response.data["data"]["upload_url"];
                var uptoken = response.data["data"]["uptoken"];
                var uploadKey = response.data["data"]["upload_key"];
                if (uploadUrl != null && uptoken != null && uploadKey != null) {
                  File? file = await _pickFile();
                  if (file != null) {
                    var uFile = await MultipartFile.fromFile(file.path);
                    FormData formData = FormData.fromMap({
                      "file": uFile,
                      "key": uploadKey,
                      "token": uptoken,
                    });
                    response = await Global.dio.post(uploadUrl, data: formData);
                    if (response.statusCode == 200) {
                      Response rr;
                      rr = await Global.dio.get('/api/v1/user/info', data: {
                        "user_id": Global.self.id,
                      });
                      if (rr.data["code"] == Global.successCode) {
                        setState(() {
                          Global.self.avatarUrl = rr.data["data"]["avatar_url"];
                          Global.cachedMapUser[Global.self.id!] = Global.self;
                          debugPrint(Global.self.avatarUrl);
                        });
                      } else {
                        if (context.mounted) {
                          ToastificationUtils.showSimpleToastification(context, rr.data["msg"]);
                        }
                      }
                    } else {
                      if (context.mounted) {
                        ToastificationUtils.showSimpleToastification(context, '上传失败');
                      }
                    }
                  } else {
                    if (context.mounted) {
                      ToastificationUtils.showSimpleToastification(context, '请选择图片');
                    }
                  }
                }
              } else {
                if (context.mounted) {
                  ToastificationUtils.showSimpleToastification(context, response.data["msg"]);
                }
              }
            } else {
              response = await Global.dio.post("/api/v1/relation/follow/action",
                  data: {"to_user_id": widget.userId, "action_type": Global.cachedMapUser[widget.userId]?.isFollowed == true ? 0 : 1});
              if (response.data["code"] == Global.successCode) {
                Global.cachedMapUser[widget.userId]?.isFollowed = !(Global.cachedMapUser[widget.userId]?.isFollowed ?? false);
                setState(() {});
              } else {
                if (context.mounted) {
                  ToastificationUtils.showSimpleToastification(context, response.data["msg"]);
                }
              }
            }
          },
          style: ButtonStyle(
            overlayColor: WidgetStateProperty.all(Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5)),
            backgroundColor: WidgetStateProperty.all(Theme.of(context).primaryColor),
            shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),
          ),
          child: Text(
            Global.self.id == widget.userId ? "上传头像" : "关注",
            style: TextStyle(
                color: Theme.of(context).scaffoldBackgroundColor,
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  Future<File?> _pickFile() async {
    var result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
    );
    if (result != null) {
      File file = File(result.files.single.path!);
      if (FileTypeJudge.isImage(file)) {
        return file;
      }
    }
    return null;
  }
}
