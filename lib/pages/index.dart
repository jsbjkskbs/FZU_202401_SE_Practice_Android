import 'package:flutter/material.dart';
import 'package:fulifuli_app/pages/tabs/activity.dart';
import 'package:fulifuli_app/pages/tabs/favorite.dart';
import 'package:fulifuli_app/pages/tabs/home.dart';
import 'package:fulifuli_app/pages/tabs/mine.dart';
import 'package:fulifuli_app/pages/tabs/submit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  static String routeName = '/home';

  @override
  State<StatefulWidget> createState() {
    return _IndexPageState();
  }
}

class _IndexPageState extends State<IndexPage> {
  int _currentIndex = 0;
  final List<Widget> _pages = const [
    HomePage(),
    ActivityPage(),
    SubmitPage(),
    FavoritePage(),
    MinePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Theme.of(context).unselectedWidgetColor,
        selectedItemColor: Theme.of(context).indicatorColor,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: AppLocalizations.of(context)!.index_tabs_home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.dynamic_feed),
            label: AppLocalizations.of(context)!.index_tabs_dynamic,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.add_circle),
            label: AppLocalizations.of(context)!.index_tabs_submit,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite),
            label: AppLocalizations.of(context)!.index_tabs_favorite,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: AppLocalizations.of(context)!.index_tabs_mine,
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index != _currentIndex) {
            setState(() {
              _currentIndex = index;
            });
          }
        },
      ),
    ));
  }
}
