import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projetbiblio/model/model.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../components/image_picker_component.dart';
import '../roles.dart';
import '../user_state.dart';

class UserFormulaire extends StatefulWidget {
  User? user;
  int role = Roles.adherant;
  Function afterSubmit;
  UserFormulaire({
    Key? key,
    this.user,
    required this.role,
    required this.afterSubmit,
  });

  @override
  _UserFormulaireState createState() => _UserFormulaireState();
}

class _UserFormulaireState extends State<UserFormulaire> {
  TextEditingController cin = TextEditingController();
  TextEditingController nom = TextEditingController();
  TextEditingController prenom = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController telephone = TextEditingController();
  TextEditingController motDePasse = TextEditingController();
  TextEditingController image = TextEditingController();

  bool checkFields() {
    return cin.text.isNotEmpty &&
        nom.text.isNotEmpty &&
        prenom.text.isNotEmpty &&
        email.text.isNotEmpty &&
        motDePasse.text.isNotEmpty &&
        telephone.text.isNotEmpty;
  }

  String _allowedChars =
      "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*(),.?\":{}|<>";

  String generateRandomPassword(int length) {
    final random = Random();

    // Choisissez au hasard au moins un chiffre, une lettre minuscule, une lettre majuscule et un caractère spécial
    final requiredChars = [
      _allowedChars[random.nextInt(26)], // Une lettre minuscule
      _allowedChars[26 + random.nextInt(26)], // Une lettre majuscule
      _allowedChars[52 + random.nextInt(10)], // Un chiffre
      _allowedChars[62 + random.nextInt(22)] // Un caractère spécial
    ];

    // Générez les caractères restants aléatoirement
    final remainingLength = length - requiredChars.length;
    final remainingChars = List.generate(remainingLength,
        (_) => _allowedChars[random.nextInt(_allowedChars.length)]);

    // Mélangez les caractères requis et les caractères restants
    final passwordCharacters = requiredChars + remainingChars;
    passwordCharacters.shuffle();

    return passwordCharacters.join();
  }

  void generatePassword() {
    final motDePasseAleatoire = generateRandomPassword(8);
    motDePasse.text = motDePasseAleatoire;
  }

  bool isEmailValid(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$');
    return regex.hasMatch(email);
  }

  Future<void> sendRequest(bool updateMode, BuildContext context) async {
    try {
      var url = updateMode
          ? Uri.parse('http://localhost:4000/api/users/${widget.user?.id}')
          : Uri.parse('http://localhost:4000/api/users');
      var formData = http.MultipartRequest('POST', url);

      formData.fields.addAll({
        'cin': cin.text.trim(),
        'nom': nom.text.trim(),
        'prenom': prenom.text.trim(),
        'telephone': telephone.text.trim(),
        'email': email.text.trim(),
        'motDePasse': motDePasse.text.trim(),
        'role': widget.user?.role.toString() ?? widget.role.toString(),
      });

      if (image.text.trim().isNotEmpty) {
        formData.files.add(await http.MultipartFile.fromPath(
          'image',
          image.text.trim(),
        ));
      }

      var response = await formData.send();

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
        print(
            '\x1B[31mRequest failed with status: ${response.statusCode}\x1B[0m');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<bool> showConfirmationDialog(BuildContext context, String role) async {
    bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            width: 500,
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.warning,
                  color: Colors.red,
                  size: 48.0,
                ),
                SizedBox(height: 16.0),
                Text(
                  "Confirmation",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  "Voulez-vous ajouter ce $role sans inclure d'image ?",
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: Text(
                        "Oui",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        primary: Colors.green,
                        padding: EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 24.0,
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    ElevatedButton(
                      child: Text(
                        "Non",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
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
              ],
            ),
          ),
        );
      },
    );

    return result ?? false; // Si result est null, retourne false par défaut
  }

  @override
  Widget build(BuildContext context) {
    var isUpdateMode = widget.user != null;

    final userState = Provider.of<UserState>(context);

    void closeForm() {
      Navigator.pop(context);
    }

    if (isUpdateMode) {
      cin.text = widget.user?.cin ?? "";
      nom.text = widget.user?.nom ?? "";
      prenom.text = widget.user?.prenom ?? "";
      telephone.text = widget.user?.telephone ?? "";
      email.text = widget.user?.email ?? "";
      motDePasse.text = widget.user?.motDePasse ?? "";
      image.text = widget.user?.imagePath ?? "";
    }

    var form = Container(
      height: 605,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.person),
                SizedBox(width: 10),
                Text(
                  isUpdateMode
                      ? 'Modifier ${widget.role == Roles.adherant ? "Adhérent" : "Admin"}'
                      : 'Ajouter ${widget.role == Roles.adherant ? "Adhérent" : "Admin"}',
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
            const SizedBox(height: 10),
            Row(
              children: [
                const SizedBox(
                  width: 530,
                ),
                if (isUpdateMode)
                  Image.network(
                    widget.user?.imagePath ?? '',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                if (!isUpdateMode)
                  ImagePickerComponent(
                    controller: image,
                  ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: cin,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(8),
                    ],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'CIN',
                      border: OutlineInputBorder(),
                      suffixIcon: const Text(
                        '*',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 23,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: email,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      suffixIcon: const Text(
                        '*',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 23,
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
                    controller: nom,
                    decoration: InputDecoration(
                      labelText: 'Nom',
                      border: OutlineInputBorder(),
                      suffixIcon: const Text(
                        '*',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 23,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 50,
                    child: TextFormField(
                      controller: telephone,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9+-]')),
                      ],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Téléphone',
                        border: OutlineInputBorder(),
                        suffixIcon: const Text(
                          '*',
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
                    controller: prenom,
                    decoration: InputDecoration(
                      labelText: 'Prénom',
                      border: OutlineInputBorder(),
                      suffixIcon: const Text(
                        '*',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 23,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                if (!isUpdateMode)
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: motDePasse,
                            decoration: InputDecoration(
                              labelText: 'Mot de passe',
                              border: OutlineInputBorder(),
                              suffixIcon: const Text(
                                '*',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 23,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: generatePassword,
                            icon: Icon(Icons.lock),
                            label: Text(
                              'Générer un mot de passe',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            SizedBox(height: 35),
            Center(
              child: ElevatedButton.icon(
                onPressed: () async {
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

                  if (cin.text.length != 8) {
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
                                  'Le CIN doit être composé de 8 chiffres.',
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

                  if (nom.text.length < 2 || prenom.text.length < 2) {
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
                                  'Le nom et le prénom doivent contenir au moins 2 caractères.',
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
                  if (!isEmailValid(email.text.trim())) {
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
                                  'Veuillez entrer un email valide.',
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

                  if (telephone.text.length < 8) {
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
                                  "Le numéro de téléphone n'est pas valide.",
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

                  if (motDePasse.text.length < 8 ||
                      !RegExp(r'[A-Z]').hasMatch(motDePasse.text) ||
                      !RegExp(r'[a-z]').hasMatch(motDePasse.text) ||
                      !RegExp(r'[0-9]').hasMatch(motDePasse.text) ||
                      !RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                          .hasMatch(motDePasse.text)) {
                    String errorMessage =
                        'Le mot de passe doit respecter les critères suivants :\n\n';
                    if (motDePasse.text.length < 8) {
                      errorMessage += '- Au moins 8 caractères\n';
                    }
                    if (!RegExp(r'[A-Z]').hasMatch(motDePasse.text)) {
                      errorMessage += '- Au moins une lettre majuscule\n';
                    }
                    if (!RegExp(r'[a-z]').hasMatch(motDePasse.text)) {
                      errorMessage += '- Au moins une lettre minuscule\n';
                    }
                    if (!RegExp(r'[0-9]').hasMatch(motDePasse.text)) {
                      errorMessage += '- Au moins un chiffre\n';
                    }
                    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                        .hasMatch(motDePasse.text)) {
                      errorMessage +=
                          '- Au moins un caractère spécial (comme !@#\$%^&*(),.?":{}|<>)\n';
                    }

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
                                  errorMessage,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 16.0),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
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

                  if (image.text.isEmpty) {
                    String roleText =
                        widget.role == Roles.adherant ? "adhérent" : "admin";
                    bool proceed =
                        await showConfirmationDialog(context, roleText);
                    if (proceed == null) {
                      return; // La boîte de dialogue a été fermée sans réponse
                    } else if (proceed) {
                      image.text = ''; // Effacer le champ de l'image
                    } else {
                      return; // Annuler l'action
                    }
                  }
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

    if (widget.user != null) {
      return form;
    }

    return Row(
      children: [
        Expanded(
          child: form,
        ),
      ],
    );
  }
}
