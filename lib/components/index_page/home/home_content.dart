import 'package:flutter/material.dart';
import 'package:fulifuli_app/components/index_page/home/video_tabs_container.dart';
import 'package:fulifuli_app/components/index_page/home/home_top_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeContentState();
  }
}

class _HomeContentState extends State<HomeContent> {
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(controller: _controller, slivers: [
      const SliverAppBar(
        toolbarHeight: 48,
        backgroundColor: Colors.transparent,
        floating: false,
        flexibleSpace: HomeTopBar(),
      ),
      SliverFillRemaining(
        child: VideoTabsContainer(
          controller: _controller,
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
