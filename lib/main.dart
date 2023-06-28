import 'package:flutter/material.dart';
import 'package:projetbiblio/components/tab_view.dart';
import 'package:projetbiblio/connect/from_Screen.dart';
import 'package:projetbiblio/home/first_page.dart';
import 'package:projetbiblio/home/menu.dart';
import 'package:projetbiblio/connect/inscrire_utilisateur.dart';
import 'package:projetbiblio/user_state.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider<UserState>(
      create: (_) => UserState(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: FirstPage(),
    );
  }
}
