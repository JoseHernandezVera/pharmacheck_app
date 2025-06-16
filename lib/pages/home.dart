import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/people_provider.dart';
import 'clientes.dart';
import '../models/model_drawer.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                Provider.of<PeopleProvider>(context, listen: false)
                    .addPerson(nameController.text);
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
    final peopleProvider = Provider.of<PeopleProvider>(context);

    final filteredPeople = _searchQuery.isEmpty
        ? peopleProvider.people
        : peopleProvider.people
            .where((person) => person.name
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()))
            .toList();

    return Scaffold(
      drawer: const ModelDrawer(),
      backgroundColor: const Color.fromARGB(255, 110, 179, 235),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 3, 99, 179),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, size: 32, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: const Color.fromARGB(255, 3, 99, 179),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Column(
              children: [
                const Text(
                  'LISTA DE PERSONAS',
                  style: TextStyle(
                    fontSize: 26,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Buscar personas...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 5),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: filteredPeople.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.people, size: 60, color: Colors.white),
                          const SizedBox(height: 20),
                          Text(
                            _searchQuery.isEmpty
                                ? 'No hay personas registradas'
                                : 'No se encontraron resultados',
                            style: const TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (_searchQuery.isEmpty)
                            ElevatedButton(
                              onPressed: _showAddPersonDialog,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text(
                                'Agregar Primera Persona',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 3, 99, 179),
                                  fontSize: 18,
                                ),
                              ),
                            ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: filteredPeople.length,
                      itemBuilder: (context, index) {
                        final person = filteredPeople[index];
                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ClientesPage(name: person.name),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundImage: AssetImage(person.image),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    person.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Eliminar cliente'),
                                          content: Text(
                                              '¿Estás seguro de que deseas eliminar a ${person.name}?'),
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
                                                peopleProvider.removePerson(
                                                    peopleProvider.people
                                                        .indexOf(person));
                                                Navigator.pop(context);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                      content: Text(
                                                          '${person.name} eliminado')),
                                                );
                                              },
                                              child: const Text('Eliminar'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPersonDialog,
        backgroundColor: const Color.fromARGB(255, 3, 99, 179),
        child: const Icon(Icons.person_add, color: Colors.white, size: 32),
      ),
    );
  }
}