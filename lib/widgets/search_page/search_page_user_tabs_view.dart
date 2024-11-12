import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:fulifuli_app/global.dart';
import 'package:fulifuli_app/widgets/search_page/search_page_user_item.dart';

class SearchPageUserTabsView extends StatefulWidget {
  const SearchPageUserTabsView(
      {super.key, required this.currentIndex, required this.assignedIndex});

  static const String uniqueKey = "search-user";
  final int currentIndex;
  final int assignedIndex;

  @override
  State<StatefulWidget> createState() {
    return _SearchPageUserTabsViewState();
  }
}

class _SearchPageUserTabsViewState extends State<SearchPageUserTabsView> {
  List<String> userList = [];
  final EasyRefreshController _controller = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  @override
  void initState() {
    super.initState();

    bool isCached =
        Global.cachedMapUserList.containsKey(SearchPageUserTabsView.uniqueKey);
    if (!isCached) {
      Global.cachedMapUserList
          .addEntries([MapEntry(SearchPageUserTabsView.uniqueKey, userList)]);
      debugPrint(
          'Added new user list with key: ${SearchPageUserTabsView.uniqueKey}');
    }
    userList = Global.cachedMapUserList[SearchPageUserTabsView.uniqueKey]!;

    if (isCached) {
      return;
    }

    var widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((callback) {
      _controller.callRefresh();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
        controller: _controller,
        header: const MaterialHeader(),
        footer: const MaterialFooter(),
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 2), () {
            userList.addAll(['user1', 'user2', 'user3']);
            setState(() {});
            _controller.finishRefresh();
          });
        },
        onLoad: () async {
          await Future.delayed(const Duration(seconds: 2), () {
            userList.addAll(['user4', 'user5', 'user6']);
            setState(() {});
            _controller.finishLoad();
          });
        },
        child: ListView.separated(
            itemBuilder: (context, index) {
              return SearchPageUserItem(onTap: () {});
            },
            separatorBuilder: (context, index) => const Divider(),
            itemCount: userList.length));
  }
}
