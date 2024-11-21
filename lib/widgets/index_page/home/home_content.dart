import 'package:flutter/material.dart';
import 'package:fulifuli_app/widgets/index_page/home/home_top_bar.dart';
import 'package:fulifuli_app/widgets/index_page/home/video_tabs_container.dart';

import '../../../generated/l10n.dart';

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
            S.of(context).home_tabs_recommend,
            S.of(context).home_tabs_game,
            S.of(context).home_tabs_vitascope,
            S.of(context).home_tabs_military,
            S.of(context).home_tabs_knowledge,
            S.of(context).home_tabs_news,
            S.of(context).home_tabs_life,
          ],
        ),
      )
    ]);
  }
}
