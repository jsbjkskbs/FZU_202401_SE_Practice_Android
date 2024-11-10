import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fulifuli_app/components/settings_page/settings_list_item.dart';
import 'package:fulifuli_app/global.dart';
import 'package:fulifuli_app/main.dart';
import 'package:fulifuli_app/model/settings.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

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
      ),
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      body: GroupedListView<SettingsItem, String>(
        elements: _SettingsList.getItems(context),
        groupBy: (SettingsItem element) {
          return element.kind;
        },
        groupSeparatorBuilder: (String groupByValue) =>
            const SizedBox(height: 16),
        itemBuilder: (context, SettingsItem element) {
          return SettingsListItem(element);
        },
        itemComparator: (item1, item2) =>
            item1.labelIndex.compareTo(item2.labelIndex),
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
          label: AppLocalizations.of(context)!.settings_change_language,
          kind: 'additional',
          labelIndex: 0,
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
                SelectedListItem(
                    name: '简体中文',
                    isSelected: Global.languageCode == 'zh',
                    value: 'zh'),
                SelectedListItem(
                    name: 'English',
                    isSelected: Global.languageCode == 'en',
                    value: 'en'),
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
          label: AppLocalizations.of(context)!.settings_about_us,
          kind: 'additional',
          labelIndex: 1,
          kindIndex: 0,
          onTap: (BuildContext context) {
            Navigator.of(context).push(TDSlidePopupRoute(
                modalBarrierColor: Global.themeMode == 0
                    ? Colors.black.withOpacity(0.5)
                    : Colors.white.withOpacity(0.3),
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
                            image: AssetImage(
                                'assets/images/cute/konata_dancing.webp'),
                            height: 120,
                          ),
                          const SizedBox(height: 32),
                          Text(
                            '什么也没有哦~',
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
    ];
  }
}
