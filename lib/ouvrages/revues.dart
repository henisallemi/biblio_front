import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:projetbiblio/user_state.dart';
import 'package:provider/provider.dart';

class Ouvrage extends StatefulWidget {
  const Ouvrage({super.key});

  @override
  State<Ouvrage> createState() => _OuvrageState();
}

class _OuvrageState extends State<Ouvrage> {
  int selectedIndex =
      0; // Index du bouton sélectionné (-1 pour aucun bouton sélectionné)

  void changeColor(int buttonIndex) {
    setState(() {
      selectedIndex =
          buttonIndex; // Mettre à jour l'index du bouton sélectionné
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.description), // Icône de document
            SizedBox(width: 15),
            Text('Les Ouvrages'), // Texte du titre
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      width: 200,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          changeColor(
                              0); // Appeler la fonction changeColor avec l'index du bouton
                        },
                        style: ElevatedButton.styleFrom(
                            primary: selectedIndex == 0
                                ? const Color.fromARGB(255, 54, 149, 244)
                                : Colors
                                    .indigo // Couleur en fonction de l'index sélectionné
                            ),
                        icon: Icon(Icons.book),
                        label: Text("Livres"),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Expanded(
                    child: Container(
                      width: 200,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          changeColor(
                              1); // Appeler la fonction changeColor avec l'index du bouton
                        },
                        style: ElevatedButton.styleFrom(
                            primary: selectedIndex == 1
                                ? const Color.fromARGB(255, 54, 149, 244)
                                : Colors
                                    .indigo // Couleur en fonction de l'index sélectionné
                            ),
                        icon: Icon(Icons.article),
                        label: Text("Articles"),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Expanded(
                    child: Container(
                      width: 200,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          changeColor(
                              2); // Appeler la fonction changeColor avec l'index du bouton
                        },
                        style: ElevatedButton.styleFrom(
                            primary: selectedIndex == 2
                                ? const Color.fromARGB(255, 54, 149, 244)
                                : Colors
                                    .indigo // Couleur en fonction de l'index sélectionné
                            ),
                        icon: Icon(Icons.library_books),
                        label: Text("Revues"),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        width: 200,
                        height: MediaQuery.of(context).size.height,
                        color: Colors.grey,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              height: 100,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Expanded(
                              child: Container(
                                height: 300,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
