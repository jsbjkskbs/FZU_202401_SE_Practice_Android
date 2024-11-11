import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fulifuli_app/global.dart';
import 'package:fulifuli_app/widgets/space_page/profile.dart';
import 'package:fulifuli_app/widgets/space_page/space_tabs_container.dart';

class SpacePage extends StatefulWidget {
  const SpacePage({super.key});

  static String routeName = '/space';

  @override
  State<StatefulWidget> createState() {
    return _SpacePageState();
  }
}

class _SpacePageState extends State<SpacePage> {
  late String userId = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    Global.cachedSpaceVideoList.remove(userId);
    Global.cachedSpaceDynamicList.remove(userId);
  }

  @override
  Widget build(BuildContext context) {
    dynamic args = ModalRoute.of(context)!.settings.arguments;
    if (args != null && args["user_id"] != null) {
      userId = args['user_id'];
    }
    if (userId.isEmpty) {
      Navigator.of(context).pop();
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(userId),
          centerTitle: true,
        ),
        body: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: Profile(),
            ),
            SliverFillRemaining(
              child: SpaceTabsContainer(
                uniqueKey: userId,
                tabs: [
                  AppLocalizations.of(context)!.space_video,
                  AppLocalizations.of(context)!.space_dynamic,
                ],
              ),
            ),
          ],
        ));
  }
}
