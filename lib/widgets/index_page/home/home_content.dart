import 'package:flutter/material.dart';
import 'package:fulifuli_app/widgets/index_page/home/home_top_bar.dart';
import 'package:fulifuli_app/widgets/index_page/home/video_tabs_container.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

import '../../../generated/l10n.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeContentState();
  }
}

class _HomeContentState extends State<HomeContent> {
  final LinkedScrollControllerGroup _controllers = LinkedScrollControllerGroup();
  late ScrollController _scrollController;
  late ScrollController _scrollController2;

  @override
  void initState() {
    super.initState();
    _scrollController = _controllers.addAndGet();
    _scrollController2 = _controllers.addAndGet();
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
