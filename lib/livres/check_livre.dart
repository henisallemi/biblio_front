import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:projetbiblio/model/model.dart';
import 'package:projetbiblio/roles.dart';
import 'package:http/http.dart' as http;

class CheckLivre extends StatefulWidget {
  Livre? livre;
  CheckLivre({super.key, required this.livre});

  @override
  State<CheckLivre> createState() => _CheckLivreState();
}

class _CheckLivreState extends State<CheckLivre> {
  String? selectedAdherent = '';
  List<User> adherentList = [];
  bool isLoading = true;

  Future<void> getAdherents() async {
    setState(() {
      isLoading = true;
    });
    var url =
        Uri.parse('http://localhost:4000/api/users/role/${Roles.adherant}');

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          adherentList =
              List<User>.from(data['users'].map((x) => User.fromJson(x)));
          selectedAdherent = adherentList[0].id.toString();
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> submit(Function closeForm) async {
    var url = Uri.parse('http://localhost:4000/api/ouvrages/emprunt');

    var headers = {'Content-Type': 'application/json'};
    var body = json.encode({
      'adherant': int.parse(selectedAdherent ?? ""),
      "ouvrage": widget.livre?.ouvrage?.id
    });

    try {
      var response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        print("test");
        closeForm();
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getAdherents();
  }

  @override
  Widget build(BuildContext context) {
    void closeForm() {
      Navigator.pop(context); // Revenir en arrière
    }

    if (isLoading && adherentList.isEmpty) {
      return Row(
        children: [],
      );
    }

    return Row(
      children: [
        const SizedBox(height: 5),
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(3),
              height: 550,
              width: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 530,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.add,
                                size: 24,
                                color: Colors.black,
                              ),
                              const SizedBox(width: 5),
                              const Text(
                                "Prendre le livre intitulé ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                              Text(
                                "${widget.livre?.ouvrage.titre}",
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                ' (* = obligatoire)',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                              Spacer(),
                              Visibility(
                                visible: true,
                                child: IconButton(
                                  icon: Icon(Icons.close),
                                  iconSize: 32,
                                  color: Colors.blueGrey,
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
                              SizedBox(width: 10),
                              Text(
                                'Adhérent :',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: DropdownButton<String>(
                                  value: selectedAdherent,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedAdherent = newValue;
                                    });
                                  },
                                  items: adherentList
                                      .map<DropdownMenuItem<String>>(
                                          (User user) {
                                    return DropdownMenuItem<String>(
                                      value: user.id.toString(),
                                      child: Text(
                                        user.nom + ' ' + user.prenom,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              SizedBox(width: 10),
                              Text(
                                'Le nombre d\'exemplaires de ce livre : ${widget.livre?.ouvrage.nombreExemplaire}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Le nombre de ce livre qui est actuellement disponible : ${widget.livre?.ouvrage.nombreDisponible}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.note,
                                color: Colors.green,
                                size: 24.0,
                              ),
                              SizedBox(width: 8.0),
                              RichText(
                                text: const TextSpan(
                                  text:
                                      'Le nombre maximal d\'adhérents pouvant emprunter cinq livres.',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.black,
                                    decorationThickness: 1.5,
                                    decorationStyle: TextDecorationStyle
                                        .double, // Utilise une ligne en double
                                    // Ajuste l'espace entre le texte et la ligne de soulignement
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () => submit(closeForm),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                              onPrimary: Colors.white,
                              minimumSize: Size(120.0, 50.0),
                            ),
                            child: Text(
                              'Prendre ce livre',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
