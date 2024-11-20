import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fulifuli_app/pages/dynamic_post.dart';
import 'package:fulifuli_app/widgets/icons/def.dart';
import 'package:fulifuli_app/widgets/index_page/dynamic/dynamic_list_view.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          titleSpacing: 0,
          leading: Container(),
          centerTitle: true,
          title: Text(AppLocalizations.of(context)!.dynamic_title, style: Theme.of(context).textTheme.headlineSmall)),
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [Expanded(child: DynamicListView())],
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, DynamicPostPage.routeName);
        },
        style: ElevatedButton.styleFrom(
          elevation: 4,
          iconColor: Theme.of(context).textTheme.headlineSmall!.color,
          padding: const EdgeInsets.all(16),
          shape: const CircleBorder(),
        ),
        child: Icon(DisplayIcons.edit, size: Theme.of(context).textTheme.headlineSmall!.fontSize, color: Theme.of(context).primaryColor),
      ),
    );
  }
}
