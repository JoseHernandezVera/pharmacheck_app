import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'base_pages.dart';
import 'user_data.dart';

class RememberPage extends StatelessWidget {
  const RememberPage({super.key});

  final List<String> noticias = const [
    "En Cruz Verde hay descuento del 40% en paracetamol",
    "Campaña de vacunación contra la influenza hasta el 30 de junio",
    "Nuevo horario en farmacias: abiertas hasta las 10 pm",
    "Consulta médica gratuita los sábados en la clínica central",
    "Oferta en vitaminas: 2x1 en farmacia San Juan",
  ];

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 110, 179, 235),
      appBar: AppBar(
        title: const Text(
          'Noticias',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 3, 99, 179),
      ),
      drawer: BasePage(title: 'Remember'),
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
              subtitle: Text("Hola, ${userData.name}"),
            ),
          );
        },
      ),
    );
  }
}