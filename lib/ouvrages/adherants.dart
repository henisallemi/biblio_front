import 'package:flutter/material.dart';
import 'package:projetbiblio/roles.dart';
import 'package:projetbiblio/users/liste_users.dart';
import 'package:projetbiblio/components/tab_view.dart';

class Adherants extends StatelessWidget {
  const Adherants({super.key});

  @override
  Widget build(BuildContext context) {
    return TabView(
        tabs: [
          TabData(
              title: "Adhérants",
              content: ListeUsers(
                role: Roles.adherant,
                key: super.key,
              )),
        ],
        appTitle: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.format_list_bulleted,
              size: 30,
            ), // Icône de document
            SizedBox(width: 15),
            Text('Liste des Adhérants'), // Texte du titre
          ],
        ));
  }
}
