import 'package:flutter/material.dart';
import 'package:fulifuli_app/widgets/icons/def.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: MediaQuery.of(context).size.width / 3),
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('Activity', style: Theme.of(context).textTheme.headlineSmall)],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      overlayColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                      iconColor: Theme.of(context).textTheme.headlineSmall!.color,
                      padding: EdgeInsets.zero,
                    ),
                    child: Icon(DisplayIcons.edit,
                        size: Theme.of(context).textTheme.headlineSmall!.fontSize, color: Theme.of(context).textTheme.headlineSmall!.color),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      body: Center(
        child: Text('Activity'),
      ),
    );
  }
}
