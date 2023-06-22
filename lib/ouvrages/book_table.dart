import 'package:flutter/material.dart';

class BookTable extends StatefulWidget {
  @override
  _BookTableState createState() => _BookTableState();
}

class _BookTableState extends State<BookTable> {
  List<List<String>> bookData = [
    ["Titre", "Auteur", "Année", "Editeur", "ISBN"],
  ];

  void addBook(
      String title, String author, String year, String publisher, String isbn) {
    setState(() {
      bookData.add([title, author, year, publisher, isbn]);
    });
  }

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
            label: Text(
              'ISBN',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ],
        rows: bookData
            .map(
              (row) => DataRow(
                cells: row
                    .map(
                      (cell) => DataCell(
                        Text(
                          cell,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    )
                    .toList(),
              ),
            )
            .toList(),
      ),
    );
  }
}
