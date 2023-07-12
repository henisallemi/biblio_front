import 'package:flutter/material.dart';
import 'package:projetbiblio/components/tab_view.dart';
import 'package:projetbiblio/dashboard/dashboard_adherent.dart';
import '../home/menu.dart';
import 'dashboard_admin.dart';

class Dashbord2 extends StatelessWidget {
  const Dashbord2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      drawer: Drawer(
        child: Menu(), // Ajouter le widget Menu() ici
      ),
      body: DashbordAdmin(),
    );
  }
}
