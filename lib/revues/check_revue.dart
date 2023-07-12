import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:projetbiblio/model/model.dart';
import 'package:projetbiblio/roles.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CheckRevue extends StatefulWidget {
  Revue? revue;
  Function afterSubmit;
  CheckRevue({super.key, required this.revue, required this.afterSubmit});

  @override
  State<CheckRevue> createState() => _CheckRevueState();
}

class _CheckRevueState extends State<CheckRevue> {
  String? selectedAdherent;
  List<User> adherentList = [];
  bool isLoading = true;
  TextEditingController dateEmprunt = TextEditingController();
  TextEditingController dateDeRetour = TextEditingController();
  bool checkFields() {
    return dateDeRetour.text.isNotEmpty &&
        selectedAdherent != null &&
        selectedAdherent!.isNotEmpty;
  }

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
          // selectedAdherent = adherentList[0].id.toString();
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
    if (!checkFields()) {
      // Show error message for missing mandatory fields
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 48.0,
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Erreur',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Veuillez remplir tous les champs obligatoires.',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      primary: Colors.red,
                      padding: EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 24.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
      return;
    }
    if (widget.revue?.ouvrage?.nombreDisponible == 0) {
      print(widget.revue?.ouvrage?.nombreDisponible);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Revue non disponible',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Colors.red,
              ),
            ),
            content: Padding(
              padding: EdgeInsets.all(8.0), // Ajouter le padding souhaité
              child: Text(
                'La revue "${widget.revue?.ouvrage?.titre}" n\'est pas actuellement disponible dans la bibliothèque.',
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
            ),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.blue,
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
            ],
          );
        },
      );
    }

    var url = Uri.parse('http://localhost:4000/api/ouvrages/emprunt');

    var headers = {'Content-Type': 'application/json'};
    var body = json.encode({
      'adherant': int.parse(selectedAdherent ?? ""),
      "ouvrage": widget.revue?.ouvrage?.id,
      "dateDeRetour": dateDeRetour.text.trim(),
    });

    try {
      var response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        closeForm();
        await widget.afterSubmit();
        final snackBar = SnackBar(
          content: const Row(
            children: [
              Icon(
                Icons.check,
                color: Colors.white,
              ),
              SizedBox(width: 8.0),
              Text(
                'La revue a été pris avec succès',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16.0),
          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13.0),
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
    selectedAdherent = null;
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
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
                                "Prendre la revue intitulé ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                              Text(
                                '"${widget.revue?.ouvrage.titre}" ',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                '(* = obligatoire)',
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
                              const SizedBox(width: 10),
                              const Text(
                                'Adhérent :',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Stack(
                                    children: [
                                      DropdownButton<String>(
                                        value: selectedAdherent,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectedAdherent = newValue;
                                          });
                                        },
                                        items: [
                                          DropdownMenuItem<String>(
                                            value: null,
                                            child: Text(
                                                'Sélectionnez un adhérent'),
                                          ),
                                          ...adherentList
                                              .map<DropdownMenuItem<String>>(
                                            (User user) {
                                              return DropdownMenuItem<String>(
                                                value: user.id.toString(),
                                                child: IntrinsicWidth(
                                                  child: Row(
                                                    children: [
                                                      Text('CIN: ${user.cin},'),
                                                      SizedBox(width: 5),
                                                      Text(
                                                        '${user.prenom} ${user.nom}',
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ).toList(),
                                        ],
                                      ),
                                      Positioned(
                                        right: 8.0,
                                        child: RichText(
                                          text: TextSpan(
                                            text: '*',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 23,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            child: Row(
                              children: [
                                Text(
                                  '  Date de retour de cette revue : ',
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
                                Container(
                                  width: 300,
                                  child: Expanded(
                                    child: TextFormField(
                                      controller: dateDeRetour,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      readOnly: true,
                                      onTap: () => _selectDate(context),
                                      decoration: InputDecoration(
                                        labelText: 'Date de retour de la revue',
                                        border: OutlineInputBorder(),
                                        suffixIcon: RichText(
                                          text: TextSpan(
                                            text: '*',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 23,
                                            ),
                                          ),
                                        ),
                                      ),
                                      initialValue: selectedDate != null
                                          ? DateFormat('yyyy-MM-dd')
                                              .format(selectedDate!)
                                          : null,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              SizedBox(width: 10),
                              const Text(
                                'Le nombre d\'exemplaires de cette revue : ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '${widget.revue?.ouvrage.nombreExemplaire}',
                                style: const TextStyle(
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
                              const Text(
                                '  Le nombre de cette revue qui est actuellement disponible : ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                              SizedBox(),
                              Text(
                                '${widget.revue?.ouvrage.nombreDisponible}',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton(
                            onPressed: () {
                              submit(closeForm);
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                              onPrimary: Colors.white,
                              minimumSize: Size(120.0, 50.0),
                            ),
                            child: Text(
                              'Prendre cette revue',
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
