import 'package:flutter/cupertino.dart';

class VideoIntroductionView extends StatefulWidget {
  const VideoIntroductionView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _VideoIntroductionViewState();
  }
}

class _VideoIntroductionViewState extends State<VideoIntroductionView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('简介'),
        const Text('这是一个视频简介'),
      ],
    );
  }
}
