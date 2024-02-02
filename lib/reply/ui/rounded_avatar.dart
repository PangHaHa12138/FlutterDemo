import 'package:flutter/material.dart';

class RoundedAvatar extends StatefulWidget {
  const RoundedAvatar({Key? key, required this.image})
      : super(key: key);

  final String image;

  @override
  State createState() => _RoundedAvatarState();
}

class _RoundedAvatarState extends State<RoundedAvatar> {
  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const CircleBorder(
        side: BorderSide(color: Color(0xFFEEF1F3), width: 1),
      ),
      clipBehavior: Clip.hardEdge,
      child: Image.asset(
        widget.image,
        width: 36,
        height: 36,
      ),
    );
  }
}
