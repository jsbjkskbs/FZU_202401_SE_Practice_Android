import 'package:flutter/cupertino.dart';

class PersistentHeaderBuilder extends SliverPersistentHeaderDelegate {
  final double max;
  final double min;
  final Widget Function(BuildContext context, double offset) builder;

  PersistentHeaderBuilder({this.max = 400, this.min = 0, required this.builder}) : assert(max >= min);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return builder(context, shrinkOffset);
  }

  @override
  double get maxExtent => max;

  @override
  double get minExtent => min;

  @override
  bool shouldRebuild(covariant PersistentHeaderBuilder oldDelegate) =>
      max != oldDelegate.max || min != oldDelegate.min || builder != oldDelegate.builder;
}
