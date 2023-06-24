import 'package:flutter/material.dart';

class TabData {
  final dynamic title;
  final Widget content;

  TabData({required this.title, required this.content});
}

// ignore: must_be_immutable
class TabView extends StatelessWidget {
  List<TabData> tabs;
  Widget appTitle;

  TabView({super.key, required this.tabs, required this.appTitle});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: tabs.map((tab) {
              return Tab(
                child: tab.title is String ? Text(tab.title) : tab.title,
              );
            }).toList(),
          ),
          title: appTitle,
        ),
        body: TabBarView(
          children: tabs.map((tab) => tab.content).toList(),
        ),
      ),
    );
  }
}
