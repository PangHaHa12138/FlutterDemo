import 'package:flutter/widgets.dart';
import 'package:test001/space/components/shared/txt_style.dart';
import 'package:test001/space/utils/constants/colors.dart';

class AstronomicalNews extends StatelessWidget {
  const AstronomicalNews({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('astronomical news',
              style: headerStyle.copyWith(fontSize: 20, color: white)),
          Text('see all',
              style: headerStyle.copyWith(
                  fontSize: 20, color: white.withOpacity(0.5))),
        ],
      ),
    );
  }
}
