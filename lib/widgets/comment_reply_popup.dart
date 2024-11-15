import 'package:flutter/material.dart';
import 'package:fulifuli_app/widgets/icons/def.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class CommentReplyPopupContainer extends StatefulWidget {
  const CommentReplyPopupContainer({super.key, this.maxLength = 256, this.minLines = 1, this.hintText = '可以来点评论吗~'});

  final int maxLength;
  final int minLines;
  final String hintText;

  @override
  State<StatefulWidget> createState() {
    return _CommentReplyPopupContainerState();
  }
}

class _CommentReplyPopupContainerState extends State<CommentReplyPopupContainer> {
  bool expanded = false;
  late int minLines;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    minLines = widget.minLines;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: IntrinsicHeight(
            child: SizedBox(
          height: expanded ? MediaQuery.of(context).size.height / 2 : null,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 8, right: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(8),
                        child: Material(
                          borderRadius: const BorderRadius.all(Radius.circular(16)),
                          child: TDTextarea(
                            width: MediaQuery.of(context).size.width * 0.8,
                            maxLength: widget.maxLength,
                            minLines: minLines,
                            controller: _controller,
                            size: TDInputSize.small,
                            hintText: widget.hintText,
                            hintTextStyle: TextStyle(
                              color: Theme.of(context).unselectedWidgetColor,
                              fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                            ),
                            textStyle: TextStyle(
                              color: Theme.of(context).textTheme.bodyMedium!.color,
                              fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                            ),
                          ),
                        )),
                    Expanded(
                        child: !expanded
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    minLines = 4;
                                    expanded = true;
                                  });
                                },
                                child: Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Icon(Icons.expand, color: Theme.of(context).unselectedWidgetColor)))
                            : GestureDetector(
                                onTap: () {
                                  setState(() {
                                    minLines = 1;
                                    expanded = false;
                                  });
                                },
                                child: Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Icon(Icons.unfold_less, color: Theme.of(context).primaryColor)))),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            onPressed: () {
                              _controller.clear();
                            },
                            child: Row(
                              children: [
                                Icon(DisplayIcons.clear, color: Theme.of(context).scaffoldBackgroundColor),
                                const SizedBox(width: 4),
                                Text('清空', style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor)),
                              ],
                            ))),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).cardColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          onPressed: () {},
                          child: Row(
                            children: [
                              Icon(DisplayIcons.post, color: Theme.of(context).primaryColor),
                              const SizedBox(width: 4),
                              Text('发送', style: TextStyle(color: Theme.of(context).primaryColor)),
                            ],
                          )),
                    ),
                  ],
                ),
              )
            ],
          ),
        )),
      ),
    );
  }
}
