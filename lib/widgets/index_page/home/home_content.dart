import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fulifuli_app/widgets/index_page/home/home_top_bar.dart';
import 'package:fulifuli_app/widgets/index_page/home/video_tabs_container.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeContentState();
  }
}

class _HomeContentState extends State<HomeContent> {
  late LinkedScrollControllerGroup _controllerGroup;
  late ScrollController _tabBarScrollController;
  late ScrollController _tabViewScrollController;

  @override
  void initState() {
    _controllerGroup = LinkedScrollControllerGroup();
    _tabBarScrollController = _controllerGroup.addAndGet();
    _tabViewScrollController = _controllerGroup.addAndGet();
    super.initState();
  }

  @override
  void dispose() {
    _tabBarScrollController.dispose();
    _tabViewScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(controller: _tabBarScrollController, slivers: [
      SliverAppBar(
        toolbarHeight: 48,
        floating: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        flexibleSpace: const HomeTopBar(),
      ),
      SliverFillRemaining(
        child: VideoTabsContainer(
          controller: _tabViewScrollController,
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
