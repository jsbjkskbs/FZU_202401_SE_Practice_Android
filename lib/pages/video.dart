import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fulifuli_app/pkg/chewie/chewie.dart';
import 'package:fulifuli_app/widgets/video_page/video_page_tabs_container.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:rect_getter/rect_getter.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../widgets/video_page/custom_controls/custom_controls.dart';

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
  StreamSubscription<AccelerometerEvent>? accelerometerHandler;
  final LinkedScrollControllerGroup _scrollControllerGroup = LinkedScrollControllerGroup();
  final GlobalKey<RectGetterState> _rectGetterKey = RectGetter.createGlobalKey();
  late ScrollController _headerScrollController;
  late ScrollController _bodyScrollController;
  late ScrollController _bodyScrollController0;
  double _chewieOpacity = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((_) {
      _initializeVideoPlayer(context);
    });
    accelerometerHandler = accelerometerEventStream().listen((event) {
      if (_chewieController == null) {
        return;
      }
      if (event.x.abs() >= 8 && !_chewieController!.isFullScreen) {
        _chewieController!.enterFullScreen();
      } else if (event.y.abs() >= 8 && _chewieController!.isFullScreen) {
        _chewieController!.exitFullScreen();
      }
    }, cancelOnError: true);
    _headerScrollController = _scrollControllerGroup.addAndGet();
    _bodyScrollController = _scrollControllerGroup.addAndGet();
    _bodyScrollController0 = _scrollControllerGroup.addAndGet();
  }

  @override
  void dispose() {
    if (_videoPlayerController != null) {
      _videoPlayerController!.dispose();
    }
    if (_chewieController != null) {
      _chewieController!.dispose();
    }
    accelerometerHandler!.cancel();
    _headerScrollController.dispose();
    _bodyScrollController.dispose();
    _bodyScrollController0.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint((ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)["vid"]);
    return SafeArea(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: CustomScrollView(
          controller: _headerScrollController,
          slivers: [
            SliverAppBar(
              leading: Container(),
              expandedHeight: MediaQuery.of(context).size.width * 9 / 16,
              flexibleSpace: VisibilityDetector(
                  key: const Key('v_s-_S---ss'),
                  child: RectGetter(
                      key: _rectGetterKey,
                      child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Stack(
                            children: [
                              Chewie(
                                controller: _chewieController!,
                              ),
                              if (_chewieOpacity > 0.25)
                                AnimatedOpacity(
                                    opacity: _chewieOpacity,
                                    duration: const Duration(milliseconds: 300),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ))
                            ],
                          ))),
                  onVisibilityChanged: (_) {
                    var old = _chewieOpacity;
                    _chewieOpacity =
                        1.0 - _rectGetterKey.currentContext!.size!.height / MediaQuery.of(context).size.width * 9.0 / 16.0 - 0.8;
                    _chewieOpacity = _chewieOpacity * 15;
                    _chewieOpacity = _chewieOpacity > 1 ? 1 : _chewieOpacity;
                    _chewieOpacity = _chewieOpacity < 0 ? 0 : _chewieOpacity;
                    if (old != _chewieOpacity) {
                      setState(() {});
                    }
                  }),
            ),
            SliverFillRemaining(
                child: Material(
              child: VideoPageTabsContainer(
                controller: _bodyScrollController,
                controller0: _bodyScrollController0,
                tabs: const [
                  '简介',
                  '评论',
                ],
              ),
            ))
          ],
        ),
      ),
    );
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
        customControls: const CustomControls(withTitle: '很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长的标题'),
        deviceOrientationsOnEnterFullScreen: [
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ],
        deviceOrientationsAfterFullScreen: [
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ],
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
