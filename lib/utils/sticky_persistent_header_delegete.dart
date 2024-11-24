import 'package:flutter/cupertino.dart';

class StickyPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double fixedHeight;

  StickyPersistentHeaderDelegate({required this.child, required this.fixedHeight});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => fixedHeight;

  @override
  double get minExtent => fixedHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
