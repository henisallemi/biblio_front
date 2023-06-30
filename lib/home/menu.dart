import 'package:flutter/material.dart';
import 'dart:nativewrappers';
import 'package:flutter/cupertino.dart';
import 'package:projetbiblio/connect/user_formulaire.dart';
import 'package:projetbiblio/ouvrages/ouvrage_livre.dart';

import '../connect/from_Screen.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text("Heni sellami"),
            accountEmail: Text("Heni.sellami@gmail.com"),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset('images/avatar.jpg'),
              ),
            ),
            decoration: const BoxDecoration(
                color: Colors.indigo,
                image: DecorationImage(
                  image: AssetImage('images/back.jpg'),
                  fit: BoxFit.cover,
                )),
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Tableau de bord'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Liste des Livres'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OuvrageLivre()),
              );
            },
          ),
          const Divider(
            color: Colors.black,
            thickness: 5.0,
          ),
          ListTile(
              leading: const Icon(Icons.people_alt),
              title: const Text('Adhérents'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UserFormulaire()),
                );
              }),
          ListTile(
              leading: const Icon(Icons.people_alt),
              title: const Text('Admin'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UserFormulaire()),
                );
              }),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Paramètres'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Déconnecter'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FormScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
