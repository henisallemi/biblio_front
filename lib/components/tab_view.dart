import 'package:flutter/material.dart';

class TabData {
  final dynamic title; // Can be a String or an Icon
  final Widget content;

  TabData({required this.title, required this.content});
}

// ignore: must_be_immutable
class TabView extends StatelessWidget {
  final List<TabData> tabs;

  const TabView({super.key, required this.tabs});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: tabs.map((tab) {
                return Tab(
                  child:
                      tab.title is String ? Text(tab.title) : Icon(tab.title),
                );
              }).toList(),
            ),
            title: const Text('Tabs Demo'),
          ),
          body: TabBarView(
            children: tabs.map((tab) => tab.content).toList(),
          ),
        ),
      ),
    );
  }
}
