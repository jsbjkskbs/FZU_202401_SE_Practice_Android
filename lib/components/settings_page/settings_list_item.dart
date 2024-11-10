import 'package:flutter/material.dart';
import 'package:fulifuli_app/model/settings.dart';

class SettingsListItem extends StatelessWidget {
  SettingsListItem(SettingsItem item, {super.key})
      : label = item.label,
        onTap = item.onTap;

  final String label;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          if (onTap != null) {
            onTap!(context);
          }
        },
        style: ButtonStyle(
          shadowColor: WidgetStateProperty.all(Colors.transparent),
          backgroundColor: WidgetStateProperty.all(
              Theme.of(context).scaffoldBackgroundColor),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          ),
          padding: WidgetStateProperty.all(const EdgeInsets.all(8)),
        ),
        child: Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(label,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width / 24,
                      color: Theme.of(context).primaryColor,
                    )),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Theme.of(context).primaryColor,
                  size: MediaQuery.of(context).size.width / 24,
                ),
              ],
            )));
  }
}
