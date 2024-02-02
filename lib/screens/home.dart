import 'package:flutter/material.dart';
import 'package:test001/data/animation_item_data.dart';
import 'package:test001/widgets/home_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animated Background Demo'),
      ),
      body: const HomeList(item: animationItemData),
    );
  }
}
