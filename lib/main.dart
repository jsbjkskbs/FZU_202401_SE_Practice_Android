import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fulifuli_app/global.dart';
import 'package:fulifuli_app/model/locale.dart';
import 'package:fulifuli_app/model/scheme.dart';
import 'package:fulifuli_app/pages/dynamic_post.dart';
import 'package:fulifuli_app/pages/index.dart';
import 'package:fulifuli_app/pages/loading.dart';
import 'package:fulifuli_app/pages/login.dart';
import 'package:fulifuli_app/pages/mfa_verification.dart';
import 'package:fulifuli_app/pages/search.dart';
import 'package:fulifuli_app/pages/settings.dart';
import 'package:fulifuli_app/pages/space.dart';
import 'package:fulifuli_app/pages/submission_manage.dart';
import 'package:fulifuli_app/pages/video.dart';
import 'package:fulifuli_app/utils/scheme_reflect.dart';

import 'model/user.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  Global.appPersistentData = await Storage.getPersistentData();
  Global.self = Global.appPersistentData.user ?? User();
  Global.updateDioToken(accessToken: Global.self.accessToken, refreshToken: Global.self.refreshToken);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  static AppLocale appLocale = AppLocale(Locale(Global.appPersistentData.languageCode), (_) {});
  static AppScheme appScheme = AppScheme();

  @override
  void initState() {
    super.initState();
    appLocale.changeLocale = (Locale locale) {
      setState(() {
        appLocale.locale = locale;
        Global.appPersistentData.languageCode = locale.languageCode;
        Storage.storePersistentData(Global.appPersistentData);
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
        initial: Global.appPersistentData.themeMode == 0 ? AdaptiveThemeMode.light : AdaptiveThemeMode.dark,
        light: FlexThemeData.light(
          scheme: SchemeReflect.getFlexScheme(Global.appPersistentData.themeSelection),
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
          cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
        ),
        dark: FlexThemeData.dark(
          scheme: SchemeReflect.getFlexScheme(Global.appPersistentData.themeSelection),
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
          cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
        ),
        builder: (theme, darkTheme) => MaterialApp(
              locale: appLocale.locale,
              localeResolutionCallback: (locale, supportedLocales) {
                var result = supportedLocales.where((element) => element.languageCode == locale?.languageCode);
                if (result.isNotEmpty) {
                  return locale;
                }
                return const Locale('zh');
              },
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              theme: theme.copyWith(
                  pageTransitionsTheme: const PageTransitionsTheme(builders: <TargetPlatform, PageTransitionsBuilder>{
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                TargetPlatform.android: CupertinoPageTransitionsBuilder(),
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
                SpacePage.routeName: (context) => const SpacePage(),
                SearchPage.routeName: (context) => const SearchPage(),
                SubmissionManagePage.routeName: (context) => const SubmissionManagePage(),
                DynamicPostPage.routeName: (context) => const DynamicPostPage(),
                VideoPage.routeName: (context) => const VideoPage(),
              },
            ));
  }
}
