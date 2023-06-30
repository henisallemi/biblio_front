import 'package:flutter/material.dart';
import 'dart:nativewrappers';
import 'package:flutter/cupertino.dart';
import 'package:projetbiblio/ouvrages/adherants.dart';
import 'package:projetbiblio/livres/ouvrage_livre.dart';
import 'package:projetbiblio/ouvrages/admins.dart';
import 'package:projetbiblio/roles.dart';
import 'package:projetbiblio/user_state.dart';
import 'package:provider/provider.dart';

import '../connect/from_Screen.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    var userState = Provider.of<UserState>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(userState.connectedUser?.nom ?? ""),
            accountEmail: Text(userState.connectedUser?.email ?? ""),
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
          ...(userState.connectedUser?.role == Roles.admin
              ? [
                  ListTile(
                      leading: const Icon(Icons.people_alt),
                      title: const Text('Liste des Adhérents'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Adherants()),
                        );
                      }),
                  ListTile(
                      leading: const Icon(Icons.people_alt),
                      title: const Text('Admin'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Admins()),
                        );
                      })
                ]
              : []),
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
