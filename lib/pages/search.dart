import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fulifuli_app/widgets/search_page/search_page_tabs_container.dart';
import 'package:fulifuli_app/widgets/search_page/search_page_top_bar.dart';

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

  Future<void> _onSearch(String keyword) async {
    debugPrint(keyword);
    body = const Center(
      child: CircularProgressIndicator(),
    );
    setState(() {});
    Future.delayed(const Duration(seconds: 2), () {
      body = _getTabsView();
      setState(() {});
    });
  }

  Widget _getTabsView() {
    return SearchPageTabsContainer(tabs: [
      AppLocalizations.of(context)!.search_video,
      AppLocalizations.of(context)!.search_user
    ]);
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
