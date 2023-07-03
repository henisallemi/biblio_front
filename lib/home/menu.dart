import 'package:flutter/material.dart';
import 'package:projetbiblio/dashboard/dashboard_admin.dart';
import 'package:projetbiblio/users/adherants.dart';
import 'package:projetbiblio/livres/ouvrage_livre.dart';
import 'package:projetbiblio/users/admins.dart';
import 'package:projetbiblio/roles.dart';
import 'package:projetbiblio/user_state.dart';
import 'package:provider/provider.dart';
import '../article/ouvrage_article.dart';
import '../connect/from_Screen.dart';
import '../dashboard/dashboard1.dart';
import '../dashboard/dashboard_adherent.dart';
import '../revue/ouvrage_revue.dart';

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
            accountName: Text(
                "${userState.connectedUser?.prenom ?? ""} ${userState.connectedUser?.nom ?? ""}"),
            accountEmail: Text(userState.connectedUser?.email ?? ""),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                    "http://localhost:4000/${userState.connectedUser!.imagePath.isNotEmpty ? userState.connectedUser!.imagePath : 'uploads/avatar.jpg'}",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                  return Image.asset('images/avatar.jpg');
                }),
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
            leading: Icon(Icons.equalizer_outlined),
            title: Text('Tableau de bord'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DashboardAdmin()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Tableau de bord'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Dashbord1()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('Liste des Livres'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OuvrageLivre()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.article),
            title: const Text('Liste des Articles'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OuvrageArticle()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.library_books),
            title: const Text('Liste des Revues'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OuvrageRevue()),
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
                      title: const Text('Liste des Admins'),
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
            onTap: () async {
              await userState.logout();
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
