import 'package:flutter/material.dart';

class ListeRevues extends StatefulWidget {
  const ListeRevues({super.key});

  @override
  State<ListeRevues> createState() => _ListeRevuesState();
}

class _ListeRevuesState extends State<ListeRevues> {
  String? selectedOption;
  @override
  Widget build(BuildContext context) {
    return Row(
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
                                hint: Text(selectedOption ?? 'Recherche par :'),
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
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
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
                                  elevation: 3, // Élévation du bouton
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
                                  elevation: 3, // Élévation du bouton
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
    );
  }
}
