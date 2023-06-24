import 'package:flutter/material.dart';
import 'package:projetbiblio/components/tab_view.dart';
import 'package:projetbiblio/ouvrages/list_articles.dart';
import 'package:projetbiblio/ouvrages/liste_livres.dart';
import 'package:projetbiblio/ouvrages/liste_revues.dart';

class Ouvrage extends StatelessWidget {
  const Ouvrage({super.key});

  @override
  Widget build(BuildContext context) {
    return TabView(
        tabs: [
          TabData(
              title: "Livres",
              content: ListeLivres(
                key: super.key,
              )),
          TabData(
              title: "Articles",
              content: ListeArticles(
                key: super.key,
              )),
          TabData(
              title: "Revues",
              content: ListeRevues(
                key: super.key,
              )),
        ],
        appTitle: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.description), // Icône de document
            SizedBox(width: 15),
            Text('Liste des Ouvrages'), // Texte du titre
          ],
        ));
  }
}
