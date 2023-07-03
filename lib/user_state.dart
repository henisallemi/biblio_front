import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:projetbiblio/model/model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserState extends ChangeNotifier {
  String jwt = "";
  User? connectedUser;

  Future<void> initializeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if user data is stored in SharedPreferences
    if (prefs.containsKey('user')) {
      String user = prefs.getString('user')!;
      connectedUser = User.fromJson(json.decode(user));
    }
  }

  Future<void> setUser(String jwt, User connectedUser) async {
    this.jwt = jwt;
    this.connectedUser = connectedUser;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user", jsonEncode(connectedUser.toJson()));
    notifyListeners();
  }

  Future<void> logout() async {
    jwt = "";
    connectedUser = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }
}

class UserProvider extends StatelessWidget {
  final Widget child;

  UserProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserState>(
      create: (_) => UserState(),
      child: child,
    );
  }

  static UserState of(BuildContext context) {
    return Provider.of<UserState>(context, listen: false);
  }
}
