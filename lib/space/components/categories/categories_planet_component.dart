import 'package:flutter/material.dart';
import 'package:test001/space/components/categories/category_item.dart';
import 'package:test001/space/data/categories.dart';

class CategoriesPlanetComponent extends StatefulWidget {
  const CategoriesPlanetComponent({
    super.key,
  });

  @override
  State<CategoriesPlanetComponent> createState() =>
      _CategoriesPlanetComponentState();
}

class _CategoriesPlanetComponentState extends State<CategoriesPlanetComponent> {
  int selectedCategory = 0;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: List.generate(
            categoriesDetailScreen.length,
            (index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = index;
                    });
                  },
                  child: Padding(
                    padding: index == 0
                        ? const EdgeInsets.only(left: 22, right: 30)
                        : index == categories.length - 1
                            ? const EdgeInsets.only(right: 22)
                            : const EdgeInsets.only(right: 30),
                    child: CategoryItem(
                      category: categoriesDetailScreen[index],
                      selected: selectedCategory == index,
                    ),
                  ),
                )),
      ),
    );
  }
}
