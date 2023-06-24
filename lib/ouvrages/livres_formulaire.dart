import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projetbiblio/model/model.dart';

// ignore: must_be_immutable
class LivreFormulaire extends StatefulWidget {
  Livre? livre;
  LivreFormulaire({super.key, this.livre});

  @override
  State<LivreFormulaire> createState() => _LivreFormulaireState();
}

class _LivreFormulaireState extends State<LivreFormulaire> {
  TextEditingController isbn = TextEditingController();
  TextEditingController auteur1 = TextEditingController();
  TextEditingController auteur2 = TextEditingController();
  TextEditingController titre = TextEditingController();

  Future<void> sendRequest(bool updateMode) async {
    var url = Uri.parse('http://localhost:4000/api/livres');
    var headers = {'Content-Type': 'application/json'};
    var body = json.encode({
      'isbn': isbn.text.trim(),
      "auteur1": auteur1.text.trim(),
      "auteur2": auteur2.text.trim(),
      "titre": titre.text.trim(),
    });

    try {
      var response = updateMode
          ? await http.put(url, headers: headers, body: body)
          : await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print(data);
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var isUpdateMode = widget.livre != null;

    if (isUpdateMode) {
      isbn.text = widget.livre?.ouvrage.isbn ?? "";
      auteur1.text = widget.livre?.ouvrage.auteur1 ?? "";
      auteur2.text = widget.livre?.auteur2 ?? "";
      titre.text = widget.livre?.ouvrage.titre ?? "";
    }

    var form = Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.book),
                SizedBox(width: 5),
                Text(
                  isUpdateMode ? "Modifier le livre" : 'Ajouter un livre',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  ' (* = obligatoire)',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.w100,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: isbn,
                    decoration: InputDecoration(
                      labelText: 'ISBN *',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: auteur1,
                    decoration: InputDecoration(
                      labelText: 'Auteur 1 * ',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: titre,
                    decoration: InputDecoration(
                      labelText: 'Titre d\'article *',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: auteur2,
                    decoration: InputDecoration(
                      labelText: 'Auteur 2',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Editeur *',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Auteur 3  ',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Année * ',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Auteur 4',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Date d\'édition * ',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Nombre d\éxemplaire *',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 35,
            ),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  sendRequest(isUpdateMode);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),

                  padding: EdgeInsets.all(16),
                  primary: Colors.green, // Changer la couleur en vert
                ),
                icon: Icon(Icons.add),
                label: Text(
                  isUpdateMode ? "Modifier" : 'Ajouter',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (widget.livre == null) {
      return form;
    }

    return Row(
      children: [
        const SizedBox(
          height: 5,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(40),
              width: 200,
              height: MediaQuery.of(context).size.height,
              color: Colors.grey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [form]),
            ),
          ),
        ),
      ],
    );
  }
}
