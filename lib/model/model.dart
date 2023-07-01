import 'package:projetbiblio/roles.dart';

class User {
  int id;
  String image;
  String cin;
  String nom;
  String prenom;
  String email;
  String telephone;
  String motDePasse;
  int nombreLivrePrendre;
  int role;

  User({
    required this.id,
    required this.image,
    required this.cin,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.telephone,
    required this.motDePasse,
    required this.nombreLivrePrendre,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      image: json['image'] ?? "",
      cin: json['cin'] ?? "",
      nom: json['nom'] ?? "",
      prenom: json['prenom'] ?? "",
      email: json["email"] ?? "",
      telephone: json["telephone"] ?? "",
      motDePasse: json["motDePasse"] ?? "",
      nombreLivrePrendre: json["nombreLivrePrendre"] ?? 0,
      role: json["role"] ?? Roles.adherant,
    );
  }

  static List<User> fromJsonArray(List<dynamic> jsonList) {
    return jsonList.map((json) => User.fromJson(json)).toList();
  }
}

class Artilce {
  int id;
  String auteur2;
  String conference;
  Ouvrage ouvrage;
  Artilce(
      {required this.id,
      required this.auteur2,
      required this.conference,
      required this.ouvrage});
  factory Artilce.fromJson(Map<String, dynamic> json) {
    return Artilce(
        id: json['id'] as int,
        auteur2: json['auteur2'] ?? "",
        conference: json['conference'] ?? "",
        ouvrage: Ouvrage.fromJson(json['ouvrage']));
  }

  static List<Artilce> fromJsonArray(List<dynamic> jsonList) {
    return jsonList.map((json) => Artilce.fromJson(json)).toList();
  }
}

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
  String description;
  String annee;
  DateTime? date;
  String auteur1;
  int nombreExemplaire;
  int nombreDisponible;

  Ouvrage({
    required this.id,
    required this.isbn,
    required this.titre,
    required this.editeur,
    required this.description,
    required this.annee,
    required this.date,
    required this.auteur1,
    required this.nombreExemplaire,
    required this.nombreDisponible,
  });

  factory Ouvrage.fromJson(Map<String, dynamic> json) {
    return Ouvrage(
      id: json['id'] as int,
      isbn: json['isbn'] ?? "",
      titre: json['titre'] ?? "",
      editeur: json['editeur'] ?? "",
      description: json['description'] ?? "",
      annee: json["annee"] ?? "",
      date: json["date"] != null ? DateTime.parse(json["date"]) : null,
      auteur1: json["auteur1"] ?? "",
      nombreExemplaire: json["nombreExemplaire"] ?? 0,
      nombreDisponible: json["nombreDisponible"] ?? 0,
    );
  }
}
