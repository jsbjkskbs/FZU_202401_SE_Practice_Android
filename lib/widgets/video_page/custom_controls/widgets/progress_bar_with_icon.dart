import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fulifuli_app/pkg/chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class VideoProgressBarWithIcon extends StatefulWidget {
  VideoProgressBarWithIcon(
    this.controller, {
    ChewieProgressColors? colors,
    this.onDragEnd,
    this.onDragStart,
    this.onDragUpdate,
    this.draggableProgressBar = true,
    super.key,
    required this.barHeight,
    required this.handleHeight,
    required this.drawShadow,
  }) : colors = colors ?? ChewieProgressColors();

  final VideoPlayerController controller;
  final ChewieProgressColors colors;
  final Function()? onDragStart;
  final Function()? onDragEnd;
  final Function()? onDragUpdate;

  final double barHeight;
  final double handleHeight;
  final bool drawShadow;
  final bool draggableProgressBar;

  @override
  // ignore: library_private_types_in_public_api
  _VideoProgressBarWithIconState createState() {
    return _VideoProgressBarWithIconState();
  }
}

class _VideoProgressBarWithIconState extends State<VideoProgressBarWithIcon> {
  void listener() {
    if (!mounted) return;
    setState(() {});
  }

  bool _controllerWasPlaying = false;

  Offset? _latestDraggableOffset;

  VideoPlayerController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    controller.addListener(listener);
  }

  @override
  void deactivate() {
    controller.removeListener(listener);
    super.deactivate();
  }

  void _seekToRelativePosition(Offset globalPosition) {
    controller.seekTo(context.calcRelativePosition(
      controller.value.duration,
      globalPosition,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final child = Center(
      child: StaticProgressBar(
        value: controller.value,
        colors: widget.colors,
        barHeight: widget.barHeight,
        handleHeight: widget.handleHeight,
        drawShadow: widget.drawShadow,
        latestDraggableOffset: _latestDraggableOffset,
      ),
    );

    return widget.draggableProgressBar
        ? GestureDetector(
            onHorizontalDragStart: (DragStartDetails details) {
              if (!controller.value.isInitialized) {
                return;
              }
              _controllerWasPlaying = controller.value.isPlaying;
              if (_controllerWasPlaying) {
                controller.pause();
              }

              widget.onDragStart?.call();
            },
            onHorizontalDragUpdate: (DragUpdateDetails details) {
              if (!controller.value.isInitialized) {
                return;
              }
              _latestDraggableOffset = details.globalPosition;
              listener();

              widget.onDragUpdate?.call();
            },
            onHorizontalDragEnd: (DragEndDetails details) {
              if (_controllerWasPlaying) {
                controller.play();
              }

              if (_latestDraggableOffset != null) {
                _seekToRelativePosition(_latestDraggableOffset!);
                _latestDraggableOffset = null;
              }

              widget.onDragEnd?.call();
            },
            onTapDown: (TapDownDetails details) {
              if (!controller.value.isInitialized) {
                return;
              }
              _seekToRelativePosition(details.globalPosition);
            },
            child: child,
          )
        : child;
  }
}

class StaticProgressBar extends StatelessWidget {
  const StaticProgressBar({
    super.key,
    required this.value,
    required this.colors,
    required this.barHeight,
    required this.handleHeight,
    required this.drawShadow,
    this.latestDraggableOffset,
  });

  final Offset? latestDraggableOffset;
  final VideoPlayerValue value;
  final ChewieProgressColors colors;

  final double barHeight;
  final double handleHeight;
  final bool drawShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.transparent,
      child: CustomPaint(
        painter: _ProgressBarPainter(
          value: value,
          draggableValue: latestDraggableOffset != null
              ? context.calcRelativePosition(
                  value.duration,
                  latestDraggableOffset!,
                )
              : null,
          colors: colors,
          barHeight: barHeight,
          handleHeight: handleHeight,
          drawShadow: drawShadow,
        ),
      ),
    );
  }
}

class _ProgressBarPainter extends CustomPainter {
  _ProgressBarPainter({
    required this.value,
    required this.colors,
    required this.barHeight,
    required this.handleHeight,
    required this.drawShadow,
    required this.draggableValue,
  });

  VideoPlayerValue value;
  ChewieProgressColors colors;

  final double barHeight;
  final double handleHeight;
  final bool drawShadow;

  final _littleTvScaleRate = 0.4;
  final Paint littleTvPaintBg = Paint()
    ..style = PaintingStyle.fill
    ..strokeWidth = 2.5
    ..color = const Color(0xffefefef);

  final Paint littleTvPaint0 = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.5
    ..color = const Color(0xfffb7299);
  final Paint littleTvPaint1 = Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 2.5
    ..color = const Color(0xfffb7299);

  /// The value of the draggable progress bar.
  /// If null, the progress bar is not being dragged.
  final Duration? draggableValue;

  @override
  bool shouldRepaint(CustomPainter painter) {
    return true;
  }

  @override
  Future<void> paint(Canvas canvas, Size size) async {
    final baseOffset = size.height / 2 - barHeight / 2;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromPoints(
          Offset(0.0, baseOffset),
          Offset(size.width, baseOffset + barHeight),
        ),
        const Radius.circular(4.0),
      ),
      colors.backgroundPaint,
    );
    if (!value.isInitialized) {
      return;
    }
    final double playedPartPercent =
        (draggableValue != null ? draggableValue!.inMilliseconds : value.position.inMilliseconds) / value.duration.inMilliseconds;
    final double playedPart = playedPartPercent > 1 ? size.width : playedPartPercent * size.width;
    for (final DurationRange range in value.buffered) {
      final double start = range.startFraction(value.duration) * size.width;
      final double end = range.endFraction(value.duration) * size.width;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromPoints(
            Offset(start, baseOffset),
            Offset(end, baseOffset + barHeight),
          ),
          const Radius.circular(4.0),
        ),
        colors.bufferedPaint,
      );
    }
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromPoints(
          Offset(0.0, baseOffset),
          Offset(playedPart, baseOffset + barHeight),
        ),
        const Radius.circular(4.0),
      ),
      colors.playedPaint,
    );

    if (drawShadow) {
      final Path shadowPath = Path()
        ..addOval(
          Rect.fromCircle(
            center: Offset(playedPart, baseOffset + barHeight / 2),
            radius: handleHeight,
          ),
        );

      canvas.drawShadow(shadowPath, Colors.black, 0.2, false);
    }

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromPoints(
          Offset(playedPart - 27 * _littleTvScaleRate, baseOffset + barHeight / 2 - 20 * _littleTvScaleRate),
          Offset(playedPart + 27 * _littleTvScaleRate, baseOffset + barHeight / 2 + 20 * _littleTvScaleRate),
        ),
        Radius.circular(12.0 * _littleTvScaleRate),
      ),
      littleTvPaintBg,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromPoints(
          Offset(playedPart - 27 * _littleTvScaleRate, baseOffset + barHeight / 2 - 20 * _littleTvScaleRate),
          Offset(playedPart + 27 * _littleTvScaleRate, baseOffset + barHeight / 2 + 20 * _littleTvScaleRate),
        ),
        Radius.circular(10.0 * _littleTvScaleRate),
      ),
      littleTvPaint0,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromPoints(
          Offset(playedPart - 11 * _littleTvScaleRate, baseOffset + barHeight / 2 - 5 * _littleTvScaleRate),
          Offset(playedPart - 12 * _littleTvScaleRate, baseOffset + barHeight / 2 + 4 * _littleTvScaleRate),
        ),
        Radius.circular(10.0 * _littleTvScaleRate),
      ),
      littleTvPaint0,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromPoints(
          Offset(playedPart + 11 * _littleTvScaleRate, baseOffset + barHeight / 2 - 5 * _littleTvScaleRate),
          Offset(playedPart + 12 * _littleTvScaleRate, baseOffset + barHeight / 2 + 4 * _littleTvScaleRate),
        ),
        Radius.circular(10.0 * _littleTvScaleRate),
      ),
      littleTvPaint0,
    );

    canvas.drawLine(
      Offset(playedPart - 15 * _littleTvScaleRate, baseOffset + barHeight / 2 - 30 * _littleTvScaleRate),
      Offset(playedPart - 5 * _littleTvScaleRate, baseOffset + barHeight / 2 - 20 * _littleTvScaleRate),
      littleTvPaint1,
    );

    canvas.drawLine(
      Offset(playedPart + 15 * _littleTvScaleRate, baseOffset + barHeight / 2 - 30 * _littleTvScaleRate),
      Offset(playedPart + 5 * _littleTvScaleRate, baseOffset + barHeight / 2 - 20 * _littleTvScaleRate),
      littleTvPaint1,
    );
  }
}

extension RelativePositionExtensions on BuildContext {
  Duration calcRelativePosition(
    Duration videoDuration,
    Offset globalPosition,
  ) {
    final box = findRenderObject()! as RenderBox;
    final Offset tapPos = box.globalToLocal(globalPosition);
    final double relative = (tapPos.dx / box.size.width).clamp(0, 1);
    final Duration position = videoDuration * relative;
    return position;
  }
}
