import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fulifuli_app/pages/index.dart';
import 'package:fulifuli_app/pkg/chewie/chewie.dart';
import 'package:fulifuli_app/pkg/chewie/src/helpers/utils.dart';
import 'package:fulifuli_app/pkg/chewie/src/notifiers/player_notifier.dart';
import 'package:fulifuli_app/widgets/video_page/custom_controls/custom_progress_bar.dart';
import 'package:fulifuli_app/widgets/video_page/custom_controls/widgets/play_button.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:video_player/video_player.dart';

import 'widgets/options_dialog.dart';
import 'widgets/playback_speed_dialog.dart';

class CustomControls extends StatefulWidget {
  const CustomControls({
    this.showPlayButton = true,
    super.key,
    this.withTitle = '',
  });

  final bool showPlayButton;
  final String withTitle;

  @override
  State<StatefulWidget> createState() {
    return _CustomControlsState();
  }
}

class _CustomControlsState extends State<CustomControls> with SingleTickerProviderStateMixin {
  late PlayerNotifier notifier;
  late VideoPlayerValue _latestValue;
  double? _latestVolume;
  Timer? _hideTimer;
  Timer? _initTimer;
  Timer? _volumeHideTimer;
  Timer? _brightnessHideTimer;
  Timer? _speedUpHintTimer;
  bool _hideVolume = true;
  bool _hideBrightness = true;
  bool _hideSpeedUpHint = true;
  double _brightness = 0.0;
  late var _subtitlesPosition = Duration.zero;
  bool _subtitleOn = false;
  Timer? _showAfterExpandCollapseTimer;
  bool _dragging = false;
  bool _displayTapped = false;
  Timer? _bufferingDisplayTimer;
  bool _displayBufferingIndicator = false;

  final barHeight = 32.0;
  final marginSize = 5.0;

  late VideoPlayerController controller;
  ChewieController? _chewieController;

  // We know that _chewieController is set in didChangeDependencies
  ChewieController get chewieController => _chewieController!;

  @override
  void initState() {
    super.initState();
    notifier = Provider.of<PlayerNotifier>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    if (_latestValue.hasError) {
      return chewieController.errorBuilder?.call(
            context,
            chewieController.videoPlayerController.value.errorDescription!,
          ) ??
          const Center(
            child: Icon(
              Icons.error,
              color: Colors.white,
              size: 42,
            ),
          );
    }

    return MouseRegion(
      onHover: (_) {
        if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
          _cancelAndRestartTimer();
        }
      },
      child: GestureDetector(
        onTap: () => _switchTimerHiddenState(),
        // => _cancelAndRestartTimer(),
        onVerticalDragUpdate: (details) {
          if (details.localPosition.dx > MediaQuery.of(context).size.width / 2) {
            if (details.primaryDelta != null) {
              final double delta = details.primaryDelta! / MediaQuery.of(context).size.height;
              if (delta > 0) {
                controller.setVolume((controller.value.volume - delta).clamp(0.0, 1.0));
              } else if (delta < 0) {
                controller.setVolume((controller.value.volume - delta).clamp(0.0, 1.0));
              }
              _cancelAndRestartVolumeTimer();
            }
          } else {
            if (details.primaryDelta != null) {
              final double delta = details.primaryDelta! / MediaQuery.of(context).size.height;
              if (delta > 0) {
                ScreenBrightness.instance.setApplicationScreenBrightness((_brightness - delta).clamp(0.0, 1.0));
              } else if (delta < 0) {
                ScreenBrightness.instance.setApplicationScreenBrightness((_brightness - delta).clamp(0.0, 1.0));
              }
              _cancelAndRestartBrightnessTimer();
            }
          }
        },
        onLongPressStart: (details) {
          if (details.localPosition.dx > MediaQuery.of(context).size.width / 2) {
            controller.setPlaybackSpeed(2.0);
          } else {
            controller.setPlaybackSpeed(0.5);
          }
          _showSpeedUp();
        },
        onLongPressEnd: (_) {
          controller.setPlaybackSpeed(1.0);
          _hideSpeedUp();
        },
        child: AbsorbPointer(
          absorbing: notifier.hideStuff,
          child: Stack(
            children: [
              for (final mask in _buildPlayerMask()) mask,
              if (_displayBufferingIndicator)
                _chewieController?.bufferingBuilder?.call(context) ??
                    const Center(
                      child: CircularProgressIndicator(),
                    )
              else
                _buildHitArea(),
              _buildActionBar(),
              Positioned(left: 0, top: 0, child: _buildBackButton(context)),
              Positioned(
                left: 48,
                top: chewieController.isFullScreen ? 2 : 0,
                child: chewieController.isFullScreen ? _buildTitle() : _buildHomeButton(context),
              ),
              Positioned(
                  left: 0,
                  bottom: 0,
                  child: PlayButton(
                    iconColor: Colors.white,
                    isFinished: (_latestValue.position >= _latestValue.duration) && _latestValue.duration.inSeconds > 0,
                    isPlaying: controller.value.isPlaying,
                    show: widget.showPlayButton && !_dragging && !notifier.hideStuff,
                    onPressed: _playPause,
                  )),
              if (chewieController.allowFullScreen)
                Positioned(
                  right: 0,
                  bottom: 7,
                  child: _buildExpandButton(),
                ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  if (_subtitleOn)
                    Transform.translate(
                      offset: Offset(
                        0.0,
                        notifier.hideStuff ? barHeight * 0.8 : 0.0,
                      ),
                      child: _buildSubtitles(context, chewieController.subtitle!),
                    ),
                  _buildBottomBar(context),
                ],
              ),
              Positioned(left: MediaQuery.of(context).size.width / 2 - 50, bottom: barHeight * 2, child: _buildVolumeWidget()),
              Positioned(left: MediaQuery.of(context).size.width / 2 - 50, bottom: barHeight * 2, child: _buildBrightnessWidget()),
              Positioned(left: MediaQuery.of(context).size.width / 2 - 50, bottom: barHeight * 2, child: _buildSpeedUpHint())
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  void _dispose() {
    controller.removeListener(_updateState);
    _hideTimer?.cancel();
    _initTimer?.cancel();
    _volumeHideTimer?.cancel();
    _brightnessHideTimer?.cancel();
    _showAfterExpandCollapseTimer?.cancel();
    ScreenBrightness.instance.resetApplicationScreenBrightness();
  }

  @override
  void didChangeDependencies() {
    final oldController = _chewieController;
    _chewieController = ChewieController.of(context);
    controller = chewieController.videoPlayerController;

    if (oldController != chewieController) {
      _dispose();
      _initialize();
    }

    super.didChangeDependencies();
  }

  Widget _buildActionBar() {
    return Positioned(
      top: 0,
      right: 0,
      child: SafeArea(
        child: AnimatedOpacity(
          opacity: notifier.hideStuff ? 0.0 : 1.0,
          duration: const Duration(milliseconds: 250),
          child: Row(
            children: [
              _buildSubtitleToggle(),
              if (chewieController.showOptions) _buildOptionsButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpeedUpHint() {
    return AnimatedOpacity(
      opacity: _hideSpeedUpHint ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        width: 100,
        height: 60,
        margin: const EdgeInsets.only(right: 6.0),
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(
                _latestValue.playbackSpeed == 1.0
                    ? Icons.keyboard_arrow_right
                    : _latestValue.playbackSpeed == 2.0
                        ? Icons.keyboard_double_arrow_right
                        : Icons.last_page_outlined,
                color: Colors.white,
                size: 24.0,
              ),
              Text(
                '${_latestValue.playbackSpeed}x',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVolumeWidget() {
    return AnimatedOpacity(
      opacity: _hideVolume ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        width: 100,
        height: 60,
        margin: const EdgeInsets.only(right: 6.0),
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(
                _latestValue.volume > 0 ? Icons.volume_up : Icons.volume_off,
                color: Colors.white,
                size: 24.0,
              ),
              Text(
                '${(controller.value.volume * 100).toStringAsFixed(0)}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrightnessWidget() {
    ScreenBrightness.instance.application.then((value) {
      _brightness = value;
    });
    return AnimatedOpacity(
      opacity: _hideBrightness ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        width: 100,
        height: 60,
        margin: const EdgeInsets.only(right: 6.0),
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(
                _brightness > 0 ? Icons.brightness_high : Icons.brightness_low,
                color: Colors.white,
                size: 24.0,
              ),
              Text(
                '${(_brightness * 100).toStringAsFixed(0)}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionsButton() {
    final options = <OptionItem>[
      OptionItem(
        onTap: () async {
          Navigator.pop(context);
          _onSpeedButtonTap();
        },
        iconData: Icons.speed,
        title: chewieController.optionsTranslation?.playbackSpeedButtonText ?? 'Playback speed',
      )
    ];

    if (chewieController.additionalOptions != null && chewieController.additionalOptions!(context).isNotEmpty) {
      options.addAll(chewieController.additionalOptions!(context));
    }

    return AnimatedOpacity(
      opacity: notifier.hideStuff ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 250),
      child: IconButton(
        onPressed: () async {
          _hideTimer?.cancel();

          if (chewieController.optionsBuilder != null) {
            await chewieController.optionsBuilder!(context, options);
          } else {
            await showModalBottomSheet<OptionItem>(
              context: context,
              isScrollControlled: true,
              useRootNavigator: chewieController.useRootNavigator,
              builder: (context) => OptionsDialog(
                options: options,
                cancelButtonText: chewieController.optionsTranslation?.cancelButtonText,
              ),
            );
          }

          if (_latestValue.isPlaying) {
            _startHideTimer();
          }
        },
        icon: const Icon(
          Icons.more_vert,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSubtitles(BuildContext context, Subtitles subtitles) {
    if (!_subtitleOn) {
      return const SizedBox();
    }
    final currentSubtitle = subtitles.getByPosition(_subtitlesPosition);
    if (currentSubtitle.isEmpty) {
      return const SizedBox();
    }

    if (chewieController.subtitleBuilder != null) {
      return chewieController.subtitleBuilder!(
        context,
        currentSubtitle.first!.text,
      );
    }

    return Padding(
      padding: EdgeInsets.all(marginSize),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: const Color(0x96000000),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          currentSubtitle.first!.text.toString(),
          style: const TextStyle(
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  AnimatedOpacity _buildBottomBar(
    BuildContext context,
  ) {
    final iconColor = Theme.of(context).textTheme.labelLarge!.color;

    return AnimatedOpacity(
      opacity: notifier.hideStuff ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        height: barHeight + 4.0,
        padding: const EdgeInsets.only(
          left: 4,
          bottom: 10.0,
        ),
        child: SafeArea(
          top: false,
          bottom: chewieController.isFullScreen,
          minimum: chewieController.controlsSafeAreaMinimum,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(width: 36),
                    if (!chewieController.isLive)
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Row(
                            children: [
                              _buildProgressBar(),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(width: 8),
                    if (chewieController.isLive) const Expanded(child: Text('直播中')) else _buildPosition(iconColor),
                    const SizedBox(width: 50)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector _buildBackButton(context) {
    return GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: AnimatedOpacity(
            opacity: notifier.hideStuff ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 300),
            child: ClipRect(
              child: Container(
                height: barHeight,
                padding: const EdgeInsets.only(left: 16, top: 8),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            )));
  }

  GestureDetector _buildHomeButton(
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamedAndRemoveUntil(context, IndexPage.routeName, (route) => false);
      },
      child: AnimatedOpacity(
        opacity: notifier.hideStuff ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 300),
        child: ClipRect(
          child: Container(
            height: barHeight,
            padding: const EdgeInsets.only(left: 16, top: 8),
            child: const Icon(
              Icons.home_outlined,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return AnimatedOpacity(
        opacity: notifier.hideStuff ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 300),
        child: Padding(
          padding: const EdgeInsets.only(left: 16, top: 3),
          child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              height: barHeight,
              child: AutoSizeText(
                widget.withTitle,
                maxLines: 1,
                style: const TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                overflowReplacement: Marquee(
                  text: widget.withTitle,
                  fadingEdgeStartFraction: 0.1,
                  fadingEdgeEndFraction: 0.1,
                  style: const TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              )),
        ));
  }

  GestureDetector _buildMuteButton(
    VideoPlayerController controller,
  ) {
    return GestureDetector(
      onTap: () {
        _cancelAndRestartTimer();

        if (_latestValue.volume == 0) {
          controller.setVolume(_latestVolume ?? 0.5);
        } else {
          _latestVolume = controller.value.volume;
          controller.setVolume(0.0);
        }
      },
      child: AnimatedOpacity(
        opacity: notifier.hideStuff ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 300),
        child: ClipRect(
          child: Container(
            height: barHeight,
            padding: const EdgeInsets.only(
              left: 6.0,
            ),
            child: Icon(
              _latestValue.volume > 0 ? Icons.volume_up : Icons.volume_off,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector _buildExpandButton() {
    return GestureDetector(
      onTap: _onExpandCollapse,
      child: AnimatedOpacity(
        opacity: notifier.hideStuff ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          height: barHeight,
          margin: const EdgeInsets.only(right: 6.0),
          padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: chewieController.isFullScreen ? 2.0 : 0.0),
          child: Center(
            child: Icon(
              chewieController.isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  List<Positioned> _buildPlayerMask() {
    return <Positioned>[
      Positioned(
        top: 0,
        child: AnimatedContainer(
          decoration: !notifier.hideStuff
              ? BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.5),
                      Colors.transparent,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                )
              : null,
          duration: const Duration(milliseconds: 300),
          height: barHeight * 4,
          width: MediaQuery.of(context).size.width,
        ),
      ),
      Positioned(
        bottom: 0,
        child: AnimatedContainer(
          decoration: !notifier.hideStuff
              ? BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.5),
                      Colors.transparent,
                    ],
                    end: Alignment.topCenter,
                    begin: Alignment.bottomCenter,
                  ),
                )
              : null,
          duration: const Duration(milliseconds: 300),
          height: barHeight * 4,
          width: MediaQuery.of(context).size.width,
        ),
      ),
    ];
  }

  Widget _buildHitArea() {
    final bool isFinished = (_latestValue.position >= _latestValue.duration) && _latestValue.duration.inSeconds > 0;
    final bool showPlayButton = widget.showPlayButton && !_dragging && !notifier.hideStuff;

    return GestureDetector(
      onDoubleTap: () {
        if (_latestValue.isPlaying) {
          controller.pause();
        } else {
          controller.play();
        }
      },
      child: Container(
        alignment: Alignment.center,
        color: Colors.transparent, // The Gesture Detector doesn't expand to the full size of the container without this; Not sure why!
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                margin: EdgeInsets.symmetric(
                  horizontal: marginSize,
                ),
                child: Container()),
          ],
        ),
      ),
    );
  }

  Future<void> _onSpeedButtonTap() async {
    _hideTimer?.cancel();

    final chosenSpeed = await showModalBottomSheet<double>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: chewieController.useRootNavigator,
      builder: (context) => PlaybackSpeedDialog(
        speeds: chewieController.playbackSpeeds,
        selected: _latestValue.playbackSpeed,
      ),
    );

    if (chosenSpeed != null) {
      controller.setPlaybackSpeed(chosenSpeed);
    }

    if (_latestValue.isPlaying) {
      _startHideTimer();
    }
  }

  Widget _buildPosition(Color? iconColor) {
    final position = _latestValue.position;
    final duration = _latestValue.duration;

    return RichText(
      text: TextSpan(
        text: '${formatDuration(position)} ',
        children: <InlineSpan>[
          TextSpan(
            text: '/ ${formatDuration(duration)}',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.white.withOpacity(.75),
              fontWeight: FontWeight.normal,
            ),
          )
        ],
        style: const TextStyle(
          fontSize: 14.0,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSubtitleToggle() {
    //if don't have subtitle hidden button
    if (chewieController.subtitle?.isEmpty ?? true) {
      return const SizedBox();
    }
    return GestureDetector(
      onTap: _onSubtitleTap,
      child: Container(
        height: barHeight,
        color: Colors.transparent,
        padding: const EdgeInsets.only(
          left: 12.0,
          right: 12.0,
        ),
        child: Icon(
          _subtitleOn ? Icons.closed_caption : Icons.closed_caption_off_outlined,
          color: _subtitleOn ? Colors.white : Colors.grey[700],
        ),
      ),
    );
  }

  void _onSubtitleTap() {
    setState(() {
      _subtitleOn = !_subtitleOn;
    });
  }

  void _cancelAndRestartTimer() {
    _hideTimer?.cancel();
    _startHideTimer();

    setState(() {
      notifier.hideStuff = false;
      _displayTapped = true;
    });
  }

  void _switchTimerHiddenState() {
    _hideTimer?.cancel();

    setState(() {
      notifier.hideStuff = !notifier.hideStuff;
      _displayTapped = true;
    });

    if (!notifier.hideStuff) {
      _startHideTimer();
    }
  }

  Future<void> _initialize() async {
    _subtitleOn = chewieController.subtitle?.isNotEmpty ?? false;
    controller.addListener(_updateState);

    _updateState();

    if (controller.value.isPlaying || chewieController.autoPlay) {
      _startHideTimer();
    }

    if (chewieController.showControlsOnInitialize) {
      _initTimer = Timer(const Duration(milliseconds: 200), () {
        setState(() {
          notifier.hideStuff = false;
        });
      });
    }
  }

  void _onExpandCollapse() {
    setState(() {
      notifier.hideStuff = true;

      chewieController.toggleFullScreen();
      _showAfterExpandCollapseTimer = Timer(const Duration(milliseconds: 300), () {
        setState(() {
          _cancelAndRestartTimer();
        });
      });
    });
  }

  void _playPause() {
    final bool isFinished = (_latestValue.position >= _latestValue.duration) && _latestValue.duration.inSeconds > 0;

    setState(() {
      if (controller.value.isPlaying) {
        notifier.hideStuff = false;
        _hideTimer?.cancel();
        controller.pause();
      } else {
        _cancelAndRestartTimer();

        if (!controller.value.isInitialized) {
          controller.initialize().then((_) {
            controller.play();
          });
        } else {
          if (isFinished) {
            controller.seekTo(Duration.zero);
          }
          controller.play();
        }
      }
    });
  }

  void _startHideTimer() {
    final hideControlsTimer =
        chewieController.hideControlsTimer.isNegative ? ChewieController.defaultHideControlsTimer : chewieController.hideControlsTimer;
    _hideTimer = Timer(hideControlsTimer, () {
      setState(() {
        notifier.hideStuff = true;
      });
    });
  }

  void _cancelAndRestartVolumeTimer() {
    _volumeHideTimer?.cancel();
    _startVolumeTimer();

    setState(() {
      _hideVolume = false;
      _hideBrightness = true;
      _hideSpeedUpHint = true;
    });
  }

  void _cancelAndRestartBrightnessTimer() {
    _brightnessHideTimer?.cancel();
    _startBrightnessTimer();

    setState(() {
      _hideBrightness = false;
      _hideVolume = true;
      _hideSpeedUpHint = true;
    });
  }

  void _showSpeedUp() {
    setState(() {
      _hideSpeedUpHint = false;
      _hideBrightness = true;
      _hideVolume = true;
    });
  }

  void _hideSpeedUp() {
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        _hideSpeedUpHint = true;
      });
    });
  }

  void _startVolumeTimer() {
    final hideControlsTimer =
        chewieController.hideControlsTimer.isNegative ? ChewieController.defaultHideControlsTimer : chewieController.hideControlsTimer;
    _volumeHideTimer = Timer(hideControlsTimer, () {
      setState(() {
        _hideVolume = true;
      });
    });
  }

  void _startBrightnessTimer() {
    final hideControlsTimer =
        chewieController.hideControlsTimer.isNegative ? ChewieController.defaultHideControlsTimer : chewieController.hideControlsTimer;
    _brightnessHideTimer = Timer(hideControlsTimer, () {
      setState(() {
        _hideBrightness = true;
      });
    });
  }

  void _bufferingTimerTimeout() {
    _displayBufferingIndicator = true;
    if (mounted) {
      setState(() {});
    }
  }

  void _updateState() {
    if (!mounted) return;

    // display the progress bar indicator only after the buffering delay if it has been set
    if (chewieController.progressIndicatorDelay != null) {
      if (controller.value.isBuffering) {
        _bufferingDisplayTimer ??= Timer(
          chewieController.progressIndicatorDelay!,
          _bufferingTimerTimeout,
        );
      } else {
        _bufferingDisplayTimer?.cancel();
        _bufferingDisplayTimer = null;
        _displayBufferingIndicator = false;
      }
    } else {
      _displayBufferingIndicator = controller.value.isBuffering;
    }

    setState(() {
      _latestValue = controller.value;
      _subtitlesPosition = controller.value.position;
    });
  }

  Widget _buildProgressBar() {
    return Expanded(
      child: CustomVideoProgressBar(
        controller,
        onDragStart: () {
          setState(() {
            _dragging = true;
          });

          _hideTimer?.cancel();
        },
        onDragUpdate: () {
          _hideTimer?.cancel();
        },
        onDragEnd: () {
          setState(() {
            _dragging = false;
          });

          _startHideTimer();
        },
        colors: chewieController.materialProgressColors ??
            ChewieProgressColors(
              playedColor: Theme.of(context).colorScheme.secondary,
              handleColor: Theme.of(context).colorScheme.secondary,
              bufferedColor: Theme.of(context).colorScheme.surface.withOpacity(0.5),
              backgroundColor: Theme.of(context).disabledColor.withOpacity(.5),
            ),
        draggableProgressBar: chewieController.draggableProgressBar,
      ),
    );
  }
}
