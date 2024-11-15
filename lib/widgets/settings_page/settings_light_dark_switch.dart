import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../global.dart';
import '../../utils/toastification.dart';

class SettingsLightDarkSwitch extends StatefulWidget {
  const SettingsLightDarkSwitch({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SettingsLightDarkSwitchState();
  }
}

class _SettingsLightDarkSwitchState extends State<SettingsLightDarkSwitch> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      width: 80,
      child: AnimatedToggleSwitch<int>.rolling(
        current: Global.appPersistentData.themeMode,
        values: const [0, 1],
        onChanged: (index) => setState(() {
          Global.appPersistentData.themeMode = index;
          switch (Global.appPersistentData.themeMode) {
            case 0:
              AdaptiveTheme.of(context).setLight();
              break;
            case 1:
              AdaptiveTheme.of(context).setDark();
              break;
          }
          Storage.storePersistentData(Global.appPersistentData);
          ToastificationUtils.showSimpleToastification(context, AppLocalizations.of(context)!.home_theme_switch_toast);
        }),
        iconList: [
          Icon(
            Icons.sunny,
            color: Theme.of(context).unselectedWidgetColor,
            size: 24,
          ),
          Icon(
            Icons.nightlight,
            color: Theme.of(context).unselectedWidgetColor,
            size: 24,
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
    );
  }
}
