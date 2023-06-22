import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:projetbiblio/ouvrages/book_table.dart';
import 'dart:convert';
import 'package:projetbiblio/user_state.dart';
import 'package:provider/provider.dart';

class Ouvrage extends StatefulWidget {
  const Ouvrage({super.key});

  @override
  State<Ouvrage> createState() => _OuvrageState();
}

class _OuvrageState extends State<Ouvrage> {
  bool showArticleContent = false;
  bool showRevueContent = false;
  bool showLivreContent = true;
  String? selectedOption;
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
            Text('Liste des Ouvrages'), // Texte du titre
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
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            changeColor(
                                0); // Appeler la fonction changeColor avec l'index du bouton
                            showArticleContent = false;
                            showRevueContent = false;
                            showLivreContent = true;
                          },
                          style: ElevatedButton.styleFrom(
                            primary: selectedIndex == 0
                                ? const Color.fromARGB(255, 255, 0, 0)
                                : Colors
                                    .indigo, // Couleur en fonction de l'index sélectionné
                          ),
                          icon: Icon(Icons.book),
                          label: Text("Livres"),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 3),
                  Expanded(
                    child: Container(
                      width: 200,
                      height: 50,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Material(
                          color: selectedIndex == 1
                              ? const Color.fromARGB(255, 255, 0, 0)
                              : Colors.indigo,
                          child: InkWell(
                            onTap: () {
                              changeColor(1);
                              setState(() {
                                showArticleContent = true;
                                showRevueContent = false;
                                showLivreContent = false;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.article),
                                SizedBox(width: 5),
                                Text("Articles"),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 3),
                  Expanded(
                    child: Container(
                      width: 200,
                      height: 50,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Material(
                          color: selectedIndex == 2
                              ? const Color.fromARGB(255, 255, 0, 0)
                              : Colors.indigo,
                          child: InkWell(
                            onTap: () {
                              changeColor(2);
                              setState(() {
                                showRevueContent = true;
                                showArticleContent = false;
                                showLivreContent = false;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.library_books),
                                SizedBox(width: 5),
                                Text("Revues"),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              if (showArticleContent) ...[
                Row(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          width: 200,
                          height: MediaQuery.of(context).size.height,
                          color: Colors.grey,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Icon(Icons.search),
                                          SizedBox(width: 5),
                                          Text(
                                            'Chercher un article',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(15),
                                      child: Row(
                                        children: [
                                          SizedBox(width: 30),
                                          DropdownButton<String>(
                                            value:
                                                selectedOption, // Utilisez la valeur sélectionnée
                                            items: [
                                              DropdownMenuItem<String>(
                                                value: 'Titre',
                                                child: Text('Titre'),
                                              ),
                                              DropdownMenuItem<String>(
                                                value: 'Auteur',
                                                child: Text('Auteur'),
                                              ),
                                              DropdownMenuItem<String>(
                                                value: 'Année',
                                                child: Text('Année'),
                                              ),
                                            ],
                                            onChanged: (String? value) {
                                              setState(() {
                                                selectedOption = value ??
                                                    ''; // Mettez à jour la valeur sélectionnée
                                              });
                                            },
                                            hint: Text(selectedOption ??
                                                'Recherche par :'),
                                            underline: Container(
                                              height: 1,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          SizedBox(width: 30),
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      7.0), // Ajout du padding horizontal
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.3),
                                                    spreadRadius: 2,
                                                    blurRadius: 5,
                                                    offset: Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: TextField(
                                                decoration: InputDecoration(
                                                  hintText: 'Rechercher...',
                                                  border: InputBorder.none,
                                                  icon: Icon(
                                                    Icons.search,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 30),
                                          ElevatedButton(
                                            onPressed: () {
                                              // Gérer l'action du bouton
                                            },
                                            child: Text(
                                              'Rechercher',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors
                                                  .indigo, // Couleur de fond du bouton
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical:
                                                      10), // Espacement interne du bouton
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    8), // Bord arrondi du bouton
                                              ),
                                              elevation:
                                                  3, // Élévation du bouton
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          ElevatedButton(
                                            onPressed: () {
                                              // Gérer l'action du bouton
                                            },
                                            child: Text(
                                              'Details',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors
                                                  .indigo, // Couleur de fond du bouton
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical:
                                                      10), // Espacement interne du bouton
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    8), // Bord arrondi du bouton
                                              ),
                                              elevation:
                                                  3, // Élévation du bouton
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Icon(Icons.list_alt),
                                            SizedBox(width: 5),
                                            Text(
                                              'Liste des articles disponibles',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  height: 300,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ] else if (showRevueContent) ...[
                Row(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          width: 200,
                          height: MediaQuery.of(context).size.height,
                          color: Colors.grey,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Icon(Icons.search),
                                          SizedBox(width: 5),
                                          Text(
                                            'Chercher une revue',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(15),
                                      child: Row(
                                        children: [
                                          SizedBox(width: 30),
                                          DropdownButton<String>(
                                            value:
                                                selectedOption, // Utilisez la valeur sélectionnée
                                            items: [
                                              DropdownMenuItem<String>(
                                                value: 'Titre',
                                                child: Text('Titre'),
                                              ),
                                              DropdownMenuItem<String>(
                                                value: 'Auteur',
                                                child: Text('Auteur'),
                                              ),
                                              DropdownMenuItem<String>(
                                                value: 'Année',
                                                child: Text('Année'),
                                              ),
                                            ],
                                            onChanged: (String? value) {
                                              setState(() {
                                                selectedOption = value ??
                                                    ''; // Mettez à jour la valeur sélectionnée
                                              });
                                            },
                                            hint: Text(selectedOption ??
                                                'Recherche par :'),
                                            underline: Container(
                                              height: 1,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          SizedBox(width: 30),
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      7.0), // Ajout du padding horizontal
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.3),
                                                    spreadRadius: 2,
                                                    blurRadius: 5,
                                                    offset: Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: TextField(
                                                decoration: InputDecoration(
                                                  hintText: 'Rechercher...',
                                                  border: InputBorder.none,
                                                  icon: Icon(
                                                    Icons.search,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 30),
                                          ElevatedButton(
                                            onPressed: () {
                                              // Gérer l'action du bouton
                                            },
                                            child: Text(
                                              'Rechercher',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors
                                                  .indigo, // Couleur de fond du bouton
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical:
                                                      10), // Espacement interne du bouton
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    8), // Bord arrondi du bouton
                                              ),
                                              elevation:
                                                  3, // Élévation du bouton
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          ElevatedButton(
                                            onPressed: () {
                                              // Gérer l'action du bouton
                                            },
                                            child: Text(
                                              'Details',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors
                                                  .indigo, // Couleur de fond du bouton
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical:
                                                      10), // Espacement interne du bouton
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    8), // Bord arrondi du bouton
                                              ),
                                              elevation:
                                                  3, // Élévation du bouton
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Expanded(
                                child: Container(
                                  child: Column(children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Icon(Icons.list_alt),
                                          SizedBox(width: 5),
                                          Text(
                                            'Liste des revues disponibles',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                                  height: 300,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ] else if (showLivreContent) ...[
                Row(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          width: 200,
                          height: MediaQuery.of(context).size.height,
                          color: Colors.grey,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Icon(Icons.search),
                                          SizedBox(width: 5),
                                          Text(
                                            'Chercher un livre',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(15),
                                      child: Row(
                                        children: [
                                          SizedBox(width: 30),
                                          DropdownButton<String>(
                                            value:
                                                selectedOption, // Utilisez la valeur sélectionnée
                                            items: [
                                              DropdownMenuItem<String>(
                                                value: 'Titre',
                                                child: Text('Titre'),
                                              ),
                                              DropdownMenuItem<String>(
                                                value: 'Auteur',
                                                child: Text('Auteur'),
                                              ),
                                              DropdownMenuItem<String>(
                                                value: 'Année',
                                                child: Text('Année'),
                                              ),
                                            ],
                                            onChanged: (String? value) {
                                              setState(() {
                                                selectedOption = value ??
                                                    ''; // Mettez à jour la valeur sélectionnée
                                              });
                                            },
                                            hint: Text(selectedOption ??
                                                'Recherche par :'),
                                            underline: Container(
                                              height: 1,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          SizedBox(width: 30),
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      7.0), // Ajout du padding horizontal
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.3),
                                                    spreadRadius: 2,
                                                    blurRadius: 5,
                                                    offset: Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: TextField(
                                                decoration: InputDecoration(
                                                  hintText: 'Rechercher...',
                                                  border: InputBorder.none,
                                                  icon: Icon(
                                                    Icons.search,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 30),
                                          ElevatedButton(
                                            onPressed: () {
                                              // Gérer l'action du bouton
                                            },
                                            child: Text(
                                              'Rechercher',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors
                                                  .indigo, // Couleur de fond du bouton
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical:
                                                      10), // Espacement interne du bouton
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    8), // Bord arrondi du bouton
                                              ),
                                              elevation:
                                                  3, // Élévation du bouton
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          ElevatedButton(
                                            onPressed: () {
                                              // Gérer l'action du bouton
                                            },
                                            child: Text(
                                              'Details',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors
                                                  .indigo, // Couleur de fond du bouton
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical:
                                                      10), // Espacement interne du bouton
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    8), // Bord arrondi du bouton
                                              ),
                                              elevation:
                                                  3, // Élévation du bouton
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Expanded(
                                child: Container(
                                  child: Column(children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Icon(Icons.list_alt),
                                          SizedBox(width: 5),
                                          Text(
                                            'Liste des livres disponibles',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    BookTable(),
                                  ]),
                                  height: 300,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
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
            ],
          ),
        ),
      ),
    );
  }
}
