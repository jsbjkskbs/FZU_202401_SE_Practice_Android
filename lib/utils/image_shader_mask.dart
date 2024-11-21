import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class GradientImage extends StatelessWidget {
  final String imgName;

  final double? width;

  final double? height;

  final AlignmentGeometry begin;

  final AlignmentGeometry end;

  const GradientImage(
      {super.key, required this.imgName, this.width, this.height, this.begin = Alignment.topCenter, this.end = Alignment.bottomCenter});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) {
        return LinearGradient(
          begin: const Alignment(0, 0.32),
          end: end,
          colors: const [Colors.black, Colors.transparent],
        ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
      },
      blendMode: BlendMode.dstIn,
      child: _createImage(),
    );
  }

  Widget _createImage() {
    if (imgName.startsWith('http')) {
      return CachedNetworkImage(width: width, height: height, imageUrl: imgName, fit: BoxFit.cover);
    } else {
      return Image.asset(imgName, width: width, height: height, fit: BoxFit.cover, alignment: Alignment.topCenter);
    }
  }
}
