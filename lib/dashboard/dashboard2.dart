import 'package:flutter/material.dart';
import 'package:projetbiblio/components/tab_view.dart';
import 'package:projetbiblio/dashboard/dashboard_adherent.dart';

import 'dashboard_admin.dart';

class Dashbord2 extends StatelessWidget {
  const Dashbord2({super.key});

  @override
  Widget build(BuildContext context) {
    return TabView(
        tabs: [
          TabData(
            title: Text(
              "Tous les détails des documents",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black), // Modifier la couleur du titre ici
            ),
            content: DashbordAdmin(
              key: super.key,
            ),
          )
        ],
        appTitle: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.analytics,
              size: 33,
            ), // Icône de document
            SizedBox(width: 5),
            Text(
              'Dashboard',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ) // Texte du titre
          ],
        ));
  }
}
