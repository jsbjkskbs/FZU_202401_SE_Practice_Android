import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fulifuli_app/widgets/index_page/home/home_content.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
        padding: EdgeInsets.only(left: 2, right: 2),
        child: Column(
          children: [
            Expanded(
              child: HomeContent(),
            ),
          ],
        ));
  }
}
