import 'package:flutter/material.dart';
import 'package:projetbiblio/components/tab_view.dart';
import 'package:projetbiblio/parametres/parametre.dart';

class TabViewParametre extends StatelessWidget {
  const TabViewParametre({Key? key});

  @override
  Widget build(BuildContext context) {
    return TabView(
      tabs: [
        TabData(
          title: "Paramètres",
          content: Parametre(
            key: key,
            // afterSubmit: () => (),
          ),
        ),
      ],
      appTitle: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.settings,
            size: 33,
          ),
          SizedBox(width: 15),
          Text("Paramètres de l'utilisateur"),
        ],
      ),
    );
  }
}
