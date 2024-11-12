import 'package:flutter/material.dart';
import 'package:fulifuli_app/global.dart';
import 'package:fulifuli_app/widgets/index_page/home/video_tabs_view.dart';
import 'package:fulifuli_app/widgets/search_page/search_page_user_tabs_view.dart';
import 'package:fulifuli_app/widgets/search_page/search_page_video_tabs_view.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class SearchPageTabsContainer extends StatefulWidget {
  const SearchPageTabsContainer({super.key, required this.tabs});

  final List<String> tabs;

  @override
  State<StatefulWidget> createState() {
    return _SearchPageTabsContainerState();
  }
}

class _SearchPageTabsContainerState extends State<SearchPageTabsContainer>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;
  List<TDTab> tabs = [];
  List<VideoTabsView> tabViews = [];

  List<TDTab> _getTabs() {
    tabs = [
      for (var i = 0; i < widget.tabs.length; i++)
        TDTab(
          text: widget.tabs[i],
          size: TDTabSize.large,
        )
    ];
    return tabs;
  }

  void _initTabController() {
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
  }

  @override
  void initState() {
    _getTabs();
    _initTabController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    Global.cachedMapUserList.remove(SearchPageUserTabsView.uniqueKey);
    Global.cachedMapVideoList.remove(SearchPageVideoTabsView.uniqueKey);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TDTabBar(
          height: 48,
          tabs: tabs,
          controller: _tabController,
          showIndicator: true,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Theme.of(context).unselectedWidgetColor,
          indicatorColor: Theme.of(context).primaryColor,
          isScrollable: true,
          labelPadding: const EdgeInsets.symmetric(horizontal: 20.0),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              SearchPageVideoTabsView(
                currentIndex: _currentIndex,
                assignedIndex: 0,
              ),
              SearchPageUserTabsView(
                currentIndex: _currentIndex,
                assignedIndex: 1,
              ),
            ],
          ),
        )
      ],
    );
  }
}
