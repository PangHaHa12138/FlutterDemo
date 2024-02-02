import 'package:flutter/material.dart';
import 'package:test001/space/components/animation/moving_earth.dart';
import 'package:test001/space/components/shared/txt_style.dart';
import 'package:test001/space/data/earth_animation.dart';
import 'package:test001/space/screens/home_screen.dart';
import 'package:test001/space/utils/constants/colors.dart';
import 'package:test001/space/utils/extension/nav.dart';
import 'package:test001/space/utils/extension/screen_size.dart';
import 'package:test001/space/data/planets_data.dart';
import 'package:test001/space/models/planets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key,});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

List<PlanetsModel> listPlanets = [];

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    for (var element in planetsData["planets"]) {
      listPlanets.add(PlanetsModel.fromJson(element));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: SizedBox(
        width: context.getWidth,
        height: context.getHeight,
        child: Stack(
          children: [
            MovingEarth(
              animatePosition: EarthAnimation(
                topAfter: -150,
                topBefore: -150,
                leftAfter: -650,
                leftBefore: -800,
                bottomAfter: -150,
                bottomBefore: -150,
              ),
              delayInMs: 1000,
              durationInMs: 2500,
              child: GestureDetector(
                onTap: () {
                  context.pushNav(screen: const HomeScreen());
                },
                child: Image.asset("assets/images/earth_home.jpg"),
              ),
            ),
            Positioned(
              left: 25,
              bottom: 20,
              right: 25,
              child: RichText(
                text: TextSpan(
                  style: headerStyle.copyWith(fontSize: 35),
                  children: [
                    const TextSpan(text: 'discover your '),
                    TextSpan(
                        text: 'home', style: headerStyle.copyWith(color: blue)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
