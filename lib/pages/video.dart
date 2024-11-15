import 'package:flutter/material.dart';
import 'package:fulifuli_app/pkg/chewie/chewie.dart';
import 'package:fulifuli_app/widgets/video_page/custom_controls/custom_controls.dart';
import 'package:fulifuli_app/widgets/video_page/video_page_tabs_container.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  static const String routeName = '/video';

  @override
  State<StatefulWidget> createState() {
    return _VideoPageState();
  }
}

class _VideoPageState extends State<VideoPage> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((_) {
      _initializeVideoPlayer(context);
    });
  }

  @override
  void dispose() {
    if (_videoPlayerController != null) {
      _videoPlayerController!.dispose();
    }
    if (_chewieController != null) {
      _chewieController!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint((ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)["vid"]);
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width * 9 / 16,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
              child: Chewie(
                controller: _chewieController!,
              )),
          const Expanded(
              child: VideoPageTabsContainer(tabs: [
            '简介',
            '评论',
          ]))
        ],
      ),
    ));
  }

  Future<void> _initializeVideoPlayer(BuildContext context) async {
    _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse('https://stream7.iqilu.com/10339/upload_transcode/202002/09/20200209105011F0zPoYzHry.mp4'));
    if (_videoPlayerController != null) {
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: true,
        looping: false,
        allowMuting: true,
        allowPlaybackSpeedChanging: true,
        allowFullScreen: true,
        showControls: true,
        showOptions: false,
        showControlsOnInitialize: false,
        aspectRatio: 16 / 9,
        materialProgressColors: context.mounted
            ? ChewieProgressColors(
                playedColor: Theme.of(context).primaryColor,
                handleColor: Theme.of(context).primaryColor,
                backgroundColor: Theme.of(context).dividerColor,
                bufferedColor: Theme.of(context).unselectedWidgetColor,
              )
            : ChewieProgressColors(
                playedColor: Colors.transparent,
                handleColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                bufferedColor: Colors.transparent,
              ),
        placeholder: Container(
          color: context.mounted ? Theme.of(context).cardColor : Colors.transparent,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const TDImage(
                  assetUrl: 'assets/images/cute/konata_dancing.webp',
                  width: 100,
                  height: 64,
                ),
                const SizedBox(height: 8),
                Text('视频正在赶来的路上...',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                    )),
              ],
            ),
          ),
        ),
        customControls: const CustomControls(withTitle: '很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长的标题'),
      );
    }
    _videoPlayerController!.initialize().then((_) {
      setState(() {});
      _videoPlayerController!.play();
    }).onError((error, stackTrace) {
      debugPrint('VideoPlayerController: $error');
    });
    setState(() {});
  }
}
