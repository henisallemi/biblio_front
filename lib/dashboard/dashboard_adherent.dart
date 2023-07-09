import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projetbiblio/model/model.dart';
import 'package:http/http.dart' as http;
import 'package:projetbiblio/types.dart';
import 'dart:async';
import 'package:projetbiblio/user_state.dart';
import 'package:provider/provider.dart';

class DashbordAdherent extends StatefulWidget {
  const DashbordAdherent({Key? key}) : super(key: key);

  @override
  State<DashbordAdherent> createState() => _DashbordAdherentState();
}

class _DashbordAdherentState extends State<DashbordAdherent> {
  History? history;
  String selectedOption = "1";
  int page = 1;
  int limit = 15;
  int totalCount = 0;
  bool isLoading = true;
  bool isDataLoaded = false;

  Future<void> fetchDashbordAdherent() async {
    final userState = Provider.of<UserState>(context, listen: false);

    setState(() {
      isLoading = true;
    });

    var url = Uri.parse(
        'http://localhost:4000/api/users/history/${userState.connectedUser!.id}?page=$page&limit=$limit');

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          history = History.fromJson(data["history"]);
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
    fetchDashbordAdherent();
  }

  void nextPage() {
    setState(() {
      if (page < (totalCount / limit).ceil()) {
        page++;
        fetchDashbordAdherent();
      }
    });
  }

  void previousPage() {
    setState(() {
      if (page > 1) {
        page--;
        fetchDashbordAdherent();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final int totalPages = (totalCount / limit).ceil();
    final userState = Provider.of<UserState>(context);

    if (history == null) {
      return Row(
        children: [],
      );
    }

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
                              Icon(Icons.insert_chart_outlined),
                              SizedBox(width: 5),
                              Text(
                                'Statistiques',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 35,
                            ),
                            Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 350,
                                    height: 150,
                                    color: Colors.lightBlue,
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 35,
                                          width: 400,
                                          color: Colors.black,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '  Livre emprunter',
                                                style: TextStyle(
                                                  fontSize: 23,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors
                                                      .white, // Titre en blanc
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.book,
                                              color: Colors.white,
                                              size:
                                                  48, // Taille de l'icône ajustée
                                            ),
                                            SizedBox(width: 20),
                                            Text(
                                              history!.nombreLivres.toString(),
                                              style: TextStyle(
                                                fontSize: 48,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 70,
                            ),
                            Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 350,
                                    height: 150,
                                    color: Colors.indigo,
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 35,
                                          width: 400,
                                          color: Colors.black,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '  Article emprunter',
                                                style: TextStyle(
                                                  fontSize: 23,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors
                                                      .white, // Titre en blanc
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.article,
                                              color: Colors.white,
                                              size:
                                                  48, // Taille de l'icône ajustée
                                            ),
                                            SizedBox(width: 20),
                                            Text(
                                              history!.nombreArticles
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 48,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 70,
                            ),
                            Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 350,
                                    height: 150,
                                    color: Colors.grey[800],
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 35,
                                          width: 400,
                                          color: Colors.black,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '  Revue emprunter',
                                                style: TextStyle(
                                                  fontSize: 23,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors
                                                      .white, // Titre en blanc
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.library_books,
                                              color: Colors.white,
                                              size:
                                                  48, // Taille de l'icône ajustée
                                            ),
                                            SizedBox(width: 20),
                                            Text(
                                              history!.nombreRevues.toString(),
                                              style: TextStyle(
                                                fontSize: 48,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    color: Colors.white,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(Icons.history),
                                SizedBox(width: 5),
                                Text(
                                  'Historique des empruntes',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                    width:
                                        260), // Ajout d'un espacement avant la partie de recherche
                                // Icône de recherche

                                Container(
                                  width: 320,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons
                                          .search), // Icône de recherche à gauche du champ
                                      hintText: 'Titre de document',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Container(
                                  width: 120,
                                  height: 51,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    child: Text('Chercher'),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(Colors
                                              .red), // Couleur personnalisée
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isDataLoaded)
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
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 28,
                                  ),
                                  DataTable(
                                    columnSpacing:
                                        140, // Espacement horizontal entre les colonnes si nécessaire
                                    headingRowColor: MaterialStateColor
                                        .resolveWith((states) => Colors
                                            .red), // Couleur de la ligne d'en-tête
                                    dataRowColor:
                                        MaterialStateColor.resolveWith(
                                            (states) => Colors.white),

                                    columns: const [
                                      DataColumn(
                                        label: SizedBox(
                                          width: 120,
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
                                          width: 120,
                                          child: Text(
                                            'Éditeur',
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
                                            'Type de document',
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
                                            "Date d'emprunte",
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
                                            'Date retour',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                    rows: history!.items
                                        .map((item) => DataRow(
                                              cells: [
                                                DataCell(
                                                    Text(item.ouvrage.titre)),
                                                DataCell(
                                                    Text(item.ouvrage.editeur)),
                                                DataCell(Text(item.type ==
                                                        Types.livre
                                                    ? "Livre"
                                                    : item.type == Types.article
                                                        ? "Article"
                                                        : "Revue")),
                                                DataCell(Text(
                                                    DateFormat('yyyy-MM-dd')
                                                        .format(item.emprunt
                                                            .dateEmprunt!)
                                                        .toString())),
                                                DataCell(Text(
                                                    DateFormat('yyyy-MM-dd')
                                                        .format(item.emprunt
                                                                .returnedAt ??
                                                            item.emprunt
                                                                .dateDeRetour!)
                                                        .toString())),
                                              ],
                                            ))
                                        .toList(),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
