import 'package:flutter/cupertino.dart';

class DynamicCard extends StatefulWidget {
  const DynamicCard({super.key});

  @override
  State<DynamicCard> createState() {
    return _DynamicCardState();
  }
}

class _DynamicCardState extends State<DynamicCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
