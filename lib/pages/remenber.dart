import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/model_drawer.dart';

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
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userData = userProvider.user.name;

    return Scaffold(
      drawer: const ModelDrawer(),
      backgroundColor: const Color.fromARGB(255, 110, 179, 235),
      appBar: AppBar(
        title: const Text(
          'Noticias',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 3, 99, 179),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, size: 32, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
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