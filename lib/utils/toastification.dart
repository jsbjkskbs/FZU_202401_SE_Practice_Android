import 'package:flutter/material.dart';
import 'package:fulifuli_app/utils/context_provider.dart';
import 'package:toastification/toastification.dart';

import '../generated/l10n.dart';

class ToastificationUtils {
  static showSimpleToastification(String text, {Duration duration = const Duration(milliseconds: 1500)}) {
    toastification.show(
      context: ContextProvider.navigatorContext,
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

  static showDownloadSuccess({required String path}) {
    toastification.show(
      context: ContextProvider.navigatorContext,
      type: ToastificationType.success,
      style: ToastificationStyle.flat,
      title: Text(S.current.when_download_success, maxLines: 4),
      description: Text(S.current.when_file_saved_to_path(path), maxLines: 10),
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
