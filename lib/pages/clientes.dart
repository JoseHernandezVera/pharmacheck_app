import 'package:flutter/material.dart';

class ClientesPage extends StatelessWidget {
  final String name;

  const ClientesPage({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        toolbarHeight: 150, // Altura más grande para incluir imagen y nombre
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/images/perfil.jpg'),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text(''), // Puedes poner contenido adicional aquí si deseas
      ),
    );
  }
}