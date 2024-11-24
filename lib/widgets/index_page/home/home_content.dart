import 'dart:math';

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
  late ScrollController _scrollController;
  late ScrollController _scrollController2;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController2 = ScrollController();
    _scrollController2.addListener(() {
      _scrollController.jumpTo(min(_scrollController2.offset, _scrollController.position.maxScrollExtent));
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _scrollController2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(controller: _scrollController, slivers: [
      SliverAppBar(
        toolbarHeight: 48,
        floating: false,
        leading: Container(),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        flexibleSpace: const HomeTopBar(),
      ),
      SliverFillRemaining(
        child: VideoTabsContainer(
          controller: _scrollController2,
          tabs: [
            S.current.home_tabs_recommend,
            S.current.home_tabs_game,
            S.current.home_tabs_vitascope,
            S.current.home_tabs_military,
            S.current.home_tabs_knowledge,
            S.current.home_tabs_news,
            S.current.home_tabs_life,
          ],
        ),
      )
    ]);
  }
}
