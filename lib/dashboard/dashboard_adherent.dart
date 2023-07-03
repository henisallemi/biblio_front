import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projetbiblio/livres/check_livre.dart';
import 'package:projetbiblio/livres/affichier_livre.dart';
import 'package:projetbiblio/livres/livres_formulaire.dart';
import 'package:projetbiblio/model/model.dart';
import 'package:http/http.dart' as http;
import 'package:projetbiblio/roles.dart';
import 'dart:async';
import 'package:projetbiblio/user_state.dart';
import 'package:provider/provider.dart';

class DashbordAdherent extends StatefulWidget {
  const DashbordAdherent({Key? key}) : super(key: key);

  @override
  State<DashbordAdherent> createState() => _DashbordAdherentState();
}

class _DashbordAdherentState extends State<DashbordAdherent> {
  List<Livre> livres = [];
  String selectedOption = "1";
  int page = 1;
  int limit = 15;
  int totalCount = 0;
  bool isLoading = true;
  bool isDataLoaded = false;

  Future<void> fetchDashbordAdherent() async {
    setState(() {
      isLoading = true;
    });

    var url =
        Uri.parse('http://localhost:4000/api/livres?page=$page&limit=$limit');

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
