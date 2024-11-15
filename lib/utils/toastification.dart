import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ToastificationUtils {
  static showSimpleToastification(BuildContext context, String text, {Duration duration = const Duration(milliseconds: 1500)}) {
    toastification.show(
      context: context,
      autoCloseDuration: duration,
      style: ToastificationStyle.simple,
      title: Text(text),
      alignment: const Alignment(0, 0.8),
    );
  }

  static showFlatToastification(
    BuildContext context,
    String text,
    String description, {
    Duration duration = const Duration(milliseconds: 1500),
    Widget? icon,
  }) {
    toastification.show(
      context: context,
      autoCloseDuration: duration,
      style: ToastificationStyle.flat,
      icon: icon,
      title: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            text,
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                fontWeight: FontWeight.bold),
          )),
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
}
