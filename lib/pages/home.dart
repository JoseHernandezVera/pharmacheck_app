import 'package:flutter/material.dart';
import 'clientes.dart';
import 'base_pages.dart';
import 'package:provider/provider.dart';
import 'package:pharmacheck/pages/user_data.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Map<String, String>> people = [
    {'name': 'Juan Pérez', 'image': 'assets/images/perfil.jpg'},
    {'name': 'Ana Torres', 'image': 'assets/images/perfil.jpg'},
    {'name': 'Carlos Díaz', 'image': 'assets/images/perfil.jpg'},
  ];

  void _addPerson(String name) {
    setState(() {
      people.add({
        'name': name,
        'image': 'assets/images/perfil.jpg',
      });
    });
  }

  void _showAddPersonDialog() {
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Agregar persona'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Nombre de la persona'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                _addPerson(nameController.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 110, 179, 235),
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: const Color.fromARGB(255, 3, 99, 179),
      ),
      drawer: Consumer<UserData>(
        builder: (context, userData, child) {
          return BasePage(title: widget.title);
        },
      ),
      body: Column(
        children: [
          Container(
            color: const Color.fromARGB(255, 3, 99, 179),
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: const Text(
              'LISTA DE PERSONAS',
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
                    color: const Color.fromARGB(255, 255, 255, 255),
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
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Eliminar cliente'),
                            content: Text('¿Estás seguro de que deseas eliminar a ${person['name']}?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancelar'),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    people.removeAt(index);
                                  });
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('${person['name']} eliminado')),
                                  );
                                },
                                child: const Text('Eliminar'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ClientesPage(name: person['name']!),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPersonDialog,
        child: const Icon(Icons.person_add),
      ),
    );
  }
}