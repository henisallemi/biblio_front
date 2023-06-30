import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projetbiblio/model/model.dart';
import 'package:projetbiblio/roles.dart';

// ignore: must_be_immutable
class UserFormulaire extends StatefulWidget {
  User? user;
  int role = Roles.adherant;
  Function afterSubmit;
  UserFormulaire(
      {super.key, this.user, required this.role, required this.afterSubmit});

  @override
  State<UserFormulaire> createState() => _UserFormulaireState();
}

class _UserFormulaireState extends State<UserFormulaire> {
  TextEditingController cin = TextEditingController();
  TextEditingController nom = TextEditingController();
  TextEditingController prenom = TextEditingController();
  TextEditingController motDePasse = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController telephone = TextEditingController();
  TextEditingController nombreLivrePrendre = TextEditingController();

  bool checkFields() {
    return cin.text.isNotEmpty &&
        nom.text.isNotEmpty &&
        prenom.text.isNotEmpty &&
        email.text.isNotEmpty &&
        motDePasse.text.isNotEmpty &&
        telephone.text.isNotEmpty;
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
      'cin': cin.text.trim(),
      'nom': nom.text.trim(),
      'prenom': prenom.text.trim(),
      'telephone': telephone.text.trim(),
      'email': email.text.trim(),
      'motDePasse': motDePasse.text.trim(),
      'role': widget.user?.role ?? widget.role,
      "nombreLivrePrendre": nombreLivrePrendre.text.trim(),
    });

    try {
      var response = updateMode
          ? await http.put(
              Uri.parse('http://localhost:4000/api/users/${widget.user?.id}'),
              headers: headers,
              body: body)
          : await http.post(Uri.parse('http://localhost:4000/api/users'),
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
                    : 'Adhérant ajouté avec succès',
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
    var isUpdateMode = widget.user != null;

    void closeForm() {
      Navigator.pop(context); // Revenir en arrière
    }

    if (isUpdateMode) {
      cin.text = widget.user?.cin ?? "";
      nom.text = widget.user?.nom ?? "";
      prenom.text = widget.user?.prenom ?? "";
      nombreLivrePrendre.text =
          widget.user?.nombreLivrePrendre.toString() ?? "";
      telephone.text = widget.user?.telephone ?? "";
      email.text = widget.user?.email ?? "";
      motDePasse.text = widget.user?.motDePasse ?? "";
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
                  isUpdateMode ? "Modifier Adhérent" : 'Ajouter un adhérent',
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
                    controller: cin,
                    inputFormatters: [
                      FilteringTextInputFormatter
                          .digitsOnly, // Accepter uniquement des chiffres
                    ],
                    keyboardType:
                        TextInputType.number, // Utiliser le clavier numérique
                    decoration: InputDecoration(
                      labelText: 'CIN',
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
                    controller: nom,
                    decoration: InputDecoration(
                      labelText: 'Nom ',
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
                    controller: prenom,
                    decoration: InputDecoration(
                      labelText: 'Prenom ',
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
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: email,
                    decoration: InputDecoration(
                      labelText: 'Email ',
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
                    controller: motDePasse,
                    decoration: InputDecoration(
                      labelText: 'Mot de passe ',
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
                      controller: nombreLivrePrendre,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'nombre de  Livre Prendre ',
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
                Expanded(
                  child: Container(
                    height: 50, // Ajustez la hauteur selon vos besoins
                    child: TextFormField(
                      controller: telephone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Telephone ',
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

    if (widget.user != null) {
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
