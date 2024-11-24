import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fulifuli_app/pkg/chewie/chewie.dart';
import 'package:fulifuli_app/widgets/comment_list.dart';
import 'package:fulifuli_app/widgets/video_page/video_page_tabs_container.dart';
import 'package:rect_getter/rect_getter.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../generated/l10n.dart';
import '../global.dart';
import '../model/video.dart';
import '../widgets/video_page/custom_controls/custom_controls.dart';
import '../widgets/video_page/video_introduction_view.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key, required this.videoId});

  static const String routeName = '/video';
  final String videoId;

  @override
  State<StatefulWidget> createState() {
    return _VideoPageState();
  }
}

class _VideoPageState extends State<VideoPage> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  StreamSubscription<AccelerometerEvent>? accelerometerHandler;
  final GlobalKey<RectGetterState> _rectGetterKey = RectGetter.createGlobalKey();
  double _chewieOpacity = 0;
  Video? video;
  bool _blockScroll = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((_) async {
      await _fetchData();
      debugPrint('video: $video');
      if (video != null) {
        await _initializeVideoPlayer();
      }
      setState(() {});
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
    if (video != null) {
      Global.cachedMapVideo.remove(video!.id!);
      Global.cachedMapVideoList.remove('${VideoIntroductionView.cachePrefix}/${video!.id!}');
      if (Global.cachedMapCommentList.containsKey('${CommentListView.uniqueKey}/video/${video!.id!}')) {
        debugPrint('remove ${CommentListView.uniqueKey}/video/${video!.id!}');
      }
      Global.cachedMapCommentList.remove('${CommentListView.uniqueKey}/video/child_comment/${video!.id!}');
      Global.cachedMapCommentList.remove('${CommentListView.uniqueKey}/video/${video!.id!}');
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: video == null
            ? _getErrorPage()
            : CustomScrollView(
                //  controller: _headerScrollController,
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
                      blockScroll: _blockScroll,
                      video: video!,
                      tabs: [
                        S.current.video_introduction_title,
                        S.current.video_comments_title,
                      ],
                    ),
                  ))
                ],
              ),
      ),
    );
  }

  Future<void> _initializeVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(video!.videoUrl!));
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
        customControls: CustomControls(withTitle: video!.title!),
        deviceOrientationsOnEnterFullScreen: [
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ],
        deviceOrientationsAfterFullScreen: [
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ],
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TDImage(
                  assetUrl: 'assets/images/error_video.png',
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.contain,
                ),
                Text(
                  S.current.empty_placeholder_hint,
                  style: TextStyle(fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize, color: Theme.of(context).primaryColor),
                ),
              ],
            ),
          );
        },
      );
    }
    _videoPlayerController!.initialize().then((_) {
      setState(() {});
      _videoPlayerController!.play();
      _videoPlayerController!.addListener(() {
        debugPrint('isPlaying: ${_chewieController!.isPlaying}');
        if (_chewieController!.isPlaying) {
          _blockScroll = false;
        } else {
          _blockScroll = true;
        }
        setState(() {});
      });
    }).onError((error, stackTrace) {
      debugPrint('VideoPlayerController: $error');
    });
    setState(() {});
  }

  Widget _getErrorPage() {
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TDImage(
                assetUrl: 'assets/images/cute/konata_dancing.webp',
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width * 0.6,
              ),
              Text(
                S.current.empty_placeholder_hint,
                style: TextStyle(fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize, color: Theme.of(context).primaryColor),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Future<void> _fetchData() async {
    Response response;
    response = await Global.dio.get('/api/v1/video/info', data: {
      "video_id": widget.videoId,
    });
    if (response.data["code"] == Global.successCode) {
      video = Video.fromJson(response.data["data"]);
    } else {
      video = null;
    }
  }
}
