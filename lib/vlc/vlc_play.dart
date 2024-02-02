import 'package:flutter/material.dart';

import 'multiple_tab.dart';
import 'single_tab.dart';


class VlcPlayPage extends StatefulWidget {
  @override
  _VlcPlayPageState createState() => _VlcPlayPageState();
}

class _VlcPlayPageState extends State<VlcPlayPage> {
  static const _tabCount = 2;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabCount,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Vlc Player Example'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Single'),
              Tab(text: 'Multiple'),
            ],
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            SingleTab(),
            MultipleTab(),
          ],
        ),
      ),
    );
  }
}
