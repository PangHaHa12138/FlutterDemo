import 'package:flutter/material.dart';
import 'package:test001/space/components/shared/txt_style.dart';
import 'package:test001/space/data/astronomical_news.dart';
import 'package:test001/space/utils/constants/colors.dart';
import 'package:test001/space/utils/constants/spaces.dart';

class NewsItem extends StatelessWidget {
  const NewsItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 22),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: darkBlue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'How humans pick\nout constellation',
                style: pBodyeStyle.copyWith(fontSize: 16, height: 1.5),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: blue,
              )
            ],
          ),
          pVSpace16,
          Text(
            astronomicalNews,
            overflow: TextOverflow.clip,
            style: pBodyeStyle.copyWith(
                fontSize: 11, color: white, height: 1.5, letterSpacing: 1),
          )
        ],
      ),
    );
  }
}
