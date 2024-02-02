

import 'package:flutter/material.dart';
import 'package:test001/space/data/earth_animation.dart';

class MovingEarth extends StatefulWidget {
  const MovingEarth({super.key, required this.child, required this.animatePosition, required this.durationInMs, required this.delayInMs});
    final Widget child;
    final EarthAnimation animatePosition;
  final int durationInMs, delayInMs;  

  @override
  State<MovingEarth> createState() => _MovingEarthState();
}

class _MovingEarthState extends State<MovingEarth> {
    bool? animate;

  @override
    void initState() {
    super.initState();
    changeAnimation();
  }
   @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: widget.durationInMs),
      curve: Curves.easeInOut,
      top: animate!
          ? widget.animatePosition.topAfter
          : widget.animatePosition.topBefore,
      left: animate!
          ? widget.animatePosition.leftAfter
          : widget.animatePosition.leftBefore,
      bottom: animate!
          ? widget.animatePosition.bottomAfter
          : widget.animatePosition.bottomBefore,
      right: animate!
          ? widget.animatePosition.rightAfter
          : widget.animatePosition.rightBefore,
      child: widget.child,
    );
  }

  Future changeAnimation() async {
    animate = false;
    await Future.delayed(Duration(milliseconds: widget.delayInMs));
    if (mounted) {
      setState(() {
        animate = true;
      });
    }
  }
}