import 'package:flutter/material.dart';
import 'package:test001/models/animation_item.dart';

class HomeList extends StatelessWidget {
  const HomeList({Key? key, required this.item}) : super(key: key);

  final List<AnimationItem> item;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: item.length,
      itemBuilder: (ctx, index) => Padding(
        padding: const EdgeInsets.only(
          top: 15.0,
          left: 12.0,
          right: 12.0,
          bottom: 15.0,
        ),
        child: Material(
          borderRadius: BorderRadius.circular(12.0),
          elevation: 4.0,
          child: InkWell(
            borderRadius: BorderRadius.circular(12.0),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => item[index].targetWidget,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                title: Text(
                  item[index].title,
                ),
                subtitle: Text(
                  item[index].subtitle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
