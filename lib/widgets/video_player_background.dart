import 'package:flutter/material.dart';
import 'package:test001/theme/colors.dart';

class VideoPlayerBackground extends StatelessWidget {
  final String img;
  const VideoPlayerBackground({
    Key? key,
    required this.size, required this.img,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height,
      width: size.width,
      decoration: const BoxDecoration(
          color: black,
      )
    );
  }
}