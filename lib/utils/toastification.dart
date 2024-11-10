import 'package:flutter/cupertino.dart';
import 'package:toastification/toastification.dart';

class ToastificationUtils {
  static showSimpleToastification(BuildContext context, String text,
      {Duration duration = const Duration(milliseconds: 1500)}) {
    toastification.show(
      context: context,
      autoCloseDuration: duration,
      style: ToastificationStyle.simple,
      title: Text(text),
      alignment: const Alignment(0, 0.8),
    );
  }
}
