import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import '../providers/people_provider.dart';
import '../models/person_model.dart';
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
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<String?> _pickImage({bool fromCamera = false}) async {
    final pickedFile = await _picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      maxWidth: 500,
      maxHeight: 500,
      imageQuality: 90,
    );

    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = basename(pickedFile.path);
      final savedImage = await File(pickedFile.path).copy('${directory.path}/$fileName');
      return savedImage.path;
    }
    return null;
  }

  Future<String?> _showImageSourceDialog(BuildContext context) async {
    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Seleccionar imagen',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  Icons.photo_library,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(
                  'Galería',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                onTap: () async {
                  final image = await _pickImage(fromCamera: false);
                  Navigator.pop(context, image);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.camera_alt,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(
                  'Cámara',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                onTap: () async {
                  final image = await _pickImage(fromCamera: true);
                  Navigator.pop(context, image);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddPersonDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    String imagePath = 'assets/images/perfil.jpg';
    bool canAdd = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            nameController.addListener(() {
              final isNotEmpty = nameController.text.trim().isNotEmpty;
              if (isNotEmpty != canAdd) {
                setState(() {
                  canAdd = isNotEmpty;
                });
              }
            });

            return AlertDialog(
              title: Text(
                'Agregar persona',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              backgroundColor: Theme.of(context).colorScheme.surface,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final newImage = await _showImageSourceDialog(context);
                      if (newImage != null) {
                        setState(() {
                          imagePath = newImage;
                        });
                      }
                    },
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: imagePath.startsWith('assets/')
                          ? AssetImage(imagePath) as ImageProvider
                          : FileImage(File(imagePath)),
                      child: Icon(
                        Icons.camera_alt, 
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Nombre',
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
                ],
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
                  onPressed: canAdd
                      ? () {
                          if (nameController.text.isNotEmpty) {
                            Provider.of<PeopleProvider>(context, listen: false).addPerson(
                              nameController.text.trim(),
                              imagePath,
                            );
                            Navigator.pop(context);
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  child: const Text('Agregar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, Person person, Function(String) onImageUpdated) {
    final TextEditingController nameController = TextEditingController(text: person.name);
    final peopleProvider = Provider.of<PeopleProvider>(context, listen: false);
    final index = peopleProvider.people.indexOf(person);
    String currentImagePath = person.imagePath;
    bool canSave = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            nameController.addListener(() {
              final isNotEmpty = nameController.text.trim().isNotEmpty;
              if (isNotEmpty != canSave) {
                setState(() {
                  canSave = isNotEmpty;
                });
              }
            });

            return AlertDialog(
              title: Text(
                'Editar persona',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              backgroundColor: Theme.of(context).colorScheme.surface,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final newImage = await _showImageSourceDialog(context);
                      if (newImage != null) {
                        setState(() {
                          currentImagePath = newImage;
                        });
                        onImageUpdated(newImage);
                      }
                    },
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: currentImagePath.startsWith('assets/')
                          ? AssetImage(currentImagePath) as ImageProvider
                          : FileImage(File(currentImagePath)),
                      child: Icon(
                        Icons.camera_alt, 
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Nombre',
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
                ],
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
                  onPressed: canSave
                      ? () {
                          if (nameController.text.isNotEmpty) {
                            peopleProvider.updatePersonImage(index, currentImagePath);
                            peopleProvider.editPerson(
                              index,
                              nameController.text.trim(),
                            );
                            Navigator.pop(context);
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, Person person) {
    final peopleProvider = Provider.of<PeopleProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Eliminar persona',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
          content: Text(
            '¿Eliminar a ${person.name}?',
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
                peopleProvider.removePerson(peopleProvider.people.indexOf(person));
                Navigator.pop(context);
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final peopleProvider = Provider.of<PeopleProvider>(context);
    final filteredPeople = _searchQuery.isEmpty
        ? peopleProvider.people
        : peopleProvider.people
            .where((person) => person.name.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

    return Scaffold(
      drawer: const ModelDrawer(),
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(
                Icons.menu, 
                size: 32, 
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search, 
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () {
              showSearch(
                context: context,
                delegate: _PersonSearchDelegate(peopleProvider.people),
              );
            },
          ),
        ],
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
                              onPressed: () => _showAddPersonDialog(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                                foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text(
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
                      itemBuilder: (BuildContext context, int index) {
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
                                  builder: (BuildContext context) => ClientesPage(
                                    name: person.name,
                                    imagePath: person.imagePath,
                                  ),
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
                                    backgroundImage: person.imagePath.startsWith('assets/')
                                        ? AssetImage(person.imagePath) as ImageProvider
                                        : FileImage(File(person.imagePath)),
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                        onPressed: () => _showEditDialog(
                                          context, 
                                          person,
                                          (newImage) {
                                            peopleProvider.updatePersonImage(
                                              peopleProvider.people.indexOf(person), 
                                              newImage
                                            );
                                          },
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Theme.of(context).colorScheme.error,
                                        ),
                                        onPressed: () => _showDeleteDialog(context, person),
                                      ),
                                    ],
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
        onPressed: () => _showAddPersonDialog(context),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        child: const Icon(Icons.person_add, size: 32),
      ),
    );
  }
}

class _PersonSearchDelegate extends SearchDelegate {
  final List<Person> people;

  _PersonSearchDelegate(this.people);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.clear,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final results = query.isEmpty
        ? people
        : people.where((person) => person.name.toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (BuildContext context, int index) {
        final person = results[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: person.imagePath.startsWith('assets/')
                ? AssetImage(person.imagePath) as ImageProvider
                : FileImage(File(person.imagePath)),
          ),
          title: Text(
            person.name,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          onTap: () {
            close(context, person);
          },
        );
      },
    );
  }
}