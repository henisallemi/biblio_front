import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:projetbiblio/model/model.dart';
import 'package:projetbiblio/roles.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CheckLivre extends StatefulWidget {
  Livre? livre;
  Function afterSubmit;
  CheckLivre({super.key, required this.livre, required this.afterSubmit});

  @override
  State<CheckLivre> createState() => _CheckLivreState();
}

class _CheckLivreState extends State<CheckLivre> {
  String? selectedAdherent = '';
  List<User> adherentList = [];
  bool isLoading = true;
  TextEditingController dateEmprunt = TextEditingController();
  TextEditingController dateDeRetour = TextEditingController();

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
      "ouvrage": widget.livre?.ouvrage?.id,
      "dateDeRetour": dateDeRetour.text.trim(),
    });

    try {
      var response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        closeForm();
        widget.afterSubmit();
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
    DateTime? selectedDate;

    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate ?? DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
        locale: const Locale("fr", 'FR'),
      );

      if (picked != null && picked != selectedDate) {
        setState(() {
          selectedDate = DateTime(picked.year, picked.month, picked.day);

          // Utilisez le format 'yyyy-MM-dd' pour extraire la date sans les heures
          dateDeRetour.text = DateFormat('yyyy-MM-dd').format(selectedDate!);
        });
      }
    }

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
                                '"${widget.livre?.ouvrage.titre}"',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                " :",
                                style: TextStyle(
                                  color: Colors.black,
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
                                        'CIN :' +
                                            user.cin +
                                            ', ' +
                                            user.prenom +
                                            ' ' +
                                            user.nom,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              SizedBox(
                                width: 850,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Text(
                                '  Date de retour de ce livre : ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                // Ajustez la hauteur selon vos besoins
                                child: TextFormField(
                                  controller: dateDeRetour,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  readOnly:
                                      true, // Définissez le champ en lecture seule
                                  onTap: () => _selectDate(
                                      context), // Ouvrir le DatePickerDialog lorsqu'il est cliqué
                                  decoration: InputDecoration(
                                    labelText: 'Date de retour du livre',
                                    border: OutlineInputBorder(),
                                    suffixIcon: RichText(
                                      text: TextSpan(
                                        text:
                                            '*', // Caractère "*" à afficher en rouge
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize:
                                              23, // Couleur rouge pour le "*"
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Ajoutez un initialValue pour afficher la date au format 'yyyy-MM-dd'
                                  // Utilisez un formatage pour afficher la date sans les heures
                                  initialValue: selectedDate != null
                                      ? DateFormat('yyyy-MM-dd')
                                          .format(selectedDate!)
                                      : null,
                                ),
                              ),
                              SizedBox(
                                width: 800,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              SizedBox(width: 10),
                              Text(
                                'Le nombre d\'exemplaires de ce livre : ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '${widget.livre?.ouvrage.nombreExemplaire}',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Text(
                                '  Le nombre de ce livre qui est actuellement disponible : ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                              SizedBox(),
                              Text(
                                '${widget.livre?.ouvrage.nombreDisponible}',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto',
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
