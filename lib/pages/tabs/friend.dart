import 'package:flutter/material.dart';
import 'package:fulifuli_app/widgets/index_page/friend/friend_list_view.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../generated/l10n.dart';
import '../../widgets/icons/def.dart';

class FriendPage extends StatelessWidget {
  const FriendPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(S.of(context).friend_title, style: Theme.of(context).textTheme.headlineSmall),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(TDSlidePopupRoute(
                    modalBarrierColor: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(0.5),
                    slideTransitionFrom: SlideTransitionFrom.bottom,
                    builder: (BuildContext context) {
                      return Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 3,
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              S.of(context).friend_about_description,
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                color: Theme.of(context).textTheme.headlineSmall!.color,
                                fontSize: Theme.of(context).textTheme.headlineSmall!.fontSize,
                              ),
                            ),
                          ));
                    }));
              },
              icon: Icon(
                DisplayIcons.about,
                size: Theme.of(context).textTheme.headlineSmall!.fontSize! * 1.2,
                color: Theme.of(context).textTheme.headlineSmall!.color,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: const FriendListView(),
    );
  }
}
