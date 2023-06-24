import 'package:flutter/material.dart';
import 'package:projetbiblio/components/tab_view.dart';
import 'package:projetbiblio/ouvrages/article_formulaire.dart';
import 'package:projetbiblio/ouvrages/livres_formulaire.dart';

class AddOuvrage extends StatelessWidget {
  const AddOuvrage({super.key});

  @override
  Widget build(BuildContext context) {
    return TabView(
      tabs: [
        TabData(
            title: 'Articles',
            content: ArticleFormulaire(
              key: super.key,
            )),
        TabData(
            title: "Livres",
            content: LivreFormulaire(
              key: super.key,
            )),
        TabData(
            title: "Revues",
            content: Row(
              children: [],
            ))
      ],
      appTitle: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.library_add), // Icône de document
          SizedBox(width: 15),
          Text('Ajouter Ouvrage'), // Texte du titre
        ],
      ),
    );
  }
}
