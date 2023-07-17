import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projetbiblio/model/model.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';

class LivreFormulaire extends StatefulWidget {
  Livre? livre;
  Function afterSubmit;
  LivreFormulaire({super.key, this.livre, required this.afterSubmit});

  @override
  State<LivreFormulaire> createState() => _LivreFormulaireState();
}

class _LivreFormulaireState extends State<LivreFormulaire> {
  TextEditingController isbn = TextEditingController();
  TextEditingController titre = TextEditingController();
  TextEditingController editeur = TextEditingController();
  TextEditingController nombreExemplaire = TextEditingController();
  TextEditingController nombreDisponible = TextEditingController();
  TextEditingController annee = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController auteur1 = TextEditingController();
  TextEditingController auteur2 = TextEditingController();
  TextEditingController auteur3 = TextEditingController();
  TextEditingController auteur4 = TextEditingController();
  TextEditingController description = TextEditingController();

  bool checkFields() {
    return isbn.text.isNotEmpty &&
        titre.text.isNotEmpty &&
        editeur.text.isNotEmpty &&
        auteur1.text.isNotEmpty &&
        date.text.isNotEmpty &&
        nombreExemplaire.text.isNotEmpty;
  }

  Future<void> sendRequest(bool updateMode, BuildContext context) async {
    if (!checkFields()) {
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
    if (isbn.text.length < 13) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Erreur',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            content: const Text(
              'Le numéro ISBN doit avoir 13 chiffres.',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
            actions: [
              TextButton(
                child: const Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }
    var headers = {'Content-Type': 'application/json'};
    var body = json.encode({
      'isbn': isbn.text.trim(),
      'titre': titre.text.trim(),
      'editeur': editeur.text.trim(),
      'annee': annee.text.trim(),
      'nombreExemplaire': nombreExemplaire.text.trim(),
      'nombreDisponible': nombreDisponible.text.trim(),
      'date': date.text.trim(),
      "auteur1": auteur1.text.trim(),
      "auteur2": auteur2.text.trim(),
      "auteur3": auteur3.text.trim(),
      "auteur4": auteur4.text.trim(),
      "description": description.text.trim(),
    });

    try {
      var response = updateMode
          ? await http.put(
              Uri.parse('http://localhost:4000/api/livres/${widget.livre?.id}'),
              headers: headers,
              body: body)
          : await http.post(Uri.parse('http://localhost:4000/api/livres'),
              headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        await widget.afterSubmit();
        final snackBar = SnackBar(
          content: Row(
            children: [
              Icon(
                updateMode ? Icons.check : Icons.add,
                color: Colors.white,
              ),
              SizedBox(width: 8.0),
              Text(
                updateMode
                    ? "Modification réussie"
                    : 'Livre ajouté avec succès',
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
        Navigator.pop(context);
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
    DateTime? selectedDate;

    void closeForm() {
      Navigator.pop(context);
    }

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

          date.text = DateFormat('yyyy-MM-dd').format(selectedDate!);
        });
      }
    }

    if (isUpdateMode) {
      isbn.text = widget.livre?.ouvrage.isbn ?? "";
      auteur1.text = widget.livre?.ouvrage.auteur1 ?? "";
      auteur2.text = widget.livre?.auteur2 ?? "";
      titre.text = widget.livre?.ouvrage.titre ?? "";
      auteur3.text = widget.livre?.auteur3 ?? "";
      auteur4.text = widget.livre?.auteur4 ?? "";
      date.text = widget.livre?.ouvrage.date != null
          ? DateFormat('yyyy-MM-dd')
              .format(widget.livre!.ouvrage.date as DateTime)
          : "";
      nombreExemplaire.text =
          widget.livre?.ouvrage.nombreExemplaire.toString() ?? "";
      nombreDisponible.text =
          widget.livre?.ouvrage.nombreDisponible.toString() ?? "";
      annee.text = widget.livre?.ouvrage.annee ?? "";
      editeur.text = widget.livre?.ouvrage.editeur ?? "";
      description.text = widget.livre?.ouvrage.description ?? "";
    }

    var form = Container(
      height: 530,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.book),
                SizedBox(width: 5),
                Text(
                  isUpdateMode ? "Modifier le livre" : 'Ajouter un livre',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
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
                Expanded(
                  child: TextFormField(
                    controller: isbn,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'ISBN',
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
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: auteur1,
                    decoration: InputDecoration(
                      labelText: 'Auteur 1 ',
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
                      labelText: 'Titre de livre ',
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
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: editeur,
                    decoration: InputDecoration(
                      labelText: 'Editeur ',
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
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: auteur3,
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
                  child: Container(
                    height: 50,
                    child: TextFormField(
                      controller: date,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      decoration: InputDecoration(
                        labelText: 'Date d\'édition *',
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
                          ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                          : null,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: auteur4,
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
                  child: Container(
                    height: 50,
                    child: TextFormField(
                      controller: nombreExemplaire,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Nombre d\'exemplaire *',
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
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: description,
                    decoration: InputDecoration(
                      labelText: 'Description du livre',
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
                  sendRequest(isUpdateMode, context);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(16),
                  primary: Colors.green,
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

    if (widget.livre != null) {
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
              padding: const EdgeInsets.all(10),
              height: 550,
              width: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [form],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
