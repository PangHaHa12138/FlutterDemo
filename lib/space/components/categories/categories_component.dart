import 'package:flutter/widgets.dart';
import 'package:test001/space/components/categories/category_item.dart';
import 'package:test001/space/data/categories.dart';

class CategoriesComponent extends StatefulWidget {
  const CategoriesComponent({
    super.key,
  });

  @override
  State<CategoriesComponent> createState() => _CategoriesComponentState();
}

class _CategoriesComponentState extends State<CategoriesComponent> {
  int selectedCategory = 1;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
          children: List.generate(
        categories.length,
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
                category: categories[index],
                selected: selectedCategory == index),
          ),
        ),
      )),
    );
  }
}
