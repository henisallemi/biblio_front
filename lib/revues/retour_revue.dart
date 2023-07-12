import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:projetbiblio/model/model.dart';
import 'package:projetbiblio/roles.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class RetourRevue extends StatefulWidget {
  Revue? revue;
  Function afterSubmit;
  RetourRevue({super.key, required this.revue, required this.afterSubmit});

  @override
  State<RetourRevue> createState() => _RetourRevueState();
}

class _RetourRevueState extends State<RetourRevue> {
  String? selectedAdherent;
  List<User> adherentList = [];
  bool isLoading = true;
  TextEditingController dateDeRetour2 = TextEditingController();
  bool checkFields() {
    return dateDeRetour2.text.isNotEmpty &&
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
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 48.0,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Erreur',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Veuillez remplir tous les champs obligatoires.',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.0),
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

    var url = Uri.parse('http://localhost:4000/api/ouvrages/return');

    var headers = {'Content-Type': 'application/json'};
    var body = json.encode({
      'adherant': int.parse(selectedAdherent ?? ""),
      "ouvrage": widget.revue?.ouvrage?.id,
      "returnedAt": dateDeRetour2.text.trim(),
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
                "L'article a été rendu avec succès",
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
          dateDeRetour2.text = DateFormat('yyyy-MM-dd').format(selectedDate!);
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
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.undo,
                              size: 24,
                              color: Colors.black,
                            ),
                            const SizedBox(width: 5),
                            const Text(
                              "Rends la revue intitulée ",
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
                              ":",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto',
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.close),
                              iconSize: 32,
                              color: Colors.blueGrey,
                              onPressed: () {
                                closeForm();
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
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
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.people_outline_sharp,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: DropdownButton<String>(
                                        value: selectedAdherent,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectedAdherent = newValue;
                                          });
                                        },
                                        items: [
                                          const DropdownMenuItem<String>(
                                            value: null,
                                            child: Text(
                                              'Sélectionnez un adhérent',
                                            ),
                                          ),
                                          ...adherentList
                                              .map<DropdownMenuItem<String>>(
                                            (User user) {
                                              return DropdownMenuItem<String>(
                                                value: user.id.toString(),
                                                child: Row(
                                                  children: [
                                                    Text('CIN: ${user.cin},'),
                                                    const SizedBox(width: 10),
                                                    Text(
                                                        '${user.prenom} ${user.nom}'),
                                                  ],
                                                ),
                                              );
                                            },
                                          ).toList(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            const Text(
                              'Date de retour de cette revue : ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto',
                              ),
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: dateDeRetour2,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                readOnly: true,
                                onTap: () => _selectDate(context),
                                decoration: InputDecoration(
                                  labelText: 'Date de retour de cette revue',
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors
                                            .grey), // Couleur du bord ajustée
                                  ),
                                  suffixIcon: Icon(
                                    Icons.calendar_today,
                                    color: Colors.grey,
                                  ),
                                ),
                                initialValue: selectedDate != null
                                    ? DateFormat('yyyy-MM-dd')
                                        .format(selectedDate!)
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              submit(closeForm);
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                              onPrimary: Colors.white,
                              minimumSize: Size(120.0, 50.0),
                            ),
                            child: const Text(
                              'Rends cette revue',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
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
