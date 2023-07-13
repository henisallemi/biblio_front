import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:projetbiblio/Users/users_formulaire.dart';
import 'package:projetbiblio/livres/livres_formulaire.dart';
import 'package:projetbiblio/model/model.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:projetbiblio/roles.dart';
import 'package:projetbiblio/users/affichier_user.dart';

// ignore: must_be_immutable
class ListeUsers extends StatefulWidget {
  int role = Roles.adherant;
  ListeUsers({super.key, required this.role});

  @override
  State<ListeUsers> createState() => _ListeUsersState();
}

class _ListeUsersState extends State<ListeUsers> {
  TextEditingController recherche = TextEditingController();
  List<User> users = [];
  String selectedOption = "1";
  int page = 1;
  int limit = 15;
  int totalCount = 0;
  bool isLoading = true;
  bool isDataLoaded = false;

  Future<void> fetchUsers() async {
    setState(() {
      isLoading = true;
    });

    var url = Uri.parse(
        'http://localhost:4000/api/users?page=$page&limit=$limit&recherche=${recherche.text.trim()}&target=$selectedOption&role=${widget.role}');

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          users = List<User>.from(data['users'].map((x) => User.fromJson(x)));
          totalCount = data['totalCount'];
          isDataLoaded = true;
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

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  void nextPage() {
    setState(() {
      if (page < (totalCount / limit).ceil()) {
        page++;
        fetchUsers();
      }
    });
  }

  void previousPage() {
    setState(() {
      if (page > 1) {
        page--;
        fetchUsers();
      }
    });
  }

  Future<void> deleteRequest(User user) async {
    var url = Uri.parse('http://localhost:4000/api/users/${user.id}');

    try {
      var response = await http.delete(url);
      if (response.statusCode == 200) {
        await fetchUsers();
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final int totalPages = (totalCount / limit).ceil();

    return Row(
      children: [
        const SizedBox(
          height: 5,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              width: 200,
              height: MediaQuery.of(context).size.height,
              color: Colors.grey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(Icons.search),
                              SizedBox(width: 5),
                              Text(
                                'Chercher un ${widget.role == Roles.adherant ? "adhérent" : "admin"}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(15),
                          child: Row(
                            children: [
                              SizedBox(width: 30),
                              DropdownButton<String>(
                                value: selectedOption,
                                items: const [
                                  DropdownMenuItem<String>(
                                    value: "1",
                                    child: Text('cin'),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: "2",
                                    child: Text('nom'),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: "3",
                                    child: Text('prénom'),
                                  ),
                                ],
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedOption = value ?? '1';
                                  });
                                },
                                hint: Text(selectedOption),
                                underline: Container(
                                  height: 1,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(width: 30),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 7.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: TextField(
                                    controller: recherche,
                                    decoration: const InputDecoration(
                                      hintText: 'Rechercher...',
                                      border: InputBorder.none,
                                      icon: Icon(
                                        Icons.search,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 30),
                              ElevatedButton(
                                onPressed: fetchUsers,
                                child: const Text(
                                  'Rechercher',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.indigo,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 21, vertical: 21),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Icon(Icons.list_alt),
                                  SizedBox(width: 5),
                                  Text(
                                    'Liste des ${widget.role == Roles.adherant ? "adhérents" : "admins"} disponibles',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                            if (isDataLoaded)
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 28,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child:
                                              Container(), // Cet espace vide occupera tout l'espace disponible dans le Row
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(right: 80.0),
                                          child: ElevatedButton.icon(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return FractionallySizedBox(
                                                    child: Dialog(
                                                      // Contenu de la boîte de dialogue ici
                                                      child: Container(
                                                        child: UserFormulaire(
                                                          role: widget.role,
                                                          afterSubmit: () =>
                                                              fetchUsers(),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            icon: Icon(Icons
                                                .library_add), // Icône à afficher
                                            label: Text(
                                              'Ajouter un ${widget.role == Roles.adherant ? "adhérent" : "admin"}',
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Roboto',
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.green,
                                              padding: EdgeInsets.all(16.0),
                                              minimumSize: Size(0, 70),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 28,
                                    ),
                                    DataTable(
                                      columnSpacing:
                                          60, // Espacement horizontal entre les colonnes si nécessaire
                                      headingRowColor: MaterialStateColor
                                          .resolveWith((states) => Colors
                                              .indigoAccent), // Couleur de la ligne d'en-tête
                                      dataRowColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => Colors.white),
                                      columns: const [
                                        DataColumn(
                                          label: SizedBox(
                                            width:
                                                120, // Largeur de la première colonne (ISBN)
                                            child: Text(
                                              'CIN',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: SizedBox(
                                            width:
                                                200, // Largeur de la deuxième colonne (Titre)
                                            child: Text(
                                              'Nom',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: SizedBox(
                                            width:
                                                150, // Largeur de la troisième colonne (Auteur)
                                            child: Text(
                                              'Prénom',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: SizedBox(
                                            width:
                                                110, // Largeur de la quatrième colonne (Année)
                                            child: Text(
                                              'email',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: SizedBox(
                                            width: 100,
                                            child: Text(
                                              'Telephone',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: SizedBox(
                                            width:
                                                150, // Largeur de la sixième colonne (Actions)
                                            child: Center(
                                              child: Text(
                                                'Actions',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],

                                      rows: users
                                          .map((user) => DataRow(
                                                cells: [
                                                  DataCell(Text(user.cin)),
                                                  DataCell(Text(user.nom)),
                                                  DataCell(Text(user.prenom)),
                                                  DataCell(Text(
                                                      user.email.toString())),
                                                  DataCell(Text(user.telephone
                                                      .toString())),
                                                  DataCell(Row(
                                                    children: [
                                                      ...(user.role ==
                                                              Roles.adherant
                                                          ? [
                                                              IconButton(
                                                                onPressed: () {
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return FractionallySizedBox(
                                                                        child:
                                                                            Dialog(
                                                                          child:
                                                                              AffichierUser(
                                                                            user:
                                                                                user,
                                                                            key:
                                                                                widget.key,
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .visibility,
                                                                  size: 32,
                                                                  color: Colors
                                                                      .green,
                                                                ),
                                                              )
                                                            ]
                                                          : []),
                                                      IconButton(
                                                        onPressed: () {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return FractionallySizedBox(
                                                                child: Dialog(
                                                                  // Dialog content here
                                                                  child:
                                                                      Container(
                                                                    child:
                                                                        UserFormulaire(
                                                                      role: user
                                                                          .role,
                                                                      user:
                                                                          user,
                                                                      afterSubmit:
                                                                          fetchUsers,
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        },
                                                        icon: const Icon(
                                                          Icons.edit,
                                                          size:
                                                              32, // Taille de l'icône
                                                          color: Colors
                                                              .blue, // Couleur de l'icône
                                                        ),
                                                      ),
                                                      IconButton(
                                                        onPressed: () {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    'Confirmation de suppression d"utilisateur ${user.nom} ${user.prenom}'),
                                                                content:
                                                                    const Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Text(
                                                                        'Êtes-vous sûr de vouloir supprimer l"utilisateur suivant ?'),
                                                                    SizedBox(
                                                                        height:
                                                                            16),
                                                                  ],
                                                                ),
                                                                actions: <Widget>[
                                                                  TextButton(
                                                                    child: const Text(
                                                                        'Annuler'),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                  ),
                                                                  TextButton(
                                                                    child: const Text(
                                                                        'Supprimer'),
                                                                    onPressed:
                                                                        () {
                                                                      deleteRequest(
                                                                          user);
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                        },
                                                        icon: Icon(
                                                          Icons.delete,
                                                          size: 32,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                                ],
                                              ))
                                          .toList(),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          onPressed: (page > 1)
                                              ? previousPage as void Function()?
                                              : null,
                                          icon: Icon(Icons.arrow_back),
                                          color: Colors.blue,
                                          disabledColor: Colors.grey,
                                        ),
                                        SizedBox(width: 16),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: Colors.blue,
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          child: Text(
                                            'Page $page/$totalPages',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                        IconButton(
                                          onPressed: (page < totalPages)
                                              ? nextPage as void Function()?
                                              : null,
                                          icon: Icon(Icons.arrow_forward),
                                          color: Colors.blue,
                                          disabledColor: Colors.grey,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                ),
                              ),
                            if (isLoading && !isDataLoaded)
                              Container(
                                height: 200,
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(),
                              ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
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
