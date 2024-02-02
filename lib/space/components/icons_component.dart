


import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:test001/space/utils/constants/colors.dart';
import 'package:test001/space/utils/extension/nav.dart';

class IconsComponent extends StatelessWidget {
  const IconsComponent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
           onTap: () {
                      context.popNav();
                      },
          child: Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
                color: darkBlue.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12)),
            child: const Icon(
              Icons.arrow_back_ios_rounded,
              color: blue,
            ),
          ),
        ),
        Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
              color: darkBlue.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12)),
          child: const Icon(
            Icons.more_vert_rounded,
            color: blue,
          ),
        ),
      ],
    );
  }
}
