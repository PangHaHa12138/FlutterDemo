import 'package:flutter/material.dart';
import 'package:test001/space/components/categories/categories_planet_component.dart';
import 'package:test001/space/components/icons_component.dart';
import 'package:test001/space/components/informationPlanet/size_and_distance.dart';
import 'package:test001/space/components/shared/txt_style.dart';

import 'package:test001/space/models/planets.dart';
import 'package:test001/space/utils/constants/colors.dart';
import 'package:test001/space/utils/constants/spaces.dart';
import 'package:test001/space/utils/extension/screen_size.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.planet});
  final PlanetsModel planet;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: SafeArea(
        child: ListView(
          children: [
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 22),
                  child: IconsComponent(),
                ),
                pVSpace24,
                const CategoriesPlanetComponent(),
                pVSpace64,
                Image.asset(
                  'assets/images/${planet.thumbnail}',
                  width: context.getWidth * 0.8,
                ),
                pVSpace24,
                Text(
                  planet.name!,
                  style: headerStyle.copyWith(fontSize: 32, color: white),
                ),
                pVSpace24,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: SizeAndDistance(planet: planet),
                ),
                pVSpace24,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Column(
                    children: [
                      Text(
                        'description',
                        style: subHeaderStyle.copyWith(
                            color: blue, fontSize: 18),
                      ),
                      pVSpace24,
                      Text(
                        '${planet.description}',
                        style: pBodyeStyle.copyWith(
                            color: white, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                pVSpace24,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
