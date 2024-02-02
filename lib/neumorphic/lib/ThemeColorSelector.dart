import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

import 'color_selector.dart';

class ThemeColorSelector extends StatefulWidget {
  final BuildContext customContext;

  const ThemeColorSelector({super.key, required this.customContext});

  @override
  _ThemeColorSelectorState createState() => _ThemeColorSelectorState();
}

class _ThemeColorSelectorState extends State<ThemeColorSelector> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      color: Colors.black,
      child: ColorSelector(
        color: NeumorphicTheme.baseColor(widget.customContext),
        onColorChanged: (color) {
          setState(() {
            NeumorphicTheme.update(widget.customContext,
                (current) => current!.copyWith(baseColor: color));
          });
        },
      ),
    );
  }
}
