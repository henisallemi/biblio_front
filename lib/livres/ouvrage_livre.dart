import 'package:flutter/material.dart';
import 'package:projetbiblio/components/tab_view.dart';
import 'package:projetbiblio/livres/liste_livres.dart';

class OuvrageLivre extends StatelessWidget {
  const OuvrageLivre({super.key});

  @override
  Widget build(BuildContext context) {
    return TabView(
        tabs: [
          TabData(
              title: "Livres",
              content: ListeLivres(
                key: super.key,
              )),
        ],
        appTitle: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.book,
              size: 33,
            ), // Icône de document
            SizedBox(width: 15),
            Text('Liste des livres'), // Texte du titre
          ],
        ));
  }
}
