import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:projetbiblio/user_state.dart';
import 'package:provider/provider.dart';

class AjouteLivre extends StatefulWidget {
  const AjouteLivre({super.key});

  @override
  State<AjouteLivre> createState() => _AjouteLivreState();
}

class _AjouteLivreState extends State<AjouteLivre> {
  TextEditingController _textEditingController = TextEditingController();
  TextEditingController _textEditingController1 = TextEditingController();
  TextEditingController _textEditingController2 = TextEditingController();
  TextEditingController _textEditingController3 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    UserState userState = Provider.of<UserState>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Mon Application'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _textEditingController,
              decoration: const InputDecoration(
                labelText: 'nom',
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _textEditingController1,
              decoration: const InputDecoration(
                labelText: 'prenom',
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _textEditingController2,
              decoration: const InputDecoration(
                labelText: 'email',
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _textEditingController3,
              decoration: const InputDecoration(
                labelText: 'mot de pass',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: envoyerMots,
              child: Text('Valider'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> envoyerMots() async {
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
  }
}
