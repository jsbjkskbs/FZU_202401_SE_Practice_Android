import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OptionGridView extends StatefulWidget {
  final int itemCount;
  final int rowCount;
  final int columnCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final EdgeInsetsGeometry? padding;
  final IndexedWidgetBuilder itemBuilder;
  final ScrollPhysics? physics;
  final ScrollController? controller;

  OptionGridView({
    super.key,
    required this.itemCount,
    required this.rowCount,
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
    this.padding = const EdgeInsets.all(0),
    required this.itemBuilder,
    this.physics,
    this.controller,
  })  : assert(itemCount >= 0),
        assert(rowCount > 0),
        columnCount = (itemCount / rowCount).ceil(),
        assert(mainAxisSpacing >= 0),
        assert(crossAxisSpacing >= 0);

  @override
  State<StatefulWidget> createState() {
    return _OptionGridViewState();
  }
}

class _OptionGridViewState extends State<OptionGridView> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: double.infinity,
        child: ListView.separated(
          itemCount: widget.columnCount,
          padding: widget.padding,
          physics: widget.physics ?? const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          controller: widget.controller ?? ScrollController(keepScrollOffset: false),
          separatorBuilder: (context, index) => SizedBox(height: widget.mainAxisSpacing),
          itemBuilder: (context, index) => buildRow(context, index),
        ));
  }

  Widget buildRow(BuildContext context, int index) {
    if (index < widget.columnCount - 1) {
      List<Widget> row = [];
      for (int i = 0; i < widget.rowCount; i++) {
        row.add(Expanded(
          flex: 1,
          child: widget.itemBuilder(context, i + index * widget.rowCount),
        ));
        if (widget.crossAxisSpacing > 0.0 && i < widget.rowCount - 1) {
          row.add(SizedBox(width: widget.crossAxisSpacing));
        }
      }
      return Row(crossAxisAlignment: CrossAxisAlignment.start, children: row);
    } else {
      List<Widget> row = [];
      for (int i = 0; i < widget.rowCount; i++) {
        int currentIndex = i + index * widget.rowCount;
        if (currentIndex < widget.itemCount) {
          row.add(Expanded(
            flex: 1,
            child: widget.itemBuilder(context, i + index * widget.rowCount),
          ));
          if (widget.crossAxisSpacing > 0.0 && i < widget.rowCount - 1) {
            row.add(SizedBox(width: widget.crossAxisSpacing));
          }
        } else {
          row.add(const Expanded(flex: 1, child: SizedBox()));
        }
      }
      return Row(crossAxisAlignment: CrossAxisAlignment.start, children: row);
    }
  }
}
