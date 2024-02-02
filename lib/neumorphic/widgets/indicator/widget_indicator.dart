
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:test001/neumorphic/lib/Code.dart';
import 'package:test001/neumorphic/lib/ThemeConfigurator.dart';
import 'package:test001/neumorphic/lib/color_selector.dart';

import 'dart:math' show Random;

import 'package:test001/neumorphic/lib/top_bar.dart';

class IndicatorWidgetPage extends StatefulWidget {
  IndicatorWidgetPage({Key? key}) : super(key: key);

  @override
  createState() => _WidgetPageState();
}

class _WidgetPageState extends State<IndicatorWidgetPage> {
  @override
  Widget build(BuildContext context) {
    return NeumorphicTheme(
      themeMode: ThemeMode.light,
      theme: const NeumorphicThemeData(
        lightSource: LightSource.topLeft,
        accentColor: NeumorphicColors.accent,
        depth: 4,
        intensity: 0.5,
      ),
      child: _Page(),
    );
  }
}

class _Page extends StatefulWidget {
  @override
  createState() => _PageState();
}

class _PageState extends State<_Page> {
  @override
  Widget build(BuildContext context) {
    return NeumorphicBackground(
      padding: const EdgeInsets.all(8),
      child: Scaffold(
        appBar: TopBar(
          title: "Indicator",
          actions: <Widget>[
            ThemeConfigurator(),
          ],
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              _DefaultWidget(),
              _DefaultOrientationWidget(),
              _DurationWidget(),
              _ColorWidget(),
              _CurveWidget(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class _DefaultWidget extends StatefulWidget {
  @override
  createState() => _DefaultWidgetState();
}

class _DefaultWidgetState extends State<_DefaultWidget> {
  double percent = 0.6;

  Widget _buildCode(BuildContext context) {
    return const Code("""
NeumorphicIndicator(
    height: 100,
    width: 20,
    percent: 0.6,
),
""");
  }

  Widget _buildWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: <Widget>[
          Text(
            "Default",
            style: TextStyle(color: NeumorphicTheme.defaultTextColor(context)),
          ),
          const SizedBox(width: 12),
          NeumorphicIndicator(
            height: 100,
            width: 20,
            percent: percent,
          ),
          const SizedBox(width: 12),
          TextButton(
              child: const Text('Update'),
              onPressed: () {
                setState(() {
                  percent = Random().nextDouble();
                });
              }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _buildWidget(context),
        _buildCode(context),
      ],
    );
  }
}

class _DefaultOrientationWidget extends StatefulWidget {
  @override
  createState() => _DefaultOrientationWidgetState();
}

class _DefaultOrientationWidgetState extends State<_DefaultOrientationWidget> {
  Widget _buildCode(BuildContext context) {
    return const Code("""
NeumorphicIndicator(
     width: 150,
     height: 15,
     orientation: NeumorphicIndicatorOrientation.horizontal,
     percent: 0.7,
),
""");
  }

  Widget _buildWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: <Widget>[
          Text(
            "Orientation\nHorizontal",
            style: TextStyle(color: NeumorphicTheme.defaultTextColor(context)),
          ),
          const SizedBox(width: 12),
          const NeumorphicIndicator(
            width: 150,
            height: 15,
            orientation: NeumorphicIndicatorOrientation.horizontal,
            percent: 0.7,
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _buildWidget(context),
        _buildCode(context),
      ],
    );
  }
}

class _ColorWidget extends StatefulWidget {
  @override
  createState() => _ColorWidgetState();
}

class _ColorWidgetState extends State<_ColorWidget> {
  Widget _buildCode(BuildContext context) {
    return const Code("""
NeumorphicIndicator(
      width: 150,
      height: 15,
      orientation: NeumorphicIndicatorOrientation.horizontal,
      percent: 0.7,
      style: IndicatorStyle(
        variant: variant,
        accent: accent
      ),
),
""");
  }

  Color accent = Colors.green;
  Color variant = Colors.purple;

  Widget _buildWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              const Text("Accent : "),
              ColorSelector(
                onColorChanged: (color) {
                  setState(() {
                    accent = color;
                  });
                },
                color: accent,
              ),
              const SizedBox(width: 12),
              const Text("Variant : "),
              ColorSelector(
                onColorChanged: (color) {
                  setState(() {
                    variant = color;
                  });
                },
                color: variant,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Text(
                "Colorized",
                style:
                    TextStyle(color: NeumorphicTheme.defaultTextColor(context)),
              ),
              const SizedBox(width: 12),
              NeumorphicIndicator(
                width: 150,
                height: 15,
                orientation: NeumorphicIndicatorOrientation.horizontal,
                percent: 0.7,
                style: IndicatorStyle(variant: variant, accent: accent),
              ),
              const SizedBox(width: 12),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _buildWidget(context),
        _buildCode(context),
      ],
    );
  }
}

class _DurationWidget extends StatefulWidget {
  @override
  createState() => _DurationWidgetState();
}

class _DurationWidgetState extends State<_DurationWidget> {
  double percent = 0.3;

  Widget _buildCode(BuildContext context) {
    return const Code("""
NeumorphicIndicator(
    height: 100,
    width: 20,
    percent: 0.3,
    duration: Duration(seconds: 1),
),
""");
  }

  Widget _buildWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: <Widget>[
          Text(
            "Duration",
            style: TextStyle(color: NeumorphicTheme.defaultTextColor(context)),
          ),
          const SizedBox(width: 12),
          NeumorphicIndicator(
            height: 100,
            width: 20,
            percent: percent,
            duration: const Duration(seconds: 1),
          ),
          const SizedBox(width: 12),
          TextButton(
              child: const Text('Update'),
              onPressed: () {
                setState(() {
                  percent = Random().nextDouble();
                });
              }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _buildWidget(context),
        _buildCode(context),
      ],
    );
  }
}

class _CurveWidget extends StatefulWidget {
  @override
  createState() => _CurveWidgetState();
}

class _CurveWidgetState extends State<_CurveWidget> {
  double percent = 0.3;

  Widget _buildCode(BuildContext context) {
    return const Code("""
NeumorphicIndicator(
    height: 100,
    width: 20,
    percent: 0.3,
    curve: Curves.bounceOut,
),
""");
  }

  Widget _buildWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: <Widget>[
          Text(
            "Curve",
            style: TextStyle(color: NeumorphicTheme.defaultTextColor(context)),
          ),
          const SizedBox(width: 12),
          NeumorphicIndicator(
              height: 100,
              width: 20,
              percent: percent,
              curve: Curves.bounceOut),
          const SizedBox(width: 12),
          TextButton(
              child: const Text('Update'),
              onPressed: () {
                setState(() {
                  percent = Random().nextDouble();
                });
              }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _buildWidget(context),
        _buildCode(context),
      ],
    );
  }
}
