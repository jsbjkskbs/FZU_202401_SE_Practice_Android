import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fulifuli_app/global.dart';
import 'package:fulifuli_app/utils/toastification.dart';
import 'package:fulifuli_app/widgets/icons/def.dart';
import 'package:like_button/like_button.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class HomeTopBar extends StatefulWidget {
  const HomeTopBar({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeTopBarState();
  }
}

class _HomeTopBarState extends State<HomeTopBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: SizedBox(
          height: 40,
          child: SizedBox(
            height: 40,
            width: double.infinity,
            child: Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).shadowColor.withOpacity(0.3),
                        offset: const Offset(0, 1),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: TDAvatar(
                    size: TDAvatarSize.small,
                    defaultUrl: "assets/images/default_avatar.avif",
                    avatarUrl: Global.self.avatarUrl == "" ? null : Global.self.avatarUrl,
                    onTap: () {
                      if (Global.isLogin()) {
                        Navigator.of(context).pushNamed('/space', arguments: {'user_id': Global.self.id});
                      } else {
                        ToastificationUtils.showSimpleToastification(context, AppLocalizations.of(context)!.home_login_hint);
                        Navigator.of(context).pushNamed('/login');
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SearchBar(
                    hintText: AppLocalizations.of(context)!.home_top_bar_search,
                    leading: Icon(
                      Icons.search,
                      color: Theme.of(context).unselectedWidgetColor,
                    ),
                    shadowColor: WidgetStatePropertyAll(Theme.of(context).shadowColor.withOpacity(0.4)),
                    backgroundColor: WidgetStatePropertyAll(Theme.of(context).scaffoldBackgroundColor),
                    side: WidgetStateProperty.all(BorderSide(width: 1.5, color: Theme.of(context).textTheme.labelLarge!.color!)),
                    onTap: () {
                      Navigator.of(context).pushNamed('/search');
                    },
                    keyboardType: TextInputType.none,
                  ),
                ),
                const SizedBox(width: 16),
                LikeButton(
                  circleColor: CircleColor(start: Theme.of(context).primaryColor, end: Theme.of(context).primaryColor),
                  bubblesColor: BubblesColor(
                    dotPrimaryColor: Theme.of(context).primaryColor,
                    dotSecondaryColor: Theme.of(context).secondaryHeaderColor,
                  ),
                  onTap: (b) {
                    if (!b) {
                      ToastificationUtils.showFlatToastification(
                        context,
                        '哇袄!',
                        '???????!',
                        icon: Icon(
                          DisplayIcons.angry_text_deco,
                          color: Theme.of(context).primaryColor,
                        ),
                        duration: const Duration(milliseconds: 3000),
                      );
                    }
                    return Future.value(!b);
                  },
                  likeBuilder: (bool isLiked) {
                    return Icon(
                      DisplayIcons.cat,
                      size: 32,
                      color: Theme.of(context).primaryColor,
                    );
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ));
  }
}
