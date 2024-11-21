import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fulifuli_app/global.dart';
import 'package:fulifuli_app/utils/language_reflect.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../generated/l10n.dart';
import '../utils/toastification.dart';
import 'icons/def.dart';

class ReportPopup {
  static void show(BuildContext context, double width, double height,
      {required String oType, required String oId, double? radius, String? commentType, String? fromMediaId}) {
    Navigator.push(
      context,
      TDSlidePopupRoute(
          modalBarrierColor: Theme.of(context).textTheme.headlineMedium!.color!.withOpacity(0.5),
          builder: (context) {
            return TDPopupBottomDisplayPanel(
                title: S.current.function_default_report,
                titleColor: Theme.of(context).textTheme.headlineMedium!.color,
                closeColor: Theme.of(context).textTheme.headlineMedium!.color,
                closeClick: () {
                  Navigator.pop(context, true);
                },
                radius: radius,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                child: SizedBox(
                  width: width,
                  height: height,
                  child: ReportPopupContainer(
                    oType: oType,
                    oId: oId,
                    fromMediaId: fromMediaId,
                    commentType: commentType,
                  ),
                ));
          }),
    );
  }
}

class ReportPopupContainer extends StatefulWidget {
  const ReportPopupContainer({super.key, required this.oType, required this.oId, this.commentType, this.fromMediaId});

  final String oType;
  final String oId;
  final String? commentType;
  final String? fromMediaId;

  @override
  State<StatefulWidget> createState() {
    return _ReportPopupContainerState();
  }
}

class _ReportPopupContainerState extends State<ReportPopupContainer> {
  static const List<String> _reportSelections = ["垃圾信息", "侮辱性语言", "侵权行为", "其他"];
  static const List<IconData> _reportIcons = [
    DisplayIcons.spamming,
    DisplayIcons.abuse,
    DisplayIcons.infringement,
    DisplayIcons.others,
  ];

  final TextEditingController _controller = TextEditingController();
  int? _selected;

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
      alignment: Alignment.topCenter,
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 16, right: 16),
        itemBuilder: (context, index) {
          return [
            for (var i = 0; i < _reportSelections.length; i++)
              RadioMenuButton(
                value: i,
                groupValue: _selected,
                trailingIcon: Icon(_reportIcons[i]),
                onChanged: (value) {
                  setState(() {
                    _selected = value;
                  });
                },
                child: Text(LanguageReflect.reportReflect(_reportSelections[i])),
              ),
            const Divider(),
            TDTextarea(
              controller: _controller,
              hintText: S.current.report_report_reason_hint,
              minLines: 3,
              maxLength: 256,
              textStyle: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium!.color,
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              ),
              onChanged: (value) {
                setState(() {});
              },
              indicator: true,
            ),
            Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          _controller.clear();
                          setState(() {
                            _selected = null;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            overlayColor: Colors.redAccent,
                            backgroundColor: Colors.red,
                            elevation: 4,
                            fixedSize: Size(MediaQuery.of(context).size.width * 0.4, 40),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                        child: Row(
                          children: [
                            const Icon(DisplayIcons.clear, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(
                              S.current.function_default_clear,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                              ),
                            ),
                          ],
                        )),
                    ElevatedButton(
                        onPressed: () async {
                          String? result = await _sendReport();
                          if (result != null) {
                          } else {
                            if (context.mounted) {
                              _controller.clear();
                              ToastificationUtils.showSimpleToastification(S.current.report_submit_success);
                              Navigator.pop(context, true);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            overlayColor: Theme.of(context).dialogBackgroundColor,
                            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                            elevation: 4,
                            fixedSize: Size(MediaQuery.of(context).size.width * 0.4, 40),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                        child: Row(
                          children: [
                            Icon(DisplayIcons.post, color: Theme.of(context).primaryColor),
                            const SizedBox(width: 4),
                            Text(
                              S.current.function_default_submit,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                              ),
                            ),
                          ],
                        )),
                  ],
                )),
          ][index];
        },
        itemCount: _reportSelections.length + 3,
      ),
    ));
  }

  Future<String?> _sendReport() async {
    if (_selected == null) {
      return S.current.report_not_select_report_type;
    }
    if (_controller.text.isEmpty) {
      return S.current.report_not_type_report_reason;
    }
    debugPrint('sendReport: ${widget.oType}, ${widget.oId}, ${_reportSelections[_selected!]}, ${_controller.text}');
    debugPrint('sendReport: ${widget.commentType}, ${widget.fromMediaId}');
    Response response;
    response = await Global.dio.post('/api/v1/report/${widget.oType}', data: {
      "${widget.oType}_id": widget.oId,
      "label": _reportSelections[_selected!],
      "content": _controller.text,
      if (widget.commentType != null) "comment_type": widget.commentType,
      if (widget.fromMediaId != null) "from_media_id": widget.fromMediaId,
    });
    if (response.data["code"] != Global.successCode) {
      return response.data["msg"];
    }
    return null;
  }
}
