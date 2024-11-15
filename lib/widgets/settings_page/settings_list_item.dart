import 'package:flutter/material.dart';
import 'package:fulifuli_app/model/settings.dart';

class SettingsListItem extends StatelessWidget {
  SettingsListItem(SettingsItem item, {super.key, this.rightWidget})
      : label = item.label,
        onTap = item.onTap,
        icon = item.icon;

  final Icon? icon;
  final String label;
  final Function? onTap;
  final Widget? rightWidget;

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
          backgroundColor: WidgetStateProperty.all(Theme.of(context).scaffoldBackgroundColor),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          ),
          padding: WidgetStateProperty.all(const EdgeInsets.all(8)),
        ),
        child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
            child: SizedBox(
              height: 36,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IntrinsicWidth(
                    child: Row(
                      children: [
                        if (icon != null) icon!,
                        if (icon != null) const SizedBox(width: 8),
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                  rightWidget ??
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Theme.of(context).primaryColor,
                        size: MediaQuery.of(context).size.width / 24,
                      ),
                ],
              ),
            )));
  }
}
