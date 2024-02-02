import 'package:flutter/material.dart';
import 'package:test001/space/components/categories/categories_component.dart';
import 'package:test001/space/components/news/astronomical_news.dart';
import 'package:test001/space/components/news/news_item.dart';
import 'package:test001/space/components/planets/planets_card.dart';
import 'package:test001/space/components/shared/txt_style.dart';


import 'package:test001/space/utils/constants/colors.dart';
import 'package:test001/space/utils/constants/spaces.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Text("Welcome!",
                  style: headerStyle.copyWith(color: white, fontSize: 32)),
            ),
            pVSpace8,
            const CategoriesComponent(),
            pVSpace8,
            const PlanetsCard(),
            const AstronomicalNews(),
            pVSpace8,
            const NewsItem(),
            pVSpace16,
          ],
        ),
      ),
    );
  }
}
