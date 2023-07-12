import 'dart:convert';
import 'package:flutter/material.dart';
import '../components/image_picker_component.dart';
import '../model/model.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../user_state.dart';
import 'package:bcrypt/bcrypt.dart';

class Parametre extends StatefulWidget {
  Parametre({
    super.key,
  });

  @override
  _ParametreState createState() => _ParametreState();
}

class _ParametreState extends State<Parametre> {
  TextEditingController cin = TextEditingController();
  TextEditingController nom = TextEditingController();
  TextEditingController prenom = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController telephone = TextEditingController();
  TextEditingController image = TextEditingController();
  TextEditingController motDePasse = TextEditingController();
  TextEditingController nouveauMotDePasse = TextEditingController();
  TextEditingController confirmerMotDePasse = TextEditingController();
  TextEditingController motDePasseNouveau = TextEditingController();

  bool imageChanged = false;

  bool checkFields() {
    return cin.text.isNotEmpty &&
        nom.text.isNotEmpty &&
        prenom.text.isNotEmpty &&
        email.text.isNotEmpty &&
        motDePasse.text.isNotEmpty &&
        telephone.text.isNotEmpty;
  }

  Future<void> sendRequest(BuildContext context) async {
    var userState = Provider.of<UserState>(context, listen: false);
    if (!checkFields()) {
      // Afficher un message d'erreur pour les champs obligatoires manquants
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Erreur',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Veuillez remplir tous les champs obligatoires.',
              style: TextStyle(
                fontSize: 16.0,
              ),
              textAlign: TextAlign.center,
            ),
            actions: [
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
              ),
            ],
          );
        },
      );
      return;
    }
    try {
      var url = Uri.parse(
          'http://localhost:4000/api/users/${userState.connectedUser?.id}');
      var formData = http.MultipartRequest('POST', url);
      formData.fields.addAll({
        'cin': cin.text.trim(),
        'nom': nom.text.trim(),
        'prenom': prenom.text.trim(),
        'telephone': telephone.text.trim(),
        'email': email.text.trim(),
        'motDePasse': motDePasse.text.trim(),
        'role': userState.connectedUser!.role.toString(),
      });

      if (imageChanged) {
        formData.files.add(await http.MultipartFile.fromPath(
          'image',
          image.text.trim(),
        ));
      }

      var response = await formData.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        // await widget.afterSubmit();
        final body = await response.stream.bytesToString();
        var data = json.decode(body);
        userState.setUser("jwt", User.fromJson(data["user"]));
        final snackBar = SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.check,
                color: Colors.white,
              ),
              SizedBox(width: 8.0),
              Text(
                "Modification réussie",
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
        print(
            '\x1B[31mRequest failed with status: ${response.statusCode}\x1B[0m');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    final userState = Provider.of<UserState>(context, listen: false);
    super.initState();
    if (userState.connectedUser != null) {
      cin.text = userState.connectedUser!.cin;
      nom.text = userState.connectedUser!.nom;
      prenom.text = userState.connectedUser!.prenom;
      telephone.text = userState.connectedUser!.telephone;
      email.text = userState.connectedUser!.email;
      motDePasse.text = userState.connectedUser!.motDePasse;
      image.text = userState.connectedUser!.imagePath;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = Provider.of<UserState>(context);
    bool isMotDePasseIncorrect =
        false; // Variable pour vérifier si le mot de passe est incorrect

    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              height: 1050,
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              color: Colors.grey,
              child: Column(
                children: [
                  const SizedBox(height: 35),
                  Container(
                    color: Colors.white,
                    width: 1100,
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(Icons.person),
                              SizedBox(width: 5),
                              Text(
                                'Nom utilisateur ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(
                            width: 100), // Adjust the width as needed
                        ImagePickerComponent(
                          controller: image,
                          imagePath: userState.connectedUser!.imagePath ?? null,
                          onImageChange: () {
                            setState(() {
                              imageChanged = true;
                            });
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 220,
                              ),
                              Container(
                                width: 300,
                                child: TextFormField(
                                  controller: nom,
                                  decoration: InputDecoration(
                                    labelText: 'Nom',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 15.0,
                                      horizontal: 10.0,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              Container(
                                width: 300,
                                child: TextFormField(
                                  controller: prenom,
                                  decoration: InputDecoration(
                                    labelText: 'Prénom',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 15.0,
                                      horizontal: 10.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                            width: 100), // Adjust the width as needed
                        const SizedBox(width: 40), // Adjust the width as needed
                        const SizedBox(height: 15),

                        Row(
                          children: [
                            SizedBox(
                              width: 50,
                            ),
                            SizedBox(
                              width: 320,
                              child: TextFormField(
                                controller: email,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            SizedBox(
                              width: 320,
                              child: TextFormField(
                                controller: cin,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value?.length != 8) {
                                    return 'Veuillez entrer exactement 8 chiffres';
                                  }
                                  return null; // Renvoie null si l'entrée est valide
                                },
                                decoration: InputDecoration(
                                  labelText: 'CIN',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            SizedBox(
                              width: 320,
                              child: TextFormField(
                                controller: telephone,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9+-]')),
                                ],
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Téléphone',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const SizedBox(
                              width: 870,
                            ),
                            Container(
                              width: 180,
                              height: 55,
                              child: ElevatedButton(
                                onPressed: () {
                                  sendRequest(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.orange,
                                  onPrimary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Modifier',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 35),
                  Container(
                    width: 1100,
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(Icons.vpn_key),
                                SizedBox(width: 5),
                                Text(
                                  'Mot de passe',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Text(
                                  "  mot de passe ",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(
                                  width: 95,
                                ),
                                Container(
                                  width: 300,
                                  child: TextField(
                                    controller: motDePasseNouveau,
                                    decoration: const InputDecoration(
                                      hintText: "Entrez votre mot de passe",
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.blue,
                                          width: 2.0,
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Text(
                                  "  nouveau mot de passe ",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(
                                  width: 17,
                                ),
                                Container(
                                  width: 300,
                                  child: TextField(
                                    controller: nouveauMotDePasse,
                                    decoration: const InputDecoration(
                                      hintText: "Entrez votre mot de passe",
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.blue,
                                          width: 2.0,
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Text(
                                  "  Confirmer ",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(
                                  width: 120,
                                ),
                                Container(
                                  width: 300,
                                  child: TextField(
                                    controller: confirmerMotDePasse,
                                    decoration: const InputDecoration(
                                      hintText: "Confirmer votre mot de passe",
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.blue,
                                          width: 2.0,
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 870,
                              ),
                              Container(
                                width: 180,
                                height: 55,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (await verify(motDePasseNouveau.text,
                                        motDePasse.text)) {
                                      setState(() {
                                        isMotDePasseIncorrect = true;
                                      });
                                    } else if (confirmerMotDePasse.text !=
                                        nouveauMotDePasse.text) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                              'Erreur de mot de passe',
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red,
                                              ),
                                            ),
                                            content: Text(
                                              'Le mot de passe de confirmation ne correspond pas au nouveau mot de passe.',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.black,
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                child: Text(
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
                                    } else {
                                      sendRequest(context);
                                    }

                                    if (isMotDePasseIncorrect) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                              'Erreur de mot de passe',
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red,
                                              ),
                                            ),
                                            content: const Text(
                                              'Le mot de passe saisi est incorrect.',
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
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary:
                                        Colors.orange, // Couleur de fond orange
                                    onPrimary: Colors
                                        .white, // Couleur de texte blanche
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          8), // Bordure circulaire
                                    ),
                                  ),
                                  child: const Text(
                                    'Modifier',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  offset: Offset(0, 2),
                                ),
                              ],
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

bool verify(String newPassword, String currentPassword) {
  return true;
}
