import 'package:flutter/material.dart';
import 'package:fulifuli_app/pkg/chewie/src/animated_play_pause.dart';

class PlayButton extends StatelessWidget {
  const PlayButton({
    super.key,
    this.iconColor,
    required this.show,
    required this.isPlaying,
    required this.isFinished,
    this.onPressed,
  });

  final Color? iconColor;
  final bool show;
  final bool isPlaying;
  final bool isFinished;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: UnconstrainedBox(
        child: AnimatedOpacity(
          opacity: show ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: IconButton(
              // ignore overflows
              iconSize: 24,
              style: ButtonStyle(
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                alignment: Alignment.center,
              ),
              icon: isFinished
                  ? Icon(Icons.replay, color: iconColor)
                  : AnimatedPlayPause(
                      color: iconColor,
                      playing: isPlaying,
                    ),
              onPressed: onPressed,
            ),
          ),
        ),
      ),
    );
  }
}
