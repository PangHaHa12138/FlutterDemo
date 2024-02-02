import 'package:flutter/widgets.dart';
import 'package:test001/space/components/shared/txt_style.dart';
import 'package:test001/space/utils/constants/colors.dart';
import 'package:test001/space/utils/constants/spaces.dart';

class CategoryItem extends StatelessWidget {
  final ValueNotifier<Size> notifier = ValueNotifier(const Size(0, 0));
  final String category;
  final bool selected;
  CategoryItem({super.key, required this.category, required this.selected});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      notifier.value = (context.findRenderObject() as RenderBox).size;
    });
    return ValueListenableBuilder(
      valueListenable: notifier,
      builder: (context, value, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              category,
              style: headerStyle.copyWith(
                  color: selected ? blue : white,
                  fontSize: 16,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal),
            ),
            pVSpace8,
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: selected ? (value as Size).width * 0.5 : 0,
              height: 2.5,
              decoration: BoxDecoration(
                  color: blue, borderRadius: BorderRadius.circular(10)),
            )
          ],
        );
      },
    );
  }
}