import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:projetbiblio/home/menu.dart';

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/litterature.jpg',
              width: 90,
              height: 50,
            ),
            SizedBox(width: 5),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Notre Bibliothèque :",
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  "Réussir",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontFamily: "Arial",
                    decorationColor: Colors.black12,
                    decorationThickness: 2,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      drawer: Menu(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.0),
              color: Colors.blue,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Bienvenue dans notre bibliothèque',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Bibliothèque Réussir',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Route de Tunis, Km 4.5 Sfax, Tunisie',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Heures d\'ouverture',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Lundi - Vendredi : ',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '9h00 - 18h00',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Samedi : ',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '10h00 - 16h00',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/biblio.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                padding: EdgeInsets.all(16.0),
                color: Colors.white.withOpacity(
                    0.8), // Ajoutez de la transparence à la couleur de fond si nécessaire
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Description d'une bibliothèque :",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Un lieu accueillant et inspirant, rempli de connaissances et de ressources pour les amateurs de lecture et les chercheurs curieux.',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'Helvetica',
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Lorsque vous entrez dans la bibliothèque, vous êtes accueilli par l\'odeur apaisante des livres et le calme qui règne dans l\'air. Les étagères s\'étendent sur toute la pièce, remplies de livres de toutes sortes, du plafond au sol. Les ouvrages sont classés soigneusement selon différents sujets, genres et auteurs, ce qui facilite la recherche et la navigation.',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'Helvetica',
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Au centre de la bibliothèque, vous trouverez de confortables fauteuils et canapés, invitant les lecteurs à s\'installer et à se plonger dans leurs livres préférés. Des tables et des bureaux sont également disponibles pour ceux qui préfèrent étudier ou travailler en groupe.',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'Helvetica',
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Nos bibliothécaires passionnés sont là pour vous aider et vous conseiller. Ils sont toujours prêts à recommander des livres, à donner des conseils de recherche ou à aider les utilisateurs à trouver les informations dont ils ont besoin.',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'Helvetica',
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Nous organisons régulièrement des événements tels que des conférences, des ateliers d\'écriture, des clubs de lecture et des expositions thématiques. Cela crée un esprit communautaire et encourage les échanges intellectuels entre les utilisateurs.',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'Helvetica',
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Types de documents :',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "Dans notre bibliothèque, vous trouverez principalement trois types de documents :",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            ClipOval(
                              child: Image.asset(
                                'images/livre.jpg',
                                width: 150,
                                height: 70,
                              ),
                            ),
                            SizedBox(width: 7),
                          ],
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              children: [
                                TextSpan(
                                  text: "            - Les livres",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      " sont l'un des types de documents les plus courants et populaires dans notre bibliothèque. Nous avons une vaste collection de livres couvrant une large gamme de sujets, allant de la fiction à la non-fiction. Que vous recherchiez de la littérature classique, des romans contemporains, des livres académiques, des ouvrages de référence ou des livres spécialisés dans un domaine particulier, vous trouverez certainement des livres adaptés à vos intérêts.",
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            ClipOval(
                              child: Image.asset(
                                'images/article.jpg',
                                width: 150,
                                height: 120,
                              ),
                            ),
                            SizedBox(width: 10),
                          ],
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              children: [
                                TextSpan(
                                  text: "            - Les Articles",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      " sont des documents plus courts et plus spécifiques, souvent publiés dans des revues académiques ou spécialisées. Ces articles couvrent des sujets spécifiques et fournissent des informations détaillées et actualisées sur des domaines de recherche particuliers. Ils sont utiles pour les chercheurs, les étudiants et toute personne souhaitant approfondir ses connaissances sur un sujet précis.",
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            ClipOval(
                              child: Image.asset(
                                'images/revue.jpg',
                                width: 150,
                                height: 120,
                              ),
                            ),
                            SizedBox(width: 10),
                          ],
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              children: [
                                TextSpan(
                                  text: "            - Les Revues",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      " sont des publications périodiques qui regroupent plusieurs articles sur des sujets variés. Elles sont souvent spécialisées dans un domaine particulier, comme la science, la littérature, l'art, la musique, les affaires, etc. Les revues offrent une source d'informations régulièrement mise à jour et sont idéales pour rester informé des dernières avancées et tendances dans un domaine spécifique.",
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "     En plus de ces types de documents, notre bibliothèque peut également contenir d'autres ressources, telles que des thèses, des mémoires, des rapports de recherche, des manuscrits, des cartes, des enregistrements audio ou vidéo, des journaux et bien d'autres, en fonction de la nature et de la spécialisation de notre collection.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 16),
                    Column(
                      children: [
                        Text(
                          'Contact :',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                            text: '',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: '+216 2769 8345',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: ' (Mobile)',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                              TextSpan(
                                text: ', ',
                              ),
                              TextSpan(
                                text: '+216 1234 5678',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: ' (Fixe)',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Email :',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        Text(
                          'info@reussir-library.com',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
