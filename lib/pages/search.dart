import 'package:flutter/material.dart';
import 'package:fulifuli_app/widgets/search_page/search_page_tabs_container.dart';
import 'package:fulifuli_app/widgets/search_page/search_page_top_bar.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../generated/l10n.dart';
import '../global.dart';
import '../widgets/search_page/search_page_user_tabs_view.dart';
import '../widgets/search_page/search_page_video_tabs_view.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  static String routeName = '/search';

  @override
  State<SearchPage> createState() {
    return _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage> {
  late Widget body = const Center();

  @override
  void dispose() {
    super.dispose();
    Global.cachedMapUserList.remove(SearchPageUserTabsView.uniqueKey);
    Global.cachedMapVideoList.remove(SearchPageVideoTabsView.uniqueKey);
  }

  Future<void> _onSearch(String keyword) async {
    Global.cachedMapUserList.remove(SearchPageUserTabsView.uniqueKey);
    Global.cachedMapVideoList.remove(SearchPageVideoTabsView.uniqueKey);
    body = Center(
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TDImage(
            assetUrl: 'assets/images/cute/konata_dancing.webp',
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width * 0.6,
          ),
          Text(S.current.search_loading_hint),
        ],
      )),
    );
    setState(() {});
    Future.delayed(const Duration(milliseconds: 500), () {
      body = _getTabsView(keyword);
      setState(() {});
    });
  }

  Widget _getTabsView(String keyword) {
    return SearchPageTabsContainer(tabs: [S.current.search_video, S.current.search_user], keyword: keyword);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
          toolbarHeight: 56,
          leading: SizedBox(
              width: 40,
              height: 40,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          titleSpacing: 0,
          title: SearchPageTopBar(
            onSearch: _onSearch,
          )),
      body: body,
    ));
  }
}
