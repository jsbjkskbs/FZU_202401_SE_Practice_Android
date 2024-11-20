import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ToastificationUtils {
  static showSimpleToastification(BuildContext context, String text, {Duration duration = const Duration(milliseconds: 1500)}) {
    toastification.show(
      context: context,
      autoCloseDuration: duration,
      style: ToastificationStyle.simple,
      title: Text(text, maxLines: 4),
      alignment: const Alignment(0, 0.8),
    );
  }

  static showFlatToastification(
    BuildContext context,
    String? text,
    String description, {
    Duration duration = const Duration(milliseconds: 1500),
    Widget? icon,
  }) {
    toastification.show(
      context: context,
      autoCloseDuration: duration,
      style: ToastificationStyle.flat,
      icon: icon,
      title: text != null
          ? Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                text,
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                    fontWeight: FontWeight.bold),
              ))
          : null,
      description: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            description,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
            ),
          )),
      alignment: const Alignment(4, -0.8),
    );
  }

  static showDownloadSuccess(BuildContext context, {required String path}) {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.flat,
      title: const Text('下载成功'),
      description: Text('文件已保存至$path', maxLines: 10),
      alignment: Alignment.center,
      autoCloseDuration: const Duration(seconds: 3),
      animationBuilder: (
        context,
        animation,
        alignment,
        child,
      ) {
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      },
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: highModeShadow,
    );
  }
}
