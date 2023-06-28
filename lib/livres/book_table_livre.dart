import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:projetbiblio/livres/affichier_livre.dart';
import 'package:projetbiblio/model/model.dart';
import 'package:projetbiblio/livres/livres_formulaire.dart';
import 'package:http/http.dart' as http;

class BookTable extends StatelessWidget {
  List<Livre> livres;

  int page;
  int limit;
  int totalCount;
  Function nextPage;
  Function previousPage;
  Function refreshData;

  BookTable({
    super.key,
    required this.livres,
    required this.page,
    required this.limit,
    required this.totalCount,
    required this.nextPage,
    required this.previousPage,
    required this.refreshData,
  });

  Future<void> deleteRequest(Livre livre) async {
    var url = Uri.parse('http://localhost:4000/api/livres/${livre.id}');

    try {
      var response = await http.delete(url);
      if (response.statusCode == 200) {
        await refreshData();
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

    return Container(
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
                      builder: (BuildContext context) {
                        return FractionallySizedBox(
                          child: Dialog(
                            // Contenu de la boîte de dialogue ici
                            child: Container(
                              child: LivreFormulaire(
                                afterSubmit: () => refreshData(),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.library_add), // Icône à afficher
                  label: Text(
                    'Ajouter un livre',
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
          SizedBox(
            height: 28,
          ),
          DataTable(
            headingRowColor: MaterialStateColor.resolveWith((states) =>
                Colors.indigoAccent), // Couleur de la ligne d'en-tête
            dataRowColor:
                MaterialStateColor.resolveWith((states) => Colors.white),

            columns: [
              DataColumn(
                label: Text(
                  'ISBN',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              DataColumn(
                label: Text(
                  'Titre',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              DataColumn(
                label: Text(
                  'Auteur',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              DataColumn(
                label: Text(
                  'Année',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              DataColumn(
                label: Text(
                  'Editeur',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Center(
                    child: Text(
                      'Actions',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],

            rows: livres
                .map((livre) => DataRow(
                      cells: [
                        DataCell(Text(livre.ouvrage.isbn)),
                        DataCell(Text(livre.ouvrage.titre)),
                        DataCell(Text(livre.ouvrage.auteur1)),
                        DataCell(Text(livre.ouvrage.annee)),
                        DataCell(Text(livre.ouvrage.editeur)),
                        DataCell(Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return FractionallySizedBox(
                                      child: Dialog(
                                        child: Container(
                                          child: AffichierLivre(livre: livre),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: Icon(
                                Icons.visibility,
                                size: 32,
                                color: Colors.green,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return FractionallySizedBox(
                                      child: Dialog(
                                        // Dialog content here
                                        child: Container(
                                          child: LivreFormulaire(
                                            livre: livre,
                                            afterSubmit: () => refreshData(),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: Icon(
                                Icons.edit,
                                size: 32, // Taille de l'icône
                                color: Colors.blue, // Couleur de l'icône
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                          'Confirmation de suppression du livre ${livre.ouvrage.titre}'),
                                      content: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                              'Êtes-vous sûr de vouloir supprimer le livre suivant ?'),
                                          SizedBox(height: 16),
                                          //Text('titre : ${livre.titre}'),
                                          //Text('Auteur : ${livre.auteur}'),
                                        ],
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('Annuler'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: Text('Supprimer'),
                                          onPressed: () {
                                            deleteRequest(livre);
                                            Navigator.of(context).pop();
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: (page > 1) ? previousPage as void Function()? : null,
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
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                onPressed:
                    (page < totalPages) ? nextPage as void Function()? : null,
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
    );
  }
}

class ParentWidget extends StatefulWidget {
  @override
  _ParentWidgetState createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget> {
  List<Livre> livres = [];
  int page = 1;
  int limit = 15;
  int totalCount = 0;

  Future<void> fetchLivres(int page, int limit) async {
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
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void nextPage() {
    setState(() {
      if (page < (totalCount / limit).ceil()) {
        page++;
        fetchLivres(page, limit);
      }
    });
  }

  void previousPage() {
    setState(() {
      if (page > 1) {
        page--;
        fetchLivres(page, limit);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchLivres(page, limit);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Livres'),
      ),
      body: BookTable(
        livres: livres,
        page: page,
        limit: limit,
        totalCount: totalCount,
        nextPage: nextPage,
        previousPage: previousPage,
        refreshData: () => fetchLivres(page, limit),
      ),
    );
  }
}
