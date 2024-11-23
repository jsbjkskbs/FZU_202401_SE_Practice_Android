import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../generated/l10n.dart';

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
      return CachedNetworkImage(
        width: width,
        height: height,
        imageUrl: imgName,
        fit: BoxFit.cover,
        errorWidget: (context, _, __) {
          return Stack(
            children: [
              Center(
                child: Image.asset('assets/images/error_cover.png',
                    width: width, height: height, fit: BoxFit.cover, alignment: Alignment.topCenter),
              ),
              Center(
                  child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, 2),
                      blurRadius: 4,
                    )
                  ],
                ),
                child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      S.current.function_default_image_load_failed,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    )),
              )),
            ],
          );
        },
      );
    } else {
      return Image.asset(imgName, width: width, height: height, fit: BoxFit.cover, alignment: Alignment.topCenter);
    }
  }
}
