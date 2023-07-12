import 'package:flutter/material.dart';
import 'package:projetbiblio/components/tab_view.dart';

import 'liste_revues.dart';

class OuvrageRevue extends StatelessWidget {
  const OuvrageRevue({super.key});

  @override
  Widget build(BuildContext context) {
    return TabView(
        tabs: [
          TabData(
              title: "Revues",
              content: ListeRevues(
                key: super.key,
              )),
        ],
        appTitle: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.library_books,
              size: 33,
            ), // Icône de document
            SizedBox(width: 15),
            Text('Liste des revues'), // Texte du titre
          ],
        ));
  }
}
