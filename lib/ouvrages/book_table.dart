import 'package:flutter/material.dart';
import 'package:projetbiblio/model/model.dart';
import 'package:projetbiblio/ouvrages/livres_formulaire.dart';

class BookTable extends StatelessWidget {
  List<Livre> livres;

  BookTable({super.key, required this.livres});

  @override
  Widget build(BuildContext context) {
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
      child: DataTable(
        headingRowColor: MaterialStateColor.resolveWith(
            (states) => Colors.indigo), // Couleur de la ligne d'en-tête
        dataRowColor: MaterialStateColor.resolveWith(
            (states) => Colors.white), // Couleur des lignes de données
        columns: const [
          DataColumn(
            label: Text(
              'ISBN',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          DataColumn(
            label: Text(
              'Titre',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          DataColumn(
            label: Text(
              'Auteur',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          DataColumn(
            label: Text(
              'Année',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          DataColumn(
            label: Text(
              'Editeur',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
                            // Show action
                          },
                          icon: Icon(Icons.visibility),
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
                                        child: LivreFormulaire(livre: livre)),
                                  ),
                                );
                              },
                            );
                          },
                          icon: Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            // Delete action
                          },
                          icon: Icon(Icons.delete),
                        ),
                      ],
                    )),
                  ],
                ))
            .toList(),
      ),
    );
  }
}
