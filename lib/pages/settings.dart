import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fulifuli_app/global.dart';
import 'package:fulifuli_app/main.dart';
import 'package:fulifuli_app/model/settings.dart';
import 'package:fulifuli_app/pages/index.dart';
import 'package:fulifuli_app/utils/scheme_reflect.dart';
import 'package:fulifuli_app/widgets/icons/def.dart';
import 'package:fulifuli_app/widgets/settings_page/settings_light_dark_switch.dart';
import 'package:fulifuli_app/widgets/settings_page/settings_list_item.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../model/user.dart';
import '../utils/toastification.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static String routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.settings_title,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).primaryColor),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      body: GroupedListView<SettingsItem, String>(
        elements: _SettingsList.getItems(context),
        groupBy: (SettingsItem element) {
          return element.kind;
        },
        groupSeparatorBuilder: (String groupByValue) => const SizedBox(height: 16),
        itemBuilder: (context, SettingsItem element) {
          return SettingsListItem(
            element,
            rightWidget: element.rightWidget,
          );
        },
        itemComparator: (item1, item2) => item1.labelIndex.compareTo(item2.labelIndex),
        useStickyGroupSeparators: false,
        floatingHeader: true,
        order: GroupedListOrder.ASC,
      ),
    );
  }
}

class _SettingsList {
  static List<SettingsItem> getItems(BuildContext context) {
    return <SettingsItem>[
      SettingsItem(
          icon: const Icon(
            Icons.lightbulb_outline,
            size: 24,
          ),
          label: AppLocalizations.of(context)!.settings_light_dark_switch,
          kind: 'additional',
          labelIndex: 0,
          kindIndex: 0,
          onTap: (context) {
            Global.appPersistentData.themeMode = Global.appPersistentData.themeMode == 0 ? 1 : 0;
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
          },
          rightWidget: const SettingsLightDarkSwitch()),
      SettingsItem(
        icon: const Icon(
          DisplayIcons.palette,
          size: 24,
        ),
        label: AppLocalizations.of(context)!.settings_change_theme,
        kind: 'additional',
        labelIndex: 1,
        kindIndex: 0,
        onTap: (BuildContext context) {
          DropDownState(DropDown(
            bottomSheetTitle: Text(
              AppLocalizations.of(context)!.settings_select_theme,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width / 20,
              ),
            ),
            data: [
              SelectedListItem(
                name: AppLocalizations.of(context)!.flex_scheme_default,
                isSelected: Global.appPersistentData.themeSelection == FlexScheme.sakura.name,
                value: FlexScheme.sakura.name,
              ),
              for (var value in FlexScheme.values)
                if (value.name != 'custom') ...[
                  SelectedListItem(
                      name: SchemeReflect.getFlexSchemeLocalizedName(value.name, context),
                      isSelected: Global.appPersistentData.themeSelection == value.name,
                      value: value.name),
                ]
            ],
            onSelected: (items) {
              var val = items.first.value ?? SchemeReflect.getFlexScheme(FlexScheme.sakura.name, defaultScheme: FlexScheme.sakura).name;
              Global.appPersistentData.themeSelection = val;
              Storage.storePersistentData(Global.appPersistentData);
              MyAppState.appScheme.setSchemeWithContext(SchemeReflect.getFlexScheme(val, defaultScheme: FlexScheme.sakura), context);
            },
            searchHintText: AppLocalizations.of(context)!.home_top_bar_search,
          )).showModal(context);
        },
      ),
      SettingsItem(
          icon: const Icon(
            DisplayIcons.language_change,
            size: 24,
          ),
          label: AppLocalizations.of(context)!.settings_change_language,
          kind: 'additional',
          labelIndex: 2,
          kindIndex: 0,
          onTap: (BuildContext context) {
            DropDownState(DropDown(
              bottomSheetTitle: Text(
                AppLocalizations.of(context)!.settings_select_language,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width / 20,
                ),
              ),
              data: [
                SelectedListItem(name: '简体中文', isSelected: Global.appPersistentData.languageCode == 'zh', value: 'zh'),
                SelectedListItem(name: 'English', isSelected: Global.appPersistentData.languageCode == 'en', value: 'en'),
              ],
              onSelected: (items) {
                var val = items.first.value ?? 'en';
                MyAppState.appLocale.changeLocale(Locale(val));
              },
              isSearchVisible: false,
              enableMultipleSelection: false,
            )).showModal(context);
          }),
      SettingsItem(
          icon: const Icon(
            DisplayIcons.about,
            size: 24,
          ),
          label: AppLocalizations.of(context)!.settings_about_us,
          kind: 'additional',
          labelIndex: 3,
          kindIndex: 0,
          onTap: (BuildContext context) {
            Navigator.of(context).push(TDSlidePopupRoute(
                modalBarrierColor: Global.appPersistentData.themeMode == 0 ? Colors.black.withOpacity(0.5) : Colors.white.withOpacity(0.3),
                slideTransitionFrom: SlideTransitionFrom.bottom,
                builder: (context) {
                  return Container(
                      height: 256,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 32),
                          const Image(
                            image: AssetImage('assets/images/cute/konata_dancing.webp'),
                            height: 120,
                          ),
                          const SizedBox(height: 32),
                          Text(
                            AppLocalizations.of(context)!.settings_about_us_noting,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: MediaQuery.of(context).size.width / 20,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ));
                }));
          }),
      if (Global.self.isValidUser())
        SettingsItem(
          label: AppLocalizations.of(context)!.settings_logout,
          kind: 'security',
          labelIndex: 0,
          kindIndex: 1,
          onTap: (BuildContext context) {
            Global.self = User();
            Storage.storePersistentData(Global.appPersistentData.copyWith(user: Global.self));
            Navigator.of(context).pushNamedAndRemoveUntil(IndexPage.routeName, (route) => false);
            ToastificationUtils.showSimpleToastification(context, AppLocalizations.of(context)!.settings_logout_success);
          },
          icon: const Icon(
            Icons.exit_to_app,
            size: 24,
          ),
        )
    ];
  }
}
