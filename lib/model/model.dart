import 'dart:io';

import 'package:projetbiblio/roles.dart';

class User {
  int id;
  String imagePath;
  String cin;
  String nom;
  String prenom;
  String email;
  String telephone;
  String motDePasse;
  int role;

  getFullName() {
    return "$nom $prenom";
  }

  User({
    required this.id,
    required this.imagePath,
    required this.cin,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.telephone,
    required this.motDePasse,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      imagePath: json['imagePath'] ?? "",
      cin: json['cin'] ?? "",
      nom: json['nom'] ?? "",
      prenom: json['prenom'] ?? "",
      email: json["email"] ?? "",
      telephone: json["telephone"] ?? "",
      motDePasse: json["motDePasse"] ?? "",
      role: json["role"] ?? Roles.adherant,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "imagePath": imagePath,
      "cin": cin,
      "nom": nom,
      "prenom": prenom,
      "email": email,
      "telephone": telephone,
      "motDePasse": motDePasse,
      "role": role,
    };
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

class Revue {
  int id;
  String auteur2;
  String numeroVolume;
  Ouvrage ouvrage;
  Revue(
      {required this.id,
      required this.auteur2,
      required this.numeroVolume,
      required this.ouvrage});
  factory Revue.fromJson(Map<String, dynamic> json) {
    return Revue(
        id: json['id'] as int,
        auteur2: json['auteur2'] ?? "",
        numeroVolume: json['numeroVolume'] ?? "",
        ouvrage: Ouvrage.fromJson(json['ouvrage']));
  }

  static List<Revue> fromJsonArray(List<dynamic> jsonList) {
    return jsonList.map((json) => Revue.fromJson(json)).toList();
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

class History {
  int nombreLivres;
  int nombreRevues;
  int nombreArticles;
  List<HistoryItem> items;

  History(
      {required this.nombreRevues,
      required this.nombreArticles,
      required this.items,
      required this.nombreLivres});

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
        nombreLivres: json['nombreLivres'] ?? 0,
        nombreRevues: json['nombreRevues'] ?? 0,
        nombreArticles: json['nombreArticles'] ?? 0,
        items: HistoryItem.fromJsonArray(json['items']));
  }
}

class Emprunt {
  DateTime? dateEmprunt;
  DateTime? dateDeRetour;
  DateTime? returnedAt;
  bool isReturned;
  User? user;

  Emprunt(
      {required this.dateEmprunt,
      required this.dateDeRetour,
      required this.returnedAt,
      required this.isReturned,
      this.user});

  factory Emprunt.fromJson(Map<String, dynamic> json) {
    return Emprunt(
        dateEmprunt: json["dateEmprunt"] != null
            ? DateTime.parse(json["dateEmprunt"])
            : null,
        dateDeRetour: json["dateDeRetour"] != null
            ? DateTime.parse(json["dateDeRetour"])
            : null,
        returnedAt: json["returnedAt"] != null
            ? DateTime.parse(json["returnedAt"])
            : null,
        isReturned: json['isReturned'] ?? false,
        user: json['user'] != null ? User.fromJson(json["user"]) : null);
  }

  static List<Emprunt> fromJsonArray(List<dynamic> jsonList) {
    return jsonList.map((json) => Emprunt.fromJson(json)).toList();
  }
}

class HistoryItem {
  Ouvrage ouvrage;
  int type;
  Emprunt emprunt;

  HistoryItem(
      {required this.ouvrage, required this.type, required this.emprunt});

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
        ouvrage: Ouvrage.fromJson(json["ouvrage"]),
        type: json['type'],
        emprunt: Emprunt.fromJson(json["emprunt"]));
  }

  static List<HistoryItem> fromJsonArray(List<dynamic> jsonList) {
    return jsonList.map((json) => HistoryItem.fromJson(json)).toList();
  }
}

class Stats {
  double livresStats;
  double articlesStats;
  double revuesStats;
  List<HistoryItem> items;

  Stats(
      {required this.articlesStats,
      required this.revuesStats,
      required this.items,
      required this.livresStats});

  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(
        livresStats: double.tryParse(json['livresStats'].toString()) ?? 0.0,
        articlesStats: double.tryParse(json['articlesStats'].toString()) ?? 0.0,
        revuesStats: double.tryParse(json['revuesStats'].toString()) ?? 0.0,
        items: HistoryItem.fromJsonArray(json['items']));
  }
}
