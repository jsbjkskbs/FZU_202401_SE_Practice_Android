import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';

import '../../dynamic_card.dart';

class DynamicListView extends StatefulWidget {
  const DynamicListView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _DynamicListViewState();
  }
}

class _DynamicListViewState extends State<DynamicListView> {
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
            separatorBuilder: (_, index) => index != 0 ? const SizedBox(height: 16) : const SizedBox(height: 0),
            itemBuilder: (context, index) {
              if (index == 0) {
                return const SizedBox(
                  height: 16,
                );
              }
              return const DynamicCard();
            },
            itemCount: _count));
  }
}
