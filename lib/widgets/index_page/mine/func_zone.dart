import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';

class FuncZone extends StatefulWidget {
  const FuncZone({super.key});

  @override
  State<StatefulWidget> createState() {
    return _FuncZoneState();
  }
}

class FuncItem {
  final String content;
  final Icon icon;
  final String routerTo;

  const FuncItem(this.content, this.icon, this.routerTo);
}

class _FuncZoneState extends State<FuncZone> {
  @override
  Widget build(BuildContext context) {
    List<FuncItem> funcItems = [
      FuncItem(
          S.current.mine_func_zone_liked_videos,
          Icon(
            Icons.favorite,
            color: Theme.of(context).primaryColor,
          ),
          "/liked_videos"),
      FuncItem(
          S.current.mine_func_zone_submission_management,
          Icon(
            Icons.add,
            color: Theme.of(context).primaryColor,
          ),
          "/submission/manage"),
      FuncItem(
          S.current.mine_func_zone_settings,
          Icon(
            Icons.settings,
            color: Theme.of(context).primaryColor,
          ),
          "/settings"),
    ];

    return Padding(
        padding: const EdgeInsets.only(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: funcItems.map((item) {
            return ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, item.routerTo);
              },
              style: ButtonStyle(
                shadowColor: WidgetStateProperty.all(Colors.transparent),
                backgroundColor: WidgetStateProperty.all(Colors.transparent),
                shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(0))),
                padding: WidgetStateProperty.all(const EdgeInsets.all(8)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                child: Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        item.icon,
                        const SizedBox(width: 4),
                        Text(
                          item.content,
                          style: TextStyle(color: Theme.of(context).primaryColor),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Theme.of(context).primaryColor,
                          size: 16,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          }).toList(),
        ));
  }
}
