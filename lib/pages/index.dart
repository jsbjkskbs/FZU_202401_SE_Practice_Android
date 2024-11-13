import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fulifuli_app/pages/tabs/activity.dart';
import 'package:fulifuli_app/pages/tabs/favorite.dart';
import 'package:fulifuli_app/pages/tabs/home.dart';
import 'package:fulifuli_app/pages/tabs/mine.dart';
import 'package:fulifuli_app/pages/tabs/submit.dart';
import 'package:fulifuli_app/widgets/icons/def.dart';

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
  late Color _backgroundColor;
  final List<Widget> _pages = const [
    HomePage(),
    ActivityPage(),
    SubmitPage(),
    FavoritePage(),
    MinePage(),
  ];

  void _setBackgroundColor() {
    setState(() {
      if (_currentIndex == 0) {
        _backgroundColor = Theme.of(context).dialogBackgroundColor;
      } else {
        _backgroundColor = Theme.of(context).scaffoldBackgroundColor;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _setBackgroundColor();
    return SafeArea(
        child: Scaffold(
      body: _pages[_currentIndex],
      backgroundColor: _backgroundColor,
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Theme.of(context).unselectedWidgetColor,
        selectedItemColor: Theme.of(context).indicatorColor,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(DisplayIcons.home),
            label: AppLocalizations.of(context)!.index_tabs_home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(DisplayIcons.dynamic),
            label: AppLocalizations.of(context)!.index_tabs_dynamic,
          ),
          BottomNavigationBarItem(
            icon: const Icon(DisplayIcons.submit),
            label: AppLocalizations.of(context)!.index_tabs_submit,
          ),
          BottomNavigationBarItem(
            icon: const Icon(DisplayIcons.friend),
            label: AppLocalizations.of(context)!.index_tabs_message,
          ),
          BottomNavigationBarItem(
            icon: const Icon(DisplayIcons.mine),
            activeIcon: const Icon(DisplayIcons.mine_active),
            label: AppLocalizations.of(context)!.index_tabs_mine,
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index != _currentIndex) {
            setState(() {
              _currentIndex = index;
            });
            _setBackgroundColor();
          }
        },
      ),
    ));
  }
}
