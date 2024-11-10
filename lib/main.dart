import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fulifuli_app/global.dart';
import 'package:fulifuli_app/model/locale.dart';
import 'package:fulifuli_app/pages/index.dart';
import 'package:fulifuli_app/pages/loading.dart';
import 'package:fulifuli_app/pages/login.dart';
import 'package:fulifuli_app/pages/mfa_verification.dart';
import 'package:fulifuli_app/pages/settings.dart';
import 'package:fulifuli_app/test.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  Global.themeMode = await Storage.getThemeMode() ?? 0;
  Global.languageCode = await Storage.getLanguageCode() ?? "zh";
  _fetchVideoList();
  runApp(const MyApp());
}

Future<void> _fetchVideoList() async {
  // TODO: fetch video list
  Global.cachedVideoList.add(videoListForTest);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  static AppLocale appLocale = AppLocale(Locale(Global.languageCode), (_) {});

  @override
  void initState() {
    super.initState();
    appLocale.changeLocale = (Locale locale) {
      setState(() {
        appLocale.locale = locale;
        Global.languageCode = locale.languageCode;
        Storage.storeLanguageCode(Global.languageCode);
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
        initial: Global.themeMode == 0
            ? AdaptiveThemeMode.light
            : AdaptiveThemeMode.dark,
        light: FlexThemeData.light(
          scheme: FlexScheme.sakura,
          subThemesData: const FlexSubThemesData(
            interactionEffects: true,
            tintedDisabledControls: true,
            useM2StyleDividerInM3: true,
            inputDecoratorIsFilled: true,
            inputDecoratorBorderType: FlexInputBorderType.outline,
            alignedDropdown: true,
            navigationRailUseIndicator: true,
            navigationRailLabelType: NavigationRailLabelType.all,
          ),
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
          cupertinoOverrideTheme:
              const CupertinoThemeData(applyThemeToAll: true),
        ),
        dark: FlexThemeData.dark(
          scheme: FlexScheme.sakura,
          subThemesData: const FlexSubThemesData(
            interactionEffects: true,
            tintedDisabledControls: true,
            blendOnColors: true,
            useM2StyleDividerInM3: true,
            inputDecoratorIsFilled: true,
            inputDecoratorBorderType: FlexInputBorderType.outline,
            alignedDropdown: true,
            navigationRailUseIndicator: true,
            navigationRailLabelType: NavigationRailLabelType.all,
          ),
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
          cupertinoOverrideTheme:
              const CupertinoThemeData(applyThemeToAll: true),
        ),
        builder: (theme, darkTheme) => MaterialApp(
              locale: appLocale.locale,
              localeResolutionCallback: (locale, supportedLocales) {
                var result = supportedLocales.where(
                    (element) => element.languageCode == locale?.languageCode);
                if (result.isNotEmpty) {
                  return locale;
                }
                return const Locale('zh');
              },
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              theme: theme.copyWith(
                  pageTransitionsTheme: const PageTransitionsTheme(
                      builders: <TargetPlatform, PageTransitionsBuilder>{
                    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
                    TargetPlatform.android: ZoomPageTransitionsBuilder(),
                  })),
              darkTheme: darkTheme,
              // initialRoute: IndexPage.routeName,
              initialRoute: LoadingPage.routeName,
              routes: {
                LoadingPage.routeName: (context) => const LoadingPage(),
                LoginScreen.routeName: (context) => const LoginScreen(),
                IndexPage.routeName: (context) => const IndexPage(),
                MFAVerification.routeName: (context) => const MFAVerification(),
                SettingsPage.routeName: (context) => const SettingsPage(),
              },
            ));
  }
}
