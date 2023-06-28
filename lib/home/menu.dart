import 'package:flutter/material.dart';
import 'dart:nativewrappers';
import 'package:flutter/cupertino.dart';
import 'package:projetbiblio/connect/user_formulaire.dart';
import 'package:projetbiblio/ouvrages/ouvrage.dart';

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
            title: const Text('Profil'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Liste des Ouvrages'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Ouvrage()),
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
                  MaterialPageRoute(builder: (context) => UserFormulaire()),
                );
              }),
          ListTile(
            leading: const Icon(CupertinoIcons.person_add),
            title: const Text('Ajouter adhérent'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.mode_edit),
            title: const Text('Modifier adhérent'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Historique'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Paramètres'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Déconnecter'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
