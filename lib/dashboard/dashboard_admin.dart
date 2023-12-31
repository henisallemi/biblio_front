import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projetbiblio/model/model.dart';
import 'package:http/http.dart' as http;
import 'package:projetbiblio/types.dart';
import 'dart:async';
import 'package:projetbiblio/user_state.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class DashbordAdmin extends StatefulWidget {
  const DashbordAdmin({Key? key}) : super(key: key);

  @override
  State<DashbordAdmin> createState() => _DashbordAdminState();
}

class StatisticData {
  final String category;
  final double? percentage;
  final Color color;

  StatisticData(this.category, this.percentage, this.color);
}

class _DashbordAdminState extends State<DashbordAdmin>
    with SingleTickerProviderStateMixin {
  Stats? stats;

  int page = 1;
  int limit = 15;
  int totalCount = 0;
  bool isLoading = true;
  bool isDataLoaded = false;
  bool isRefreshing = false;
  AnimationController? animationController;
  Timer? timer;

  Future<void> fetchDashbordAdmin() async {
    setState(() {
      isLoading = true;
      isRefreshing = true;
    });

    print("fetching from api");

    var url = Uri.parse('http://localhost:4000/api/dashboard/stats');

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          stats = Stats.fromJson(data["stats"]);
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
        isRefreshing = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDashbordAdmin();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    animationController?.dispose();
    timer?.cancel();
    super.dispose();
  }

  void startAnimation() {
    animationController?.repeat();
    timer = Timer(Duration(milliseconds: 1000), () {
      setState(() {
        animationController?.stop();
      });
    });
  }

  void nextPage() {
    setState(() {
      if (page < (totalCount / limit).ceil()) {
        page++;
        fetchDashbordAdmin();
      }
    });
  }

  void previousPage() {
    setState(() {
      if (page > 1) {
        page--;
        fetchDashbordAdmin();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final int totalPages = (totalCount / limit).ceil();
    final userState = Provider.of<UserState>(context);

    Map<String, IconData> categoryIcons = {
      'Livres': Icons.book,
      'Articles': Icons.article,
      'Revues': Icons.library_books,
    };

    List<StatisticData> data = [
      StatisticData('Livres', (stats?.livresStats ?? 0), Colors.blue),
      StatisticData('Articles', (stats?.articlesStats ?? 0), Colors.green),
      StatisticData('Revues', (stats?.revuesStats ?? 0), Colors.orange),
    ];

    print("rerender");

    if (stats == null) {
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
              color: Colors.grey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(Icons.pie_chart),
                              SizedBox(width: 5),
                              Text(
                                'Pourcentages des documents',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    startAnimation(); // Démarrer l'animation
                                  });
                                  fetchDashbordAdmin();
                                },
                                child: RotationTransition(
                                  turns: animationController!,
                                  child: Icon(
                                    Icons.refresh,
                                    size: 30,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            for (int i = 0; i < data.length; i++)
                              Column(
                                children: [
                                  CircularPercentIndicator(
                                    radius: 200.0,
                                    lineWidth: 20.0,
                                    percent: data[i].percentage!,
                                    center: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          categoryIcons[data[i].category],
                                          size: 80,
                                          color: Colors.black,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          '${(data[i].percentage! * 100).toStringAsFixed(0)}%',
                                          style: TextStyle(fontSize: 40),
                                        ),
                                      ],
                                    ),
                                    progressColor: data[i].color,
                                    circularStrokeCap: CircularStrokeCap.round,
                                    animation: true,
                                    animationDuration: 1000,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    data[i].category,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                ],
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
                          const Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                Icon(Icons.event),
                                SizedBox(width: 5),
                                Text(
                                  'Retour des documents dans les prochains jours',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
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
                                    headingRowColor:
                                        MaterialStateColor.resolveWith(
                                            (states) => Colors.red),
                                    dataRowColor:
                                        MaterialStateColor.resolveWith(
                                            (states) => Colors.white),

                                    columns: const [
                                      DataColumn(
                                        label: SizedBox(
                                          width: 120,
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
                                            'Date de retour',
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
                                            'Nom et Prénom',
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
                                            "Téléphone",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                    rows: stats?.items
                                            .map((item) => DataRow(
                                                  cells: [
                                                    DataCell(Text(item.type ==
                                                            Types.livre
                                                        ? "Livre"
                                                        : item.type ==
                                                                Types.article
                                                            ? "Article"
                                                            : "Revue")),
                                                    DataCell(Text(
                                                        item.ouvrage.titre)),
                                                    DataCell(Text(
                                                        DateFormat('yyyy-MM-dd')
                                                            .format(item.emprunt
                                                                .dateDeRetour!)
                                                            .toString())),
                                                    DataCell(Text(item
                                                        .emprunt.user
                                                        ?.getFullName())),
                                                    DataCell(Text(
                                                        "${item.emprunt.user?.telephone}")),
                                                  ],
                                                ))
                                            .toList() ??
                                        [],
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
                          // const SizedBox(height: 30),
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
