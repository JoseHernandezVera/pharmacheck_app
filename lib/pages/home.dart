import 'package:flutter/material.dart';
import 'clientes.dart';  // Importar la página de clientes
import 'base_pages.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> people = [
      {'name': 'Juan Pérez', 'image': 'assets/images/perfil.jpg'},
      {'name': 'Ana Torres', 'image': 'assets/images/perfil.jpg'},
      {'name': 'Carlos Díaz', 'image': 'assets/images/perfil.jpg'},
    ];

    return BasePage(
      title: title,
      body: Column(
        children: [
          Container(
            color: Colors.deepPurple,
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: const Text(
              'Lista de personas',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: people.length,
              itemBuilder: (context, index) {
                final person = people[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    border: Border.all(
                      color: Colors.black,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 28,
                      backgroundImage: AssetImage(person['image']!),
                    ),
                    title: Text(
                      person['name']!,
                      style: const TextStyle(fontSize: 18),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ClientesPage(name: person['name']!),
                        ),
                      );
                    }
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}