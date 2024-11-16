import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

import 'comment_card.dart';

class CommentListView extends StatefulWidget {
  const CommentListView({super.key, this.commentHead, this.controller});

  final ScrollController? controller;
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
    return EasyRefresh.builder(
      header: const MaterialHeader(),
      footer: BezierFooter(
        foregroundColor: Theme.of(context).scaffoldBackgroundColor,
        backgroundColor: Theme.of(context).primaryColor,
        spinWidget: SizedBox(
          width: 25,
          height: 25,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).scaffoldBackgroundColor),
            strokeWidth: 4,
          ),
        ),
        springRebound: true,
      ),
      controller: _controller,
      onRefresh: () async {
        await Future<void>.delayed(const Duration(seconds: 1));
        setState(() {
          _count++;
        });
        _controller.finishRefresh();
      },
      onLoad: () async {
        debugPrint('onLoad');
        await Future<void>.delayed(const Duration(seconds: 1));
        setState(() {
          _count++;
        });
        _controller.finishLoad();
      },
      childBuilder: (BuildContext context, ScrollPhysics physics) {
        return ListView.separated(
            controller: widget.controller,
            physics: physics,
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
            itemCount: _count + 1);
      },
    );
  }
}
