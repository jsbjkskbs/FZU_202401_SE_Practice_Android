import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fulifuli_app/global.dart';
import 'package:fulifuli_app/utils/toastification.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

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

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(appBar: _getAppbar(context), body: _getBody(context), bottomSheet: _getBottomSheet(context)));
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
            Text('发布动态', style: Theme.of(context).textTheme.headlineSmall),
            ElevatedButton(
                onPressed: () {
                  ToastificationUtils.showSimpleToastification(context, '这里没有东西╮(╯▽╰)╭');
                },
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    overlayColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    backgroundColor: Colors.transparent,
                    iconColor: Theme.of(context).textTheme.headlineSmall!.color,
                    padding: EdgeInsets.zero),
                child: Icon(Icons.more_vert,
                    size: Theme.of(context).textTheme.headlineSmall!.fontSize, color: Theme.of(context).textTheme.headlineSmall!.color)),
          ],
        ));
  }

  Widget _getBody(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) {
          return [
            const SizedBox(height: 16),
            TDTextarea(
                hintText: '这一刻的想法...',
                autofocus: false,
                minLines: 8,
                maxLength: 256,
                additionInfo: '${_contentController.text.length} / 256 字',
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
        itemCount: 2);
  }

  Widget _getBottomSheet(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: ElevatedButton(
                onPressed: () {
                  _contentController.clear();
                },
                style: ElevatedButton.styleFrom(
                  elevation: 4,
                  overlayColor: Theme.of(context).cardColor,
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(DisplayIcons.clear, color: Colors.white),
                    Text('清空', style: TextStyle(color: Colors.white)),
                  ],
                )),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: ElevatedButton(
                onPressed: () async {
                  String? result = await _sendDynamic();
                  if (context.mounted) {
                    if (result != null) {
                      ToastificationUtils.showSimpleToastification(context, result);
                    } else {
                      Navigator.pop(context);
                      ToastificationUtils.showSimpleToastification(context, '发布成功');
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
                      '发布',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    )
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Future<String?> _sendDynamic() async {
    Response response;
    response = await Global.dio.post('/api/v1/activity/publish', data: {
      "content": _contentController.text,
    });
    if (response.data["code"] == Global.successCode) {
      return null;
    } else {
      return response.data["msg"];
    }
  }
}
