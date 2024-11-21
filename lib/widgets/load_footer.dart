import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

import '../generated/l10n.dart';

class LoadFooter {
  static Footer buildInformationFooter(BuildContext context) {
    return ClassicFooter(
      messageStyle: TextStyle(
        fontSize: Theme.of(context).textTheme.labelLarge!.fontSize,
        color: Theme.of(context).primaryColor,
      ),
      textStyle: TextStyle(
        fontSize: Theme.of(context).textTheme.labelLarge!.fontSize,
        color: Theme.of(context).primaryColor,
      ),
      dragText: S.of(context).home_page_refresher_drag_text,
      armedText: S.of(context).home_page_refresher_armed_text,
      readyText: S.of(context).home_page_refresher_ready_text,
      processedText: S.of(context).home_page_refresher_processed_text,
      processingText: S.of(context).home_page_refresher_processing_text,
      noMoreText: S.of(context).home_page_refresher_no_more_text,
      failedText: S.of(context).home_page_refresher_failed_text,
      messageText: S.of(context).home_page_refresher_message_text,
      iconTheme: IconThemeData(
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
