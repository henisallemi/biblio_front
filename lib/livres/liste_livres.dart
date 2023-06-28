import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:projetbiblio/model/model.dart';
import 'package:projetbiblio/livres/book_table_livre.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class ListeLivres extends StatefulWidget {
  const ListeLivres({Key? key}) : super(key: key);

  @override
  State<ListeLivres> createState() => _ListeLivresState();
}

class _ListeLivresState extends State<ListeLivres> {
  TextEditingController recherche = TextEditingController();
  List<Livre> livres = [];
  String selectedOption = "1";

  bool isLoading = true;
  bool isDataLoaded = false;
  int page = 1;
  int limit = 15;
  int totalCount = 0;

  Future<void> fetchLivres(int page, int limit) async {
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

    fetchLivres(page, limit).then((_) {
      Timer(Duration(seconds: 5), () {
        // Appeler getData() après un délai de 5 seconde
        getData();
      });
    });
  }

  Future<void> getData() async {
    var url = Uri.parse(
        'http://localhost:4000/api/livres?recherche=${recherche.text.trim()}&target=$selectedOption');

    var headers = {'Content-Type': 'application/json'};

    var response = await http.get(url, headers: headers);
    var data = json.decode(response.body);
    setState(() {
      livres = Livre.fromJsonArray(data["livres"] ?? []);
    });
  }

  @override
  Widget build(BuildContext context) {
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
                                onPressed: getData,
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
                              BookTable(
                                livres: livres,
                                page: page,
                                limit: limit,
                                totalCount: totalCount,
                                nextPage: nextPage,
                                previousPage: previousPage,
                                refreshData: () => getData(),
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
