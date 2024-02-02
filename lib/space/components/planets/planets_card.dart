import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:test001/space/components/planets/planet_item.dart';

import 'package:test001/space/screens/detail_screen.dart';
import 'package:test001/space/screens/splash_screen.dart';
import 'package:test001/space/utils/extension/nav.dart';

import 'package:test001/space/utils/extension/screen_size.dart';

class PlanetsCard extends StatefulWidget {
  const PlanetsCard({
    super.key,
  });

  @override
  State<PlanetsCard> createState() => _PlanetsCardState();
}

class _PlanetsCardState extends State<PlanetsCard> {
  PageController? pageController;
  double? pageOffset = 1;
  double viewPortFraction = 0.85;

  @override
  void initState() {
    super.initState();
    pageController =
        PageController(initialPage: 1, viewportFraction: viewPortFraction)
          ..addListener(() {
            setState(() {
              pageOffset = pageController!.page;
            });
          });
  }

  @override
  void dispose() {
    super.dispose();
    pageController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.getHeight * 0.55,
      child: PageView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: listPlanets.length,
        controller: pageController,
        itemBuilder: (context, index) {
          double scale = max(viewPortFraction, (1 - (pageOffset! - index).abs() + viewPortFraction));
          return GestureDetector(
            onTap: () {
              context.pushNav(
                  screen: DetailScreen(
                planet: listPlanets[index],
              ));
            },
            child: PlanetItem(
              viewPortFraction: viewPortFraction,
              scale: scale,
              planet: listPlanets[index],
            ),
          );
        },
      ),
    );
  }
}
