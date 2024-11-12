import 'package:flutter/material.dart';

import '../../widgets/index_page/mine/func_zone.dart';
import '../../widgets/index_page/mine/profile.dart';
import '../../widgets/index_page/mine/user_info.dart';

class MinePage extends StatelessWidget {
  const MinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: MyPageContent(),
    );
  }
}

class MyPageContent extends StatelessWidget {
  const MyPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ListView.separated(
        itemCount: 3,
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(
            height: 16.0,
            color: Colors.transparent,
          );
        },
        itemBuilder: (BuildContext context, int index) {
          return [
            const ProfileView(),
            const UserInfoView(),
            const FuncZone(),
          ][index];
        },
      ),
    );
  }
}
