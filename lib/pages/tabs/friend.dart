import 'package:flutter/material.dart';
import 'package:fulifuli_app/widgets/index_page/friend/friend_list_view.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../widgets/icons/def.dart';

class FriendPage extends StatelessWidget {
  const FriendPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Friend'),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(TDSlidePopupRoute(
                    modalBarrierColor: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .color!
                        .withOpacity(0.5),
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
                              '朋友就是互相关注的人',
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                color: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .color,
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .fontSize,
                              ),
                            ),
                          ));
                    }));
              },
              icon: const Icon(DisplayIcons.about),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: const FriendListView(),
    );
  }
}
