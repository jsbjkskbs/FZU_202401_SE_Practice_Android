import 'package:flutter/material.dart';
import 'package:fulifuli_app/global.dart';
import 'package:fulifuli_app/widgets/index_page/home/video_tabs_view.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class VideoTabsContainer extends StatefulWidget {
  const VideoTabsContainer(
      {super.key, required this.controller, required this.tabs});

  final ScrollController controller;
  final List<String> tabs;

  @override
  State<StatefulWidget> createState() {
    return _VideoTabsContainerState();
  }
}

class _VideoTabsContainerState extends State<VideoTabsContainer>
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

  void _initTabView() {
    for (var i = 0; i < tabs.length; i++) {
      Global.cachedVideoList.add([]);
    }
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
    _initTabView();
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
              for (var i = 0; i < tabs.length; i++)
                VideoTabsView(
                  controller: widget.controller,
                  currentIndex: _currentIndex,
                  onUpdate: () {},
                  assignedIndex: i,
                )
            ],
          ),
        )
      ],
    );
  }
}
