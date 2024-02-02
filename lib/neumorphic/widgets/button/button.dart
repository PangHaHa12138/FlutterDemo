import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class ButtonSample extends StatefulWidget {
  @override
  createState() => _ButtonSampleState();
}

class _ButtonSampleState extends State<ButtonSample> {
  @override
  Widget build(BuildContext context) {
    return NeumorphicTheme(
        themeMode: ThemeMode.light,
        theme: const NeumorphicThemeData(
          baseColor: Color(0xFFFFFFFF),
          intensity: 0.5,
          lightSource: LightSource.topLeft,
          depth: 10,
        ),
        darkTheme: const NeumorphicThemeData(
          baseColor: Color(0xFF000000),
          intensity: 0.5,
          lightSource: LightSource.topLeft,
          depth: 10,
        ),
        child: _Page());
  }
}

class _Page extends StatefulWidget {
  @override
  createState() => __PageState();
}

class __PageState extends State<_Page> {
  bool _useDark = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("back"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _useDark = !_useDark;
                  NeumorphicTheme.of(context)!.themeMode =
                      _useDark ? ThemeMode.dark : ThemeMode.light;
                });
              },
              child: const Text("toggle theme"),
            ),
            const SizedBox(height: 34),
            _buildTopBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Center(
      child: NeumorphicButton(
        onPressed: () {
          print("click");
        },
        style: const NeumorphicStyle(
          shape: NeumorphicShape.flat,
          boxShape: NeumorphicBoxShape.circle(),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Icon(
            Icons.favorite_border,
            color: _iconsColor(),
          ),
        ),
      ),
    );
  }

  Color _iconsColor() {
    final theme = NeumorphicTheme.of(context);
    if (theme!.isUsingDark) {
      return theme.current!.accentColor;
    } else {
      return Colors.lightGreen;
    }
  }
}
