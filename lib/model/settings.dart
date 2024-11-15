import 'package:flutter/cupertino.dart';

class SettingsItem {
  final String label;
  final String kind;
  final int labelIndex;
  final int kindIndex;
  Function? onTap;
  Icon? icon;
  Widget? rightWidget;

  SettingsItem(
      {required this.label,
      required this.kind,
      required this.labelIndex,
      required this.kindIndex,
      this.onTap,
      this.icon,
      this.rightWidget});
}
