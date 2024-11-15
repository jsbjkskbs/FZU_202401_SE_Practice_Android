import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

import 'comment_card.dart';

class CommentListView extends StatefulWidget {
  const CommentListView({super.key, this.commentHead});

  final Widget? commentHead;

  @override
  State<StatefulWidget> createState() {
    return _CommentListViewState();
  }
}

class _CommentListViewState extends State<CommentListView> {
  int _count = 3;

  final EasyRefreshController _controller = EasyRefreshController(
    controlFinishLoad: true,
    controlFinishRefresh: true,
  );

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
        header: const MaterialHeader(),
        footer: const MaterialFooter(),
        controller: _controller,
        onRefresh: () async {
          await Future<void>.delayed(const Duration(seconds: 1));
          setState(() {
            _count++;
          });
          _controller.finishRefresh();
        },
        onLoad: () async {
          await Future<void>.delayed(const Duration(seconds: 1));
          setState(() {
            _count++;
          });
          _controller.finishLoad();
        },
        child: ListView.separated(
            separatorBuilder: (_, index) => index >= 2
                ? Divider(
                    color: Theme.of(context).unselectedWidgetColor,
                    thickness: 0.2,
                  )
                : const SizedBox(),
            itemBuilder: (context, index) {
              if (index == 0) {
                return const SizedBox();
              } else if (index == 1) {
                return widget.commentHead != null
                    ? Column(children: [
                        widget.commentHead!,
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Theme.of(context).dialogBackgroundColor,
                          ),
                        )
                      ])
                    : const SizedBox();
              }
              return const CommentCard();
            },
            itemCount: _count + 1));
  }
}
