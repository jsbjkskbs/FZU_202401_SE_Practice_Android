import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

import '../generated/l10n.dart';

class LoadFooter {
  static Footer buildInformationFooter(BuildContext context) {
    return ClassicFooter(
      messageStyle: TextStyle(
        fontSize: Theme.of(context).textTheme.labelLarge!.fontSize,
        color: Theme.of(context).primaryColor,
        decoration: TextDecoration.none,
      ),
      textStyle: TextStyle(
        fontSize: Theme.of(context).textTheme.labelLarge!.fontSize,
        color: Theme.of(context).primaryColor,
        decoration: TextDecoration.none,
      ),
      dragText: S.current.home_page_refresher_drag_text,
      armedText: S.current.home_page_refresher_armed_text,
      readyText: S.current.home_page_refresher_ready_text,
      processedText: S.current.home_page_refresher_processed_text,
      processingText: S.current.home_page_refresher_processing_text,
      noMoreText: S.current.home_page_refresher_no_more_text,
      failedText: S.current.home_page_refresher_failed_text,
      messageText: S.current.home_page_refresher_message_text,
      iconTheme: IconThemeData(
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
