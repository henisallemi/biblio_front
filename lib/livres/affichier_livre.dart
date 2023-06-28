import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projetbiblio/model/model.dart';
import 'package:projetbiblio/livres/liste_livres.dart';
import 'package:fluttertoast/fluttertoast.dart';

// ignore: must_be_immutable
class AffichierLivre extends StatelessWidget {
  Livre? livre;
  AffichierLivre({super.key, this.livre});

  @override
  Widget build(BuildContext context) {
    void closeForm() {
      Navigator.pop(context); // Revenir en arrière
    }

    return Container(
      height: 200,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.visibility),
                SizedBox(width: 5),
                Text(
                  "Les détails du livre",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                Visibility(
                  child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      closeForm();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  "Le titre de ce livre est ${livre?.ouvrage.titre} et les auteurs de ce livre sont Ahmet et Amin. Il a été publié en 2016 et nous avons 24 exemplaires de ce livre dans notre bibliothèque.",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
