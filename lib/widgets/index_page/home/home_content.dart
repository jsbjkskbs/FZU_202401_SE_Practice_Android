import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fulifuli_app/widgets/index_page/home/home_top_bar.dart';
import 'package:fulifuli_app/widgets/index_page/home/video_tabs_container.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeContentState();
  }
}

class _HomeContentState extends State<HomeContent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      SliverAppBar(
        toolbarHeight: 48,
        floating: false,
        leading: Container(),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        flexibleSpace: const HomeTopBar(),
      ),
      SliverFillRemaining(
        child: VideoTabsContainer(
          controller: ScrollController(),
          tabs: [
            AppLocalizations.of(context)!.home_tabs_recommend,
            AppLocalizations.of(context)!.home_tabs_game,
            AppLocalizations.of(context)!.home_tabs_vitascope,
            AppLocalizations.of(context)!.home_tabs_military,
            AppLocalizations.of(context)!.home_tabs_knowledge,
            AppLocalizations.of(context)!.home_tabs_news,
            AppLocalizations.of(context)!.home_tabs_life,
          ],
        ),
      )
    ]);
  }
}
