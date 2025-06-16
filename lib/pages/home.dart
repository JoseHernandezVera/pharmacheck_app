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
        title: Text(
          'Agregar persona',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'Nombre de la persona',
            labelStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                Provider.of<PeopleProvider>(context, listen: false)
                    .addPerson(nameController.text);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.menu,
              size: 32,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).colorScheme.primary,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Column(
              children: [
                Text(
                  'LISTA DE PERSONAS',
                  style: TextStyle(
                    fontSize: 26,
                    color: Theme.of(context).colorScheme.onPrimary,
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
                      fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                      hintText: 'Buscar personas...',
                      hintStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 5),
                    ),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
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
                          Icon(
                            Icons.people,
                            size: 60,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            _searchQuery.isEmpty
                                ? 'No hay personas registradas'
                                : 'No se encontraron resultados',
                            style: TextStyle(
                              fontSize: 22,
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (_searchQuery.isEmpty)
                            ElevatedButton(
                              onPressed: _showAddPersonDialog,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                                foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Text(
                                'Agregar Primera Persona',
                                style: TextStyle(
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
                          color: Theme.of(context).colorScheme.surfaceContainer,
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
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Theme.of(context).colorScheme.error,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text(
                                            'Eliminar cliente',
                                            style: TextStyle(
                                              color: Theme.of(context).colorScheme.onSurface,
                                            ),
                                          ),
                                          backgroundColor: Theme.of(context).colorScheme.surface,
                                          content: Text(
                                            '¿Estás seguro de que deseas eliminar a ${person.name}?',
                                            style: TextStyle(
                                              color: Theme.of(context).colorScheme.onSurface,
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: Text(
                                                'Cancelar',
                                                style: TextStyle(
                                                  color: Theme.of(context).colorScheme.onSurface,
                                                ),
                                              ),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Theme.of(context).colorScheme.error,
                                                foregroundColor: Theme.of(context).colorScheme.onError,
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
                                                      '${person.name} eliminado',
                                                      style: TextStyle(
                                                        color: Theme.of(context).colorScheme.onErrorContainer,
                                                      ),
                                                    ),
                                                    backgroundColor: Theme.of(context).colorScheme.errorContainer,
                                                  ),
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
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        child: const Icon(Icons.person_add, size: 32),
      ),
    );
  }
}
