import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserState extends ChangeNotifier {
  String jwt = "";
  String connectedUser = "";

  void setUser(String jwt, String connectedUser) {
    this.jwt = jwt;
    this.connectedUser = connectedUser;
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