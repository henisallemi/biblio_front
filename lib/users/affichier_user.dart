import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projetbiblio/model/model.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:projetbiblio/user_state.dart';
import 'package:provider/provider.dart';
import '../types.dart';

class AffichierUser extends StatefulWidget {
  User? user;
  AffichierUser({Key? key, required this.user}) : super(key: key);

  @override
  State<AffichierUser> createState() => _AffichierUserState();
}

class _AffichierUserState extends State<AffichierUser> {
  History? history;
  int page = 1;
  int limit = 15;
  int totalCount = 0;
  bool isLoading = true;
  bool isDataLoaded = false;

  Future<void> fetchAffichierUser() async {
    setState(() {
      isLoading = true;
    });

    var url = Uri.parse(
        'http://localhost:4000/api/users/history/${widget.user!.id}?page=$page&limit=$limit');

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
    fetchAffichierUser();
  }

  void nextPage() {
    setState(() {
      if (page < (totalCount / limit).ceil()) {
        page++;
        fetchAffichierUser();
      }
    });
  }

  void previousPage() {
    setState(() {
      if (page > 1) {
        page--;
        fetchAffichierUser();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    void closeForm() {
      Navigator.pop(context); // Revenir en arrière
    }

    final int totalPages = (totalCount / limit).ceil();
    final userState = Provider.of<UserState>(context);

    if (history == null) {
      return Row(
        children: [],
      );
    }

    return SingleChildScrollView(
      child: Container(
        width: 1400,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.history),
                  const SizedBox(width: 5),
                  const Text(
                    'Historique des empruntes',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                      width:
                          260), // Ajout d'un espacement avant la partie de recherche
                  // Icône de recherche

                  Container(
                    width: 320,
                    child: const TextField(
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
                        backgroundColor: MaterialStateProperty.all(
                            Colors.red), // Couleur personnalisée
                      ),
                    ),
                  ),
                  Spacer(),
                  Visibility(
                    visible: isDataLoaded,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        closeForm();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
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
                                offset: const Offset(0, 2),
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
                                headingRowColor: MaterialStateColor.resolveWith(
                                    (states) => Colors
                                        .red), // Couleur de la ligne d'en-tête
                                dataRowColor: MaterialStateColor.resolveWith(
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
                                            DataCell(Text(item.ouvrage.titre)),
                                            DataCell(
                                                Text(item.ouvrage.editeur)),
                                            DataCell(
                                                Text(item.type == Types.livre
                                                    ? "Livre"
                                                    : item.type == Types.article
                                                        ? "Article"
                                                        : "Revue")),
                                            DataCell(Text(DateFormat(
                                                    'yyyy-MM-dd')
                                                .format(
                                                    item.emprunt.dateEmprunt!)
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
                                      borderRadius: BorderRadius.circular(4),
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
            ],
          ),
        ),
      ),
    );
  }
}
