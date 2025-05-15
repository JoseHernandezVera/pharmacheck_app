import 'package:flutter/material.dart';
import 'profile.dart';
import 'home.dart';

class RemenberPage extends StatelessWidget {
  const RemenberPage({super.key});

  static const List<String> noticias = [
    "En Cruz Verde hay descuento del 40% en paracetamol",
    "Campaña de vacunación contra la influenza hasta el 30 de junio",
    "Nuevo horario en farmacias: abiertas hasta las 10 pm",
    "Consulta médica gratuita los sábados en la clínica central",
    "Oferta en vitaminas: 2x1 en farmacia San Juan",
  ];

  @override
  Widget build(BuildContext context) {
    final String userData = "Usuario";

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(color: Color.fromARGB(255, 3, 99, 179)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.account_circle, size: 64, color: Colors.white),
                  SizedBox(height: 8),
                  Text("Usuario", style: TextStyle(color: Colors.white, fontSize: 18)),
                  Text("usuario@ejemplo.com", style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            ListTile(
              title: const Text("Inicio"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Inicio')),
                );
              },
            ),
            ListTile(
              title: const Text("Perfil"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
            ),
            ListTile(
              title: const Text("Recordar"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RemenberPage()),
                );
              },
            ),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 110, 179, 235),
      appBar: AppBar(
        title: const Text(
          'Noticias',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 3, 99, 179),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: noticias.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.article_outlined, color: Colors.blue),
              title: Text(
                noticias[index],
                style: const TextStyle(fontSize: 18),
              ),
              subtitle: Text("Hola, $userData"),
            ),
          );
        },
      ),
    );
  }
}