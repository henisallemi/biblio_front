import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:projetbiblio/connect/from_Screen.dart';
import 'package:http/http.dart' as http;

class InscrireUtilisateur extends StatefulWidget {
  const InscrireUtilisateur({super.key});

  @override
  State<InscrireUtilisateur> createState() => _InscrireUtilisateurState();
}

class _InscrireUtilisateurState extends State<InscrireUtilisateur> {
  final _fromfield = GlobalKey<FormState>();
  final nom = TextEditingController();
  final prenom = TextEditingController();
  final email = TextEditingController();
  final passController = TextEditingController();
  final passController2 = TextEditingController();
  bool passToggle = true;

  void sendData() async {
    var url = Uri.parse('http://localhost:4000/api/users');
    var headers = {'Content-Type': 'application/json'};
    var body = json.encode({
      'nom': nom.text,
      "prenom": prenom.text,
      "email": email.text,
      "motDePasse": "1234"
    });

    try {
      var response = await http.post(url, headers: headers, body: body);
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
    return Scaffold(
      key: _fromfield,
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
        child: Form(
          child: Column(
            children: [
              Image.asset(
                "images/forms.png",
                height: 150,
                width: 200,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      keyboardType: TextInputType.name,
                      controller: nom,
                      decoration: const InputDecoration(
                        labelText: "Nom",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.percent),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Veuillez entrer votre nom";
                        } else if (nom.toString().length < 2) {
                          return "Veuillez entrer un nom valide";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Flexible(
                    child: TextFormField(
                      keyboardType: TextInputType.name,
                      controller: prenom,
                      decoration: const InputDecoration(
                        labelText: "Prénom",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.percent_outlined),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Veuillez entrer votre prénom";
                        } else if (prenom.toString().length < 2) {
                          return "Veuillez entrer un prénom valide";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: email,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  bool emailValid = RegExp(
                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                      .hasMatch(value!);
                  if (value.isEmpty) {
                    return "Veuillez saisir une adresse e-mail";
                  } else if (!emailValid) {
                    return "Veuillez saisir une adresse e-mail valide";
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                controller: passController,
                obscureText: passToggle,
                decoration: InputDecoration(
                  labelText: "Entrer le mot de passe",
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: InkWell(
                    onTap: () {
                      setState(() {
                        passToggle = !passToggle;
                      });
                    },
                    child: Icon(
                        passToggle ? Icons.visibility : Icons.visibility_off),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Entrer le mot de passe";
                  } else if (passToggle.toString().length < 6) {
                    return "La longueur du mot de passe doit être supérieure à 6 caractères";
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                controller: passController2,
                obscureText: passToggle,
                decoration: InputDecoration(
                  labelText: "Entrer le mot de passe",
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: InkWell(
                    onTap: () {
                      setState(() {
                        passToggle = !passToggle;
                      });
                    },
                    child: Icon(
                        passToggle ? Icons.visibility : Icons.visibility_off),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Entrer le mot de passe";
                  } else if (passController2.toString().length < 6) {
                    return "Confirmez le mot de passe";
                  }
                  return null;
                },
              ),
              InkWell(
                onTap: sendData,
                child: Container(
                  height: 50,
                  width: 20,
                  decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text(
                      "créer un compte",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Vous avez déjà un compte?",
                    style: TextStyle(fontSize: 17),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FormScreen()),
                      );
                    },
                    child: const Text(
                      "Connexion",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      )),
    );
  }
}
