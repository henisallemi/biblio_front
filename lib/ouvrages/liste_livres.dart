import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:projetbiblio/model/model.dart';
import 'package:projetbiblio/ouvrages/book_table.dart';
import 'package:http/http.dart' as http;

class ListeLivres extends StatefulWidget {
  const ListeLivres({super.key});

  @override
  State<ListeLivres> createState() => _ListeLivresState();
}

class _ListeLivresState extends State<ListeLivres> {
  TextEditingController recherche = TextEditingController();
  List<Livre> livres = [];
  String selectedOption = "1";

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    var url = Uri.parse(
        'http://localhost:4000/api/livres?recherche=${recherche.text.trim()}&target=${selectedOption}');
    var headers = {'Content-Type': 'application/json'};

    var response = await http.get(url, headers: headers);
    var data = json.decode(response.body);
    setState(() {
      livres = Livre.fromJsonArray(data["livres"] ?? []);
    });
  }

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
                                items: const [
                                  DropdownMenuItem<String>(
                                    value: "1",
                                    child: Text('Titre'),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: "2",
                                    child: Text('Auteur'),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: "3",
                                    child: Text('Année'),
                                  ),
                                ],
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedOption = value ??
                                        '1'; // Mettez à jour la valeur sélectionnée
                                  });
                                },
                                hint: Text(selectedOption),
                                underline: Container(
                                  height: 1,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(width: 30),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
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
                                    controller: recherche,
                                    decoration: const InputDecoration(
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
                              const SizedBox(width: 30),
                              ElevatedButton(
                                onPressed: getData,
                                child: const Text(
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
                        BookTable(
                          livres: livres,
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
