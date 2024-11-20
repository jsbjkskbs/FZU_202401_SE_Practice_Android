import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      dragText: AppLocalizations.of(context)!.home_page_refresher_drag_text,
      armedText: AppLocalizations.of(context)!.home_page_refresher_armed_text,
      readyText: AppLocalizations.of(context)!.home_page_refresher_ready_text,
      processedText: AppLocalizations.of(context)!.home_page_refresher_processed_text,
      processingText: AppLocalizations.of(context)!.home_page_refresher_processing_text,
      noMoreText: AppLocalizations.of(context)!.home_page_refresher_no_more_text,
      failedText: AppLocalizations.of(context)!.home_page_refresher_failed_text,
      messageText: AppLocalizations.of(context)!.home_page_refresher_message_text,
      iconTheme: IconThemeData(
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
