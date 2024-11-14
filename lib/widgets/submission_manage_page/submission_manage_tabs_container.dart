import 'package:flutter/material.dart';
import 'package:fulifuli_app/global.dart';
import 'package:fulifuli_app/widgets/index_page/home/video_tabs_view.dart';
import 'package:fulifuli_app/widgets/submission_manage_page/submission_manage_video_tabs_view.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class SubmissionManageTabsContainer extends StatefulWidget {
  const SubmissionManageTabsContainer({super.key, required this.tabs});

  final List<String> tabs;

  @override
  State<StatefulWidget> createState() {
    return _SubmissionManageTabsContainer();
  }
}

class _SubmissionManageTabsContainer
    extends State<SubmissionManageTabsContainer> with TickerProviderStateMixin {
  static const _uniqueKeyPrefix = 'SubmissionManageTabsContainer';
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
    for (var i = 0; i < tabs.length; i++) {
      Global.cachedMapVideoList.remove('$_uniqueKeyPrefix-$i');
    }
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
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              for (var i = 0; i < tabs.length; i++)
                SubmissionManageVideoTabsView(
                    currentIndex: _currentIndex,
                    assignedIndex: i,
                    uniqueKey: '$_uniqueKeyPrefix-$i'),
            ],
          ),
        )
      ],
    );
  }
}
