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
import 'package:fulifuli_app/pages/followers.dart';
import 'package:fulifuli_app/pages/following.dart';
import 'package:fulifuli_app/pages/index.dart';
import 'package:fulifuli_app/pages/liked_videos.dart';
import 'package:fulifuli_app/pages/loading.dart';
import 'package:fulifuli_app/pages/login.dart';
import 'package:fulifuli_app/pages/mfa_verification.dart';
import 'package:fulifuli_app/pages/search.dart';
import 'package:fulifuli_app/pages/settings.dart';
import 'package:fulifuli_app/pages/space.dart';
import 'package:fulifuli_app/pages/submission_manage.dart';
import 'package:fulifuli_app/pages/video.dart';
import 'package:fulifuli_app/utils/scheme_reflect.dart';
import 'package:fulifuli_app/utils/toastification.dart';

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
  var valid = Global.refreshTokenRefresh();
  if (await valid) {
    var valid = await Global.accessTokenRefresh();
    if (!valid) {
      Global.self = User();
      Global.appPersistentData.user = Global.self;
      Global.updateDioToken(accessToken: null, refreshToken: null);
      Storage.storePersistentData(Global.appPersistentData);
    } else {
      debugPrint("Global.main.startAsyncTask, with user: ${Global.self}");
      Global.startAsyncTask();
    }
  } else {
    if (Global.self.accessToken != null && Global.self.accessToken!.isNotEmpty) {
      Global.cachedMap["delayed-notification/not-valid"] = true;
      Global.self = User();
      Global.appPersistentData.user = Global.self;
      Global.updateDioToken(accessToken: null, refreshToken: null);
      Storage.storePersistentData(Global.appPersistentData);
    }
  }
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
    if (Global.cachedMap["delayed-notification/not-valid"] == true) {
      Global.cachedMap.remove("delayed-notification/not-valid");
      ToastificationUtils.showSimpleToastification(context, '登录状态已失效，请重新登录');
    }
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
                FollowerPage.routeName: (context) => const FollowerPage(),
                FollowingPage.routeName: (context) => const FollowingPage(),
                LikedVideosPage.routeName: (context) => const LikedVideosPage(),
              },
            ));
  }
}
