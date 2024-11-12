import 'dart:math';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fulifuli_app/widgets/dynamic_card.dart';

import '../../../utils/option_grid_view.dart';
import '../../global.dart';

class SpaceDynamicTabsView extends StatefulWidget {
  const SpaceDynamicTabsView({
    super.key,
    required this.controller,
    required this.currentIndex,
    required this.onUpdate,
    required this.assignedIndex,
    required this.uniqueKey,
  });

  final ScrollController? controller;
  final int currentIndex;
  final Function onUpdate;
  final int assignedIndex;
  final String uniqueKey;

  @override
  State<SpaceDynamicTabsView> createState() {
    return _SpaceDynamicTabsViewState();
  }
}

class _SpaceDynamicTabsViewState extends State<SpaceDynamicTabsView> {
  late List<String> dynamicList = [];
  late EasyRefreshController _easyRefreshController;

  @override
  void initState() {
    super.initState();
    bool isCached = Global.cachedMapDynamicList.containsKey(widget.uniqueKey);
    if (!isCached) {
      Global.cachedMapDynamicList
          .addEntries([MapEntry(widget.uniqueKey, dynamicList)]);
      debugPrint('Added new dynamic list with key: ${widget.uniqueKey}');
    }
    dynamicList = Global.cachedMapDynamicList[widget.uniqueKey]!;

    if (isCached) {
      return;
    }

    var widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((_) {
      if (dynamicList.isEmpty && widget.currentIndex == widget.assignedIndex) {
        debugPrint('Adding new dynamic item');
        switch (Random().nextInt(3)) {
          case 0:
            dynamicList.add('Dynamic 1');
            break;
        }
        setState(() {});
      }
    });
  }

  @override
  void didUpdateWidget(covariant SpaceDynamicTabsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex == widget.assignedIndex) {
      debugPrint('Adding new dynamic item');
      dynamicList.add('Dynamic 1');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _easyRefreshController = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );

    TextStyle hintStyle = TextStyle(
      fontSize: Theme.of(context).textTheme.headlineSmall!.fontSize,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).primaryColor,
    );

    return EasyRefresh.builder(
        header: MaterialHeader(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).primaryColor,
          ),
        ),
        footer: ClassicFooter(
          messageStyle: TextStyle(
            fontSize: Theme.of(context).textTheme.labelLarge!.fontSize,
            color: Theme.of(context).primaryColor,
          ),
          textStyle: TextStyle(
            fontSize: Theme.of(context).textTheme.labelLarge!.fontSize,
            color: Theme.of(context).primaryColor,
          ),
          dragText: AppLocalizations.of(context)!.home_page_refresher_drag_text,
          armedText:
              AppLocalizations.of(context)!.home_page_refresher_armed_text,
          readyText:
              AppLocalizations.of(context)!.home_page_refresher_ready_text,
          processedText:
              AppLocalizations.of(context)!.home_page_refresher_processed_text,
          processingText:
              AppLocalizations.of(context)!.home_page_refresher_processing_text,
          noMoreText:
              AppLocalizations.of(context)!.home_page_refresher_no_more_text,
          failedText:
              AppLocalizations.of(context)!.home_page_refresher_failed_text,
          messageText:
              AppLocalizations.of(context)!.home_page_refresher_message_text,
          iconTheme: IconThemeData(
            color: Theme.of(context).primaryColor,
          ),
        ),
        controller: _easyRefreshController,
        onRefresh: () async {
          await Future<void>.delayed(const Duration(milliseconds: 500));
          if (!mounted) {
            return;
          }
          dynamicList.add('Dynamic ${dynamicList.length + 1}');
          _easyRefreshController.finishRefresh();
          _easyRefreshController.resetHeader();
          setState(() {});
        },
        onLoad: () async {
          await Future<void>.delayed(const Duration(milliseconds: 4000));
          if (!mounted) {
            return IndicatorResult.noMore;
          }
          _easyRefreshController.finishLoad();
          _easyRefreshController.resetFooter();
          return IndicatorResult.noMore;
        },
        scrollController: widget.controller,
        childBuilder: (BuildContext context, ScrollPhysics physics) {
          return dynamicList.isEmpty
              ? OptionGridView(
                  itemCount: 1,
                  rowCount: 1,
                  itemBuilder: (_, __) {
                    return SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Image.asset(
                                    'assets/images/cute/konata_dancing.webp'),
                                Text(
                                  AppLocalizations.of(context)!
                                      .space_nothing_hint,
                                  style: hintStyle,
                                ),
                              ],
                            ),
                            const SizedBox(),
                            Text(
                              AppLocalizations.of(context)!
                                  .space_nothing_hint_bottom,
                              style: hintStyle,
                            ),
                            const SizedBox()
                          ],
                        ));
                  })
              : OptionGridView(
                  physics: physics,
                  itemCount: dynamicList.length,
                  rowCount: 1,
                  itemBuilder: (context, index) {
                    return const DynamicCard();
                  },
                );
        });
  }
}
