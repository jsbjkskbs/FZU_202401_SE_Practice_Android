import 'package:flutter/material.dart';

class ExpandShrinkText extends StatefulWidget {
  final String text;
  final int maxShrinkLine;
  final bool isExpanded;
  final TextStyle style;

  const ExpandShrinkText(this.text,
      {this.maxShrinkLine = 1, this.isExpanded = false, this.style = const TextStyle(fontSize: 16.0, color: Colors.black), super.key});

  @override
  State<ExpandShrinkText> createState() => _RichTextState();
}

class _RichTextState extends State<ExpandShrinkText> {
  @override
  Widget build(BuildContext context) {
    if (isExpansion(widget.text)) {
      if (widget.isExpanded) {
        return Column(
          children: <Widget>[
            Text(
              widget.text,
              textAlign: TextAlign.left,
              style: widget.style,
            ),
          ],
        );
      } else {
        if (widget.maxShrinkLine <= 0) {
          return Container();
        }
        return Column(
          children: <Widget>[
            Text(
              widget.text,
              maxLines: widget.maxShrinkLine,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: widget.style,
            ),
          ],
        );
      }
    } else {
      return Text(
        widget.text,
        maxLines: widget.maxShrinkLine,
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
        style: widget.style,
      );
    }
  }

  bool isExpansion(String text) {
    if (widget.maxShrinkLine <= 0) {
      return true;
    }
    TextPainter textPainter =
        TextPainter(maxLines: widget.maxShrinkLine, text: TextSpan(text: text, style: widget.style), textDirection: TextDirection.ltr)
          ..layout(maxWidth: 100, minWidth: 50);
    if (textPainter.didExceedMaxLines) {
      return true;
    } else {
      return false;
    }
  }
}
