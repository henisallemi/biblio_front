import 'package:flutter/material.dart';
import '../components/image_picker_component.dart';
import '../model/model.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:projetbiblio/roles.dart';
import 'package:provider/provider.dart';
import '../user_state.dart';

class Parametre extends StatefulWidget {
  final User? user;
  final int role = Roles.adherant;
  final Function afterSubmit;

  Parametre({
    Key? key,
    required this.afterSubmit,
    this.user,
  }) : super(key: key);

  @override
  _ParametreState createState() => _ParametreState();
}

class _ParametreState extends State<Parametre> {
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

  Future<void> sendRequest(bool updateMode, BuildContext context) async {
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
      var url = Uri.parse('http://localhost:4000/api/users/${widget.user?.id}');

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

      formData.files.add(await http.MultipartFile.fromPath(
        'image',
        image.text.trim(),
      ));

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

        Navigator.pop(context);
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
    super.initState();
    if (widget.user != null) {
      cin.text = widget.user!.cin ?? '';
      nom.text = widget.user!.nom ?? '';
      prenom.text = widget.user!.prenom ?? '';
      telephone.text = widget.user!.telephone ?? '';
      email.text = widget.user!.email ?? '';
      motDePasse.text = widget.user!.motDePasse ?? '';
      image.text = widget.user!.imagePath ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    var isUpdateMode = widget.user != null;
    final userState = Provider.of<UserState>(context);
    void closeForm() {
      Navigator.pop(context); // Revenir en arrière
    }

    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              height: 880,
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
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Expanded(
                                          child: TextFormField(
                                            controller: nom,
                                            decoration: InputDecoration(
                                              labelText: 'Nom',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                vertical: 15.0,
                                                horizontal: 10.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Espacement entre les deux TextFormField
                                      Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: TextFormField(
                                          controller: prenom,
                                          decoration: InputDecoration(
                                            labelText: 'Prénom',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            contentPadding:
                                                EdgeInsets.symmetric(
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
                                    width:
                                        100), // Espacement entre les TextFormField et l'image
                                ImagePickerComponent(
                                  controller: image,
                                  imagePath: widget.user?.imagePath ?? null,
                                ),
                                const SizedBox(
                                    width:
                                        40), // Espacement entre l'image et les autres éléments
                              ],
                            ),
                            SizedBox(height: 15),
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: email,
                                    decoration: InputDecoration(
                                      labelText: 'Email',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
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
                                Expanded(
                                  child: Container(
                                    height: 50,
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
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                              ],
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
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  primary:
                                      Colors.orange, // Couleur de fond orange
                                  onPrimary:
                                      Colors.white, // Couleur de texte blanche
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        8), // Bordure circulaire
                                  ),
                                ),
                                child: const Text(
                                  'Modifer',
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 35),
                  Container(
                    width: 1100,
                    child: Expanded(
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            Padding(
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
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text(
                                    "  mot de passe ",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 95,
                                  ),
                                  Container(
                                    width: 300,
                                    child: Expanded(
                                      child: TextField(
                                        decoration: InputDecoration(
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
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text(
                                    "  nouveau mot de passe ",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 17,
                                  ),
                                  Container(
                                    width: 300,
                                    child: Expanded(
                                      child: TextField(
                                        decoration: InputDecoration(
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
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text(
                                    "  Confirmer ",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 120,
                                  ),
                                  Container(
                                    width: 300,
                                    child: Expanded(
                                      child: TextField(
                                        decoration: InputDecoration(
                                          hintText:
                                              "Confirmer votre mot de passe",
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
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
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
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors
                                          .orange, // Couleur de fond orange
                                      onPrimary: Colors
                                          .white, // Couleur de texte blanche
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            8), // Bordure circulaire
                                      ),
                                    ),
                                    child: const Text(
                                      'Modifer',
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
                  ),
                  const SizedBox(height: 35),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
