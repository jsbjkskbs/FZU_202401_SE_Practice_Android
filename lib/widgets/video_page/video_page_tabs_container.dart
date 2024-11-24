import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:fulifuli_app/utils/toastification.dart';
import 'package:fulifuli_app/widgets/comment_popup.dart';
import 'package:fulifuli_app/widgets/index_page/home/video_tabs_view.dart';
import 'package:fulifuli_app/widgets/video_page/video_introduction_view.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../generated/l10n.dart';
import '../../model/video.dart';
import '../comment_list.dart';
import '../comment_reply_fake_container.dart';

class VideoPageTabsContainer extends StatefulWidget {
  const VideoPageTabsContainer({super.key, required this.tabs, required this.video, required this.blockScroll});

  final List<String> tabs;
  final Video video;
  final bool blockScroll;

  @override
  State<StatefulWidget> createState() {
    return _VideoPageTabsContainer();
  }
}

class _VideoPageTabsContainer extends State<VideoPageTabsContainer> with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;
  int _currentRollingIndex = 0;
  List<TDTab> tabs = [];
  List<VideoTabsView> tabViews = [];
  final EasyRefreshController _easyRefreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  List<TDTab> _getTabs() {
    tabs = [
      for (var i = 0; i < widget.tabs.length; i++)
        TDTab(
          text: widget.tabs[i],
          size: TDTabSize.small,
        )
    ];
    return tabs;
  }

  void _initTabController() {
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(() {
      debugPrint('${_currentIndex != _tabController.index && _tabController.index == 1}');
      if (_currentIndex != _tabController.index) {
        setState(() {
          _currentIndex = _tabController.index;
        });
      }
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
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
                padding: const EdgeInsets.only(left: 8),
                child: TDTabBar(
                  height: 38,
                  width: MediaQuery.of(context).size.width * 0.42,
                  tabs: tabs,
                  controller: _tabController,
                  showIndicator: true,
                  isScrollable: false,
                  labelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
                  unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Theme.of(context).unselectedWidgetColor,
                  indicatorColor: Theme.of(context).primaryColor,
                  dividerColor: Colors.transparent,
                )),
            Padding(
                padding: const EdgeInsets.only(right: 8),
                child: AnimatedToggleSwitch<int>.rolling(
                  current: _currentRollingIndex,
                  height: 34,
                  values: const [0, 1, 2, 3],
                  onChanged: (index) => setState(() {
                    _currentRollingIndex = index;
                  }),
                  iconList: [
                    Image.asset('assets/images/logo/f.png', width: 16, height: 16),
                    Image.asset('assets/images/logo/u.png', width: 16, height: 16),
                    Image.asset('assets/images/logo/l.png', width: 16, height: 16),
                    Image.asset('assets/images/logo/i.png', width: 16, height: 16),
                  ],
                  onTap: (_) {
                    ToastificationUtils.showFlatToastification(
                      context,
                      'Hello World',
                      'FuliFuli干杯~',
                      icon: Icon(
                        Icons.polymer_rounded,
                        color: Theme.of(context).primaryColor,
                      ),
                      duration: const Duration(seconds: 2),
                    );
                  },
                ))
          ],
        ),
        const Divider(
          height: 0,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              VideoIntroductionView(
                video: widget.video,
                blockScroll: widget.blockScroll,
              ),
              Column(
                children: [
                  Expanded(
                      child: CommentListView(
                    oType: 'video',
                    oId: widget.video.id!,
                    easyRefreshController: _easyRefreshController,
                  )),
                  GestureDetector(
                    onTap: () {
                      CommentPopup.showReplyPanel(context, oType: 'video', oId: widget.video.id!, onSend: () {
                        _easyRefreshController.callRefresh();
                      });
                    },
                    child: CommentReplyPopupFakeContainer(
                      hintText: S.current.reply_comment_popup_hint,
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
