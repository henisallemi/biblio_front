import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:projetbiblio/home/first_page.dart';
import 'package:projetbiblio/home/menu.dart';
import 'package:http/http.dart' as http;
import 'package:projetbiblio/model/model.dart';
import 'package:projetbiblio/user_state.dart';
import 'package:provider/provider.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _fromfield = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool passToggle = true;

  Future<void> connect(context) async {
    var url = Uri.parse('http://localhost:4000/api/users/login');
    var userState = Provider.of<UserState>(context, listen: false);
    var headers = {'Content-Type': 'application/json'};
    var body = json.encode({
      'email': emailController.text.trim(),
      "motDePasse": passController.text.trim()
    });

    try {
      var response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        userState.setUser("jwt", User.fromJson(data["user"]));
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FirstPage()),
        );
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
      appBar: AppBar(
        title: const Text("Connecter à cette bibliothèque"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
        child: Form(
          key: _fromfield,
          child: Column(
            children: [
              Image.asset(
                "images/avatar.jpg",
                height: 150,
                width: 200,
              ),
              const SizedBox(
                height: 40,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
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
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                controller: passController,
                obscureText: passToggle,
                decoration: InputDecoration(
                  labelText: "Mot de passe",
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
                    return "Enter Password";
                  } else if (passController.toString().length < 6) {
                    return "La longueur du mot de passe doit être supérieure à 6 caractères";
                  }
                },
              ),
              const SizedBox(
                height: 60,
              ),
              MaterialButton(
                onPressed: () {
                  connect(context);
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text(
                      "Connecter",
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
            ],
          ),
        ),
      )),
    );
  }
}
