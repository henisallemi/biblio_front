import 'package:flutter/material.dart';
import 'package:projetbiblio/components/tab_view.dart';
import 'package:projetbiblio/ouvrages/article_formulaire.dart';

class AddOuvrage extends StatelessWidget {
  const AddOuvrage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.library_add), // Icône de document
              SizedBox(width: 15),
              Text('Ajouter Ouvrage'), // Texte du titre
            ],
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
          child: Column(mainAxisSize: MainAxisSize.max, children: [
            TabView(tabs: [
              TabData(
                  title: 'Articles',
                  content: ArticleFormulaire(
                    key: super.key,
                  ))
            ])
          ]),
        ));
  }
}

  /*  Future<void> envoyerMots() async {
    String mots = _textEditingController.text.trim();
    String mots1 = _textEditingController1.text.trim();
    String mots2 = _textEditingController2.text.trim();
    String mots3 = _textEditingController3.text.trim();

    // URL de l'API pour l'insertion dans la base de données
    String url = 'http://localhost:4000/api/users';

    try {
      // Envoi de la requête POST avec les mots
      var response = await http.post(
        Uri.parse(url),
        body: {
          'nom': mots,
          'prenom': mots1,
          'email': mots2,
          'motDePasse': mots3,
        },
      );

      if (response.statusCode == 200) {
        // Réponse réussie de l'API

        print('Mots envoyés avec succès !');
      } else {
        // Gestion des erreurs
        print(
            'Erreur lors de l\'envoi des mots. Code de réponse : ${response.statusCode}');
      }
    } catch (e) {
      // Gestion des erreurs
      print('Erreur lors de l\'envoi des mots : $e');
    }
  } */

