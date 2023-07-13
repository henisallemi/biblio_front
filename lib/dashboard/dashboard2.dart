import 'package:flutter/material.dart';
import '../home/menu.dart';
import 'dashboard_admin.dart';

class Dashbord2 extends StatefulWidget {
  const Dashbord2({super.key});

  @override
  State<Dashbord2> createState() => _Dashbord2State();
}

class _Dashbord2State extends State<Dashbord2> {
  bool refresh = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          refresh = !refresh;
        });
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.dashboard),
                SizedBox(width: 8), // Espacement entre l'icône et le texte
                Text('Dashboard'),
              ],
            ),
          ),
        ),
        drawer: Drawer(
          child: Menu(), // Ajouter le widget Menu() ici
        ),
        body: DashbordAdmin(),
      ),
    );
  }
}
