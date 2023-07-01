import 'package:flutter/material.dart';
import 'package:projetbiblio/components/tab_view.dart';

import 'liste_articles.dart';

class OuvrageArticle extends StatelessWidget {
  const OuvrageArticle({super.key});

  @override
  Widget build(BuildContext context) {
    return TabView(
        tabs: [
          TabData(
              title: "Articles",
              content: ListeArticles(
                key: super.key,
              )),
        ],
        appTitle: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.article,
              size: 33,
            ), // Icône de document
            SizedBox(width: 15),
            Text('Liste des articles'), // Texte du titre
          ],
        ));
  }
}
