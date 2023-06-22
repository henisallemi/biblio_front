import 'package:flutter/material.dart';
import 'package:projetbiblio/home/menu.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Action à effectuer lors du clic sur l'icône de recherche
            },
          ),
        ],
        title: Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'images/litterature.jpg',
                      width: 90, // Nouvelle largeur souhaitée
                      height: 50, // Nouvelle hauteur souhaitée
                    ),
                    SizedBox(width: 5),
                    Text(
                      "Notre Bibliothéque :  ",
                    ),
                    Text(
                      "Réussir",
                      style: TextStyle(
                        color: Colors.red, // Couleur verte
                        fontSize: 30, // Taille de police
                        fontWeight: FontWeight.bold, // Gras
                        fontStyle: FontStyle.italic, // Italique
                        fontFamily: "Arial", // Police de caractères spécifique
                        // Soulignement du texte
                        decorationColor:
                            Colors.black12, // Couleur de soulignement
                        decorationThickness: 2, // Épaisseur du soulignement
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: Menu(),
    );
  }
}
