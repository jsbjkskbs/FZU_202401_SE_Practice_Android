import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// 透明渐变的图片Widget
class GradientImage extends StatelessWidget {
  /// 图片地址-支持本地和网络图片
  final String imgName;

  /// 图片宽度
  final double? width;

  /// 图片高度
  final double? height;

  /// 渐变开始位置 - 默认Alignment.topCenter
  final AlignmentGeometry begin;

  /// 渐变结束位置 - 默认Alignment.bottomCenter
  final AlignmentGeometry end;

  const GradientImage(
      {super.key,
      required this.imgName,
      this.width,
      this.height,
      this.begin = Alignment.topCenter,
      this.end = Alignment.bottomCenter});

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

  /// 根据图片名判断是网络还是本地的图片
  Widget _createImage() {
    if (imgName.startsWith('http')) {
      return CachedNetworkImage(
          width: width, height: height, imageUrl: imgName, fit: BoxFit.cover);
    } else {
      return Image.asset(imgName,
          width: width,
          height: height,
          fit: BoxFit.cover,
          alignment: Alignment.topCenter);
    }
  }
}
