import 'package:flutter/material.dart';
import 'package:projetbiblio/connect/from_Screen.dart';
import 'package:projetbiblio/dashboard/dashboard1.dart';
import 'package:projetbiblio/dashboard/dashboard2.dart';
import 'package:projetbiblio/dashboard/dashboard_admin.dart';
import 'package:projetbiblio/home/first_page.dart';
import 'package:projetbiblio/roles.dart';
import 'package:projetbiblio/user_state.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(
    ChangeNotifierProvider<UserState>(
      create: (_) => UserState()..initializeUser(),
      child: const MyApp(),
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
    var userState = Provider.of<UserState>(context);
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate, // Ajoutez cette ligne
      ],
      supportedLocales: [
        const Locale('fr', ''), // Français
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: userState.connectedUser?.id != null
          ? const FormScreen()
          : (userState.connectedUser?.role == Roles.admin)
              ? Dashbord2()
              : FirstPage(),
    );
  }
}
