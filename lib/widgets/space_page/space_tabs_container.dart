import 'package:flutter/material.dart';
import 'package:fulifuli_app/widgets/index_page/home/video_tabs_view.dart';
import 'package:fulifuli_app/widgets/space_page/space_dynamic_tabs_view.dart';
import 'package:fulifuli_app/widgets/space_page/space_video_tabs_view.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class SpaceTabsContainer extends StatefulWidget {
  const SpaceTabsContainer(
      {super.key,
      required this.tabs,
      required this.uniqueKey,
      this.scrollController});

  final List<String> tabs;
  final String uniqueKey;
  final ScrollController? scrollController;

  @override
  State<StatefulWidget> createState() {
    return _SpaceTabsContainerState();
  }
}

class _SpaceTabsContainerState extends State<SpaceTabsContainer>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late final ScrollController? _scrollController = widget.scrollController;
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
    _tabController.dispose();
    super.dispose();
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
              SpaceVideoTabsView(
                controller: _scrollController,
                currentIndex: _currentIndex,
                onUpdate: () {},
                assignedIndex: 0,
                uniqueKey: widget.uniqueKey,
              ),
              SpaceDynamicTabsView(
                  controller: _scrollController,
                  currentIndex: _currentIndex,
                  onUpdate: () {},
                  assignedIndex: 1,
                  uniqueKey: widget.uniqueKey),
            ],
          ),
        )
      ],
    );
  }
}
