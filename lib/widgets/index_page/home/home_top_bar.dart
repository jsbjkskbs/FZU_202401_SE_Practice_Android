import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fulifuli_app/global.dart';
import 'package:fulifuli_app/utils/toastification.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class HomeTopBar extends StatefulWidget {
  const HomeTopBar({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeTopBarState();
  }
}

class _HomeTopBarState extends State<HomeTopBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: SizedBox(
          height: 40,
          child: SizedBox(
            height: 40,
            width: double.infinity,
            child: Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).shadowColor.withOpacity(0.3),
                        offset: const Offset(0, 1),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: TDAvatar(
                    size: TDAvatarSize.small,
                    defaultUrl: "assets/images/default_avatar.gif",
                    onTap: () {
                      if (Global.isLogin()) {
                        Navigator.of(context).pushNamed('/space',
                            arguments: {'user_id': "用户ID七个字"});
                      } else {
                        ToastificationUtils.showSimpleToastification(context,
                            AppLocalizations.of(context)!.home_login_hint);
                        Navigator.of(context).pushNamed('/login');
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SearchBar(
                    hintText: AppLocalizations.of(context)!.home_top_bar_search,
                    leading: Icon(
                      Icons.search,
                      color: Theme.of(context).unselectedWidgetColor,
                    ),
                    shadowColor: WidgetStatePropertyAll(
                        Theme.of(context).shadowColor.withOpacity(0.4)),
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 80,
                  child: AnimatedToggleSwitch<int>.rolling(
                    current: Global.themeMode,
                    values: const [0, 1],
                    onChanged: (index) => setState(() {
                      Global.themeMode = index;
                      switch (Global.themeMode) {
                        case 0:
                          AdaptiveTheme.of(context).setLight();
                          break;
                        case 1:
                          AdaptiveTheme.of(context).setDark();
                          break;
                      }
                      Storage.storeThemeMode(Global.themeMode);
                      ToastificationUtils.showSimpleToastification(
                          context,
                          AppLocalizations.of(context)!
                              .home_theme_switch_toast);
                    }),
                    iconList: [
                      Icon(
                        Icons.sunny,
                        color: Theme.of(context).unselectedWidgetColor,
                      ),
                      Icon(
                        Icons.nightlight,
                        color: Theme.of(context).unselectedWidgetColor,
                      ),
                    ],
                    borderWidth: 2,
                    style: ToggleStyle(
                      indicatorBorder: Border.all(
                        color: Colors.transparent,
                      ),
                      indicatorColor: Theme.of(context).secondaryHeaderColor,
                      borderColor: Theme.of(context).secondaryHeaderColor,
                      backgroundColor: Theme.of(context).cardColor,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).shadowColor.withOpacity(0.3),
                          offset: const Offset(0, 1),
                          blurRadius: 5,
                          spreadRadius: 0.5,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ));
  }
}
