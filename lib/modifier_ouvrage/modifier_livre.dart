import 'package:flutter/material.dart';

class ModifierLivre extends StatefulWidget {
  const ModifierLivre({super.key});

  @override
  State<ModifierLivre> createState() => _ModifierLivreState();
}

class _ModifierLivreState extends State<ModifierLivre> {
  TextEditingController isbn = TextEditingController();
  TextEditingController auteur1 = TextEditingController();
  TextEditingController auteur2 = TextEditingController();
  TextEditingController titre = TextEditingController();

  String? selectedOption;

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
                    height: 20,
                  ),
                  Container(
                    width: 1200,
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
                                value:
                                    selectedOption, // Utilisez la valeur sélectionnée
                                items: [
                                  DropdownMenuItem<String>(
                                    value: 'Titre',
                                    child: Text('Titre'),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: 'Auteur',
                                    child: Text('Auteur'),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: 'Année',
                                    child: Text('Année'),
                                  ),
                                ],
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedOption = value ??
                                        ''; // Mettez à jour la valeur sélectionnée
                                  });
                                },
                                hint: Text(selectedOption ?? 'Recherche par :'),
                                underline: Container(
                                  height: 1,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(width: 30),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          7.0), // Ajout du padding horizontal
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
                                    decoration: InputDecoration(
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
                              SizedBox(width: 30),
                              ElevatedButton(
                                onPressed: () {
                                  // Gérer l'action du bouton
                                },
                                child: Text(
                                  'Rechercher',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors
                                      .indigo, // Couleur de fond du bouton
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical:
                                          10), // Espacement interne du bouton
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        8), // Bord arrondi du bouton
                                  ),
                                  elevation: 3, // Élévation du bouton
                                ),
                              ),
                              SizedBox(width: 5),
                              ElevatedButton(
                                onPressed: () {
                                  // Gérer l'action du bouton
                                },
                                child: Text(
                                  'Details',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors
                                      .indigo, // Couleur de fond du bouton
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical:
                                          10), // Espacement interne du bouton
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        8), // Bord arrondi du bouton
                                  ),
                                  elevation: 3, // Élévation du bouton
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
                      width: 1200,
                      height: MediaQuery.of(context).size.height,
                      color: Colors.grey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 10),
                          Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.edit),
                                      SizedBox(width: 5),
                                      Text(
                                        'Modifier/Supprimer un live',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        ' (* = obligatoire)',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w100,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: isbn,
                                          decoration: InputDecoration(
                                            labelText: 'ISBN *',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: TextFormField(
                                          controller: auteur1,
                                          decoration: InputDecoration(
                                            labelText: 'Auteur 1 * ',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: titre,
                                          decoration: InputDecoration(
                                            labelText: 'Titre d\'article *',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: TextFormField(
                                          controller: auteur2,
                                          decoration: InputDecoration(
                                            labelText: 'Auteur 2',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            labelText: 'Editeur *',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            labelText: 'Auteur 3  ',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            labelText: 'Année * ',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            labelText: 'Auteur 4',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            labelText: 'Date d\'édition * ',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            labelText: 'Nombre d\éxemplaire *',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 35,
                                  ),
                                  Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            // Gérer l'action du bouton "Supprimer"
                                          },
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: EdgeInsets.all(16),
                                            primary: Colors
                                                .red, // Couleur du bouton "Supprimer" en rouge
                                          ),
                                          icon: Icon(Icons.delete),
                                          label: Text(
                                            'Supprimer',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            // Gérer l'action du bouton "Modifier"
                                          },
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: EdgeInsets.all(16),
                                            primary: Colors
                                                .green, // Couleur du bouton "Modifier" en vert
                                          ),
                                          icon: Icon(Icons.edit),
                                          label: Text(
                                            'Modifier',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
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
