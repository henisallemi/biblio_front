class Livre {
  int id;
  String auteur2;
  String auteur3;
  String auteur4;
  Ouvrage ouvrage;

  Livre(
      {required this.id,
      required this.auteur2,
      required this.auteur3,
      required this.auteur4,
      required this.ouvrage});

  factory Livre.fromJson(Map<String, dynamic> json) {
    return Livre(
        id: json['id'] as int,
        auteur2: json['auteur2'] ?? "",
        auteur3: json['auteur3'] ?? "",
        auteur4: json['auteur4'] ?? "",
        ouvrage: Ouvrage.fromJson(json['ouvrage']));
  }

  static List<Livre> fromJsonArray(List<dynamic> jsonList) {
    return jsonList.map((json) => Livre.fromJson(json)).toList();
  }
}

class Ouvrage {
  int id;
  String isbn;
  String titre;
  String editeur;
  String annee;
  DateTime? date;
  String auteur1;
  int nombreExemplaire;

  Ouvrage({
    required this.id,
    required this.isbn,
    required this.titre,
    required this.editeur,
    required this.annee,
    required this.date,
    required this.auteur1,
    required this.nombreExemplaire,
  });

  factory Ouvrage.fromJson(Map<String, dynamic> json) {
    return Ouvrage(
      id: json['id'] as int,
      isbn: json['isbn'] ?? "",
      titre: json['titre'] ?? "",
      editeur: json['editeur'] ?? "",
      annee: json["annee"] ?? "",
      date: json["date"] != null ? DateTime.parse(json["date"]) : null,
      auteur1: json["auteur1"] ?? "",
      nombreExemplaire: json["nombreExemplaire"] ?? 0,
    );
  }
}
