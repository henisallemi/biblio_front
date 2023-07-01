import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projetbiblio/model/model.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class ArticleFormulaire extends StatefulWidget {
  Artilce? artilce;
  Function afterSubmit;
  ArticleFormulaire({super.key, this.artilce, required this.afterSubmit});

  @override
  State<ArticleFormulaire> createState() => _ArticleFormulaireState();
}

class _ArticleFormulaireState extends State<ArticleFormulaire> {
  TextEditingController titre = TextEditingController();
  TextEditingController editeur = TextEditingController();
  TextEditingController nombreExemplaire = TextEditingController();
  TextEditingController annee = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController auteur1 = TextEditingController();
  TextEditingController auteur2 = TextEditingController();
  TextEditingController conference = TextEditingController();
  bool checkFields() {
    return titre.text.isNotEmpty &&
        editeur.text.isNotEmpty &&
        auteur1.text.isNotEmpty &&
        date.text.isNotEmpty &&
        nombreExemplaire.text.isNotEmpty;
  }

  Future<void> sendRequest(bool updateMode, BuildContext context) async {
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

    var headers = {'Content-Type': 'application/json'};
    var body = json.encode({
      'titre': titre.text.trim(),
      'editeur': editeur.text.trim(),
      'annee': annee.text.trim(),
      'nombreExemplaire': nombreExemplaire.text.trim(),
      'date': date.text.trim(),
      "auteur1": auteur1.text.trim(),
      "auteur2": auteur2.text.trim(),
      "conference": conference.text.trim(),
    });

    try {
      var response = updateMode
          ? await http.put(
              Uri.parse(
                  'http://localhost:4000/api/articles/${widget.artilce?.id}'),
              headers: headers,
              body: body)
          : await http.post(Uri.parse('http://localhost:4000/api/articles'),
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
                    : 'Article ajouté avec succès',
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
    var isUpdateMode = widget.artilce != null;
    DateTime? selectedDate;

    void closeForm() {
      Navigator.pop(context); // Revenir en arrière
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

          // Utilisez le format 'yyyy-MM-dd' pour extraire la date sans les heures
          date.text = DateFormat('yyyy-MM-dd').format(selectedDate!);
        });
      }
    }

    if (isUpdateMode) {
      auteur1.text = widget.artilce?.ouvrage.auteur1 ?? "";
      auteur2.text = widget.artilce?.auteur2 ?? "";
      titre.text = widget.artilce?.ouvrage.titre ?? "";

      date.text = widget.artilce?.ouvrage?.date.toString() ?? "";
      nombreExemplaire.text =
          widget.artilce?.ouvrage.nombreExemplaire.toString() ?? "";
      annee.text = widget.artilce?.ouvrage.annee ?? "";
      editeur.text = widget.artilce?.ouvrage.editeur ?? "";
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
                const Icon(Icons.article),
                const SizedBox(width: 5),
                Text(
                  isUpdateMode ? "Modifier l'article" : 'Ajouter un article',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily:
                        'Roboto', // Remplacez 'Roboto' par la police souhaitée
                  ),
                ),
                const Text(
                  ' (* = obligatoire)',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily:
                        'Roboto', // Remplacez 'Roboto' par la police souhaitée
                  ),
                ),
                Spacer(),
                Visibility(
                  // Afficher l'icône uniquement si isUpdateMode est true
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
                    controller: titre,
                    inputFormatters: [
                      FilteringTextInputFormatter
                          .digitsOnly, // Accepter uniquement des chiffres
                    ],
                    keyboardType:
                        TextInputType.number, // Utiliser le clavier numérique
                    decoration: InputDecoration(
                      labelText: 'Titre',
                      border: OutlineInputBorder(),
                      suffixIcon: RichText(
                        text: TextSpan(
                          text: '*', // Caractère "*" à mettre en rouge
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 23, // Couleur rouge pour le "*"
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
                          text: '*', // Caractère "*" à mettre en rouge
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 23, // Couleur rouge pour le "*"
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
                    controller: editeur,
                    decoration: InputDecoration(
                      labelText: 'Editeur ',
                      border: OutlineInputBorder(),
                      suffixIcon: RichText(
                        text: TextSpan(
                          text: '*', // Caractère "*" à mettre en rouge
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 23, // Couleur rouge pour le "*"
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
                  child: Container(
                    height: 50, // Ajustez la hauteur selon vos besoins
                    child: TextFormField(
                      controller: date,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      readOnly: true, // Définissez le champ en lecture seule
                      onTap: () => _selectDate(
                          context), // Ouvrir le DatePickerDialog lorsqu'il est cliqué
                      decoration: InputDecoration(
                        labelText: 'Date d\'édition *',
                        border: OutlineInputBorder(),
                        suffixIcon: RichText(
                          text: TextSpan(
                            text: '*', // Caractère "*" à afficher en rouge
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 23, // Couleur rouge pour le "*"
                            ),
                          ),
                        ),
                      ),
                      // Ajoutez un initialValue pour afficher la date au format 'yyyy-MM-dd'
                      // Utilisez un formatage pour afficher la date sans les heures
                      initialValue: selectedDate != null
                          ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                          : null,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: conference,
                    decoration: InputDecoration(
                      labelText: 'Conférence',
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
                    height: 50, // Ajustez la hauteur selon vos besoins
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
                            text: '*', // Caractère "*" à mettre en rouge
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 23, // Couleur rouge pour le "*"
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
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

    if (widget.artilce != null) {
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
