import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projetbiblio/livres/check_livre.dart';
import 'package:projetbiblio/livres/affichier_livre.dart';
import 'package:projetbiblio/livres/livres_formulaire.dart';
import 'package:projetbiblio/livres/retour_livre.dart';
import 'package:projetbiblio/model/model.dart';
import 'package:http/http.dart' as http;
import 'package:projetbiblio/roles.dart';
import 'dart:async';

import 'package:projetbiblio/user_state.dart';
import 'package:provider/provider.dart';

class ListeLivres extends StatefulWidget {
  const ListeLivres({Key? key}) : super(key: key);

  @override
  State<ListeLivres> createState() => _ListeLivresState();
}

class _ListeLivresState extends State<ListeLivres> {
  TextEditingController recherche = TextEditingController();
  List<Livre> livres = [];
  String selectedOption = "1";
  int page = 1;
  int limit = 15;
  int totalCount = 0;
  bool isLoading = true;
  bool isDataLoaded = false;

  Future<void> fetchLivres() async {
    setState(() {
      isLoading = true;
    });

    var url = Uri.parse(
        'http://localhost:4000/api/livres?page=$page&limit=$limit&recherche=${recherche.text.trim()}&target=$selectedOption');

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          livres =
              List<Livre>.from(data['livres'].map((x) => Livre.fromJson(x)));
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
    fetchLivres();
  }

  void nextPage() {
    setState(() {
      if (page < (totalCount / limit).ceil()) {
        page++;
        fetchLivres();
      }
    });
  }

  void previousPage() {
    setState(() {
      if (page > 1) {
        page--;
        fetchLivres();
      }
    });
  }

  Future<void> deleteRequest(Livre livre) async {
    var url = Uri.parse('http://localhost:4000/api/livres/${livre.id}');

    try {
      var response = await http.delete(url);

      if (response.statusCode == 200) {
        await fetchLivres();

        final snackBar = SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.delete,
                color: Colors.white,
              ),
              SizedBox(width: 8.0),
              const Text(
                "Livre supprimé avec succès",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red, // Couleur rouge
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
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              title: Text(
                'Erreur ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.red,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: [
                        TextSpan(
                          text: 'Titre du livre : ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        TextSpan(
                          text: '"${livre.ouvrage.titre}"',
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Vous ne pouvez pas supprimer ce livre.'),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey[300],
                    onPrimary: Colors.black,
                  ),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final int totalPages = (totalCount / limit).ceil();
    final userState = Provider.of<UserState>(context);

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
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(Icons.search),
                              SizedBox(width: 5),
                              Text(
                                'Chercher un livre',
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
                                    child: Text('Titre'),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: "2",
                                    child: Text('Auteur'),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: "3",
                                    child: Text('Année'),
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
                                onPressed: fetchLivres,
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
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Icon(Icons.list_alt),
                                  SizedBox(width: 5),
                                  Text(
                                    'Liste des livres disponibles',
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
                                    ...(userState.connectedUser?.role ==
                                            Roles.admin
                                        ? [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child:
                                                      Container(), // Cet espace vide occupera tout l'espace disponible dans le Row
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      right: 80.0),
                                                  child: ElevatedButton.icon(
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return FractionallySizedBox(
                                                            child: Dialog(
                                                              // Contenu de la boîte de dialogue ici
                                                              child: Container(
                                                                child:
                                                                    LivreFormulaire(
                                                                  afterSubmit: () =>
                                                                      fetchLivres(),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                    icon: const Icon(Icons
                                                        .library_add), // Icône à afficher
                                                    label: const Text(
                                                      'Ajouter un livre',
                                                      style: TextStyle(
                                                        fontSize: 18.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: 'Roboto',
                                                      ),
                                                    ),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary: Colors.green,
                                                      padding:
                                                          EdgeInsets.all(16.0),
                                                      minimumSize: Size(0, 70),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ]
                                        : []),
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
                                              'ISBN',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: SizedBox(
                                            width:
                                                180, // Largeur de la deuxième colonne (Titre)
                                            child: Text(
                                              'Titre',
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
                                              'Premier Auteur',
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
                                              'Année d\'\édition',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: SizedBox(
                                            width: 117,
                                            child: Text(
                                              'Nbr d\'exemplaire',
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

                                      rows: livres
                                          .map((livre) => DataRow(
                                                cells: [
                                                  DataCell(
                                                      Text(livre.ouvrage.isbn)),
                                                  DataCell(Text(
                                                      livre.ouvrage.titre)),
                                                  DataCell(Text(
                                                      livre.ouvrage.auteur1)),
                                                  DataCell(Text(DateFormat(
                                                          'yyyy-MM-dd')
                                                      .format(
                                                          livre.ouvrage.date!)
                                                      .toString())),
                                                  DataCell(Text(livre
                                                      .ouvrage.nombreExemplaire
                                                      .toString())),
                                                  DataCell(Row(
                                                    mainAxisAlignment: userState
                                                                .connectedUser
                                                                ?.role ==
                                                            Roles.admin
                                                        ? MainAxisAlignment
                                                            .start // Align icons to the start
                                                        : MainAxisAlignment
                                                            .center, // Center the visibility icon
                                                    children: [
                                                      // Empty container to occupy space
                                                      IconButton(
                                                        onPressed: () {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return FractionallySizedBox(
                                                                child: Dialog(
                                                                  child:
                                                                      Container(
                                                                    child: AffichierLivre(
                                                                        livre:
                                                                            livre),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        },
                                                        icon: const Icon(
                                                          Icons.visibility,
                                                          size: 32,
                                                          color: Colors.green,
                                                        ),
                                                      ),
                                                      ...(userState
                                                                  .connectedUser
                                                                  ?.role ==
                                                              Roles.admin
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
                                                                          // Dialog content here
                                                                          child:
                                                                              Container(
                                                                            child:
                                                                                LivreFormulaire(
                                                                              livre: livre,
                                                                              afterSubmit: () => fetchLivres(),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                icon:
                                                                    const Icon(
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
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return AlertDialog(
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(5.0),
                                                                        ),
                                                                        title:
                                                                            Text(
                                                                          'Confirmation de suppression du livre',
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize:
                                                                                18,
                                                                          ),
                                                                        ),
                                                                        content:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            RichText(
                                                                              text: TextSpan(
                                                                                style: DefaultTextStyle.of(context).style,
                                                                                children: [
                                                                                  TextSpan(
                                                                                    text: 'Titre du livre : ',
                                                                                    style: TextStyle(
                                                                                      fontWeight: FontWeight.bold,
                                                                                      fontSize: 16,
                                                                                    ),
                                                                                  ),
                                                                                  TextSpan(
                                                                                    text: '"${livre.ouvrage.titre}"',
                                                                                    style: const TextStyle(
                                                                                      color: Colors.red,
                                                                                      fontWeight: FontWeight.bold,
                                                                                      fontSize: 18,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            const SizedBox(height: 20),
                                                                            const Text('Êtes-vous sûr de vouloir supprimer ce livre ?'),
                                                                          ],
                                                                        ),
                                                                        actions: [
                                                                          ElevatedButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                            style:
                                                                                ElevatedButton.styleFrom(
                                                                              primary: Colors.grey[300],
                                                                              onPrimary: Colors.black,
                                                                            ),
                                                                            child:
                                                                                const Text('Annuler'),
                                                                          ),
                                                                          ElevatedButton(
                                                                            onPressed:
                                                                                () {
                                                                              deleteRequest(livre);
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                            style:
                                                                                ElevatedButton.styleFrom(
                                                                              primary: Colors.red,
                                                                              onPrimary: Colors.white,
                                                                            ),
                                                                            child:
                                                                                const Text('Supprimer'),
                                                                          ),
                                                                        ],
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons.delete,
                                                                  size: 32,
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                              ),
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
                                                                          // Dialog content here
                                                                          child: Container(
                                                                              height: 400,
                                                                              width: 800,
                                                                              child: CheckLivre(
                                                                                livre: livre,
                                                                                afterSubmit: () => fetchLivres(),
                                                                              )),
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .check_box,
                                                                  size:
                                                                      32, // Taille de l'icône
                                                                  color: Colors
                                                                      .green, // Couleur de l'icône
                                                                ),
                                                              ),
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
                                                                          // Dialog content here
                                                                          child: Container(
                                                                              child: RetourLivre(
                                                                            livre:
                                                                                livre,
                                                                            afterSubmit: () =>
                                                                                fetchLivres(),
                                                                          )),
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .add_alarm_outlined,
                                                                  size:
                                                                      32, // Taille de l'icône
                                                                  color: Colors
                                                                      .indigo, // Couleur de l'icône
                                                                ),
                                                              ),
                                                            ]
                                                          : []),
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
                                          icon: const Icon(Icons.arrow_back),
                                          color: Colors.blue,
                                          disabledColor: Colors.grey,
                                        ),
                                        const SizedBox(width: 16),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: Colors.blue,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          child: Text(
                                            'Page $page/$totalPages',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
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
                                    const SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                ),
                              ),
                            if (isLoading && !isDataLoaded)
                              Container(
                                height: 200,
                                alignment: Alignment.center,
                                child: const CircularProgressIndicator(),
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
