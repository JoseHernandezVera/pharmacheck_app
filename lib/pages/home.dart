import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import '../providers/people_provider.dart';
import '../providers/remedies_provider.dart';
import '../models/person_model.dart';
import 'clientes.dart';
import '../models/model_drawer.dart';
import '../providers/settings_provider.dart';

enum FilterType { all, critical, ready }

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final ImagePicker _picker = ImagePicker();
  FilterType _currentFilter = FilterType.all;

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
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    
    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Seleccionar imagen',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: settings.subtitleFontSize,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(
                    Icons.photo_library,
                    color: Theme.of(context).colorScheme.primary,
                    size: settings.iconSize * 0.8,
                  ),
                  title: Text(
                    'Galería',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: settings.subtitleFontSize,
                    ),
                  ),
                  onTap: () async {
                    final image = await _pickImage(fromCamera: false);
                    if (context.mounted) {
                      Navigator.pop(context, image);
                    }
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.camera_alt,
                    color: Theme.of(context).colorScheme.primary,
                    size: settings.iconSize * 0.8,
                  ),
                  title: Text(
                    'Cámara',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: settings.subtitleFontSize,
                    ),
                  ),
                  onTap: () async {
                    final image = await _pickImage(fromCamera: true);
                    if (context.mounted) {
                      Navigator.pop(context, image);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddPersonDialog(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
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
                  fontSize: settings.titleFontSize,
                ),
              ),
              backgroundColor: Theme.of(context).colorScheme.surface,
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final newImage = await _showImageSourceDialog(context);
                        if (newImage != null && mounted) {
                          setState(() {
                            imagePath = newImage;
                          });
                        }
                      },
                      child: CircleAvatar(
                        radius: settings.avatarRadius,
                        backgroundImage: imagePath.startsWith('assets/')
                            ? AssetImage(imagePath) as ImageProvider
                            : FileImage(File(imagePath)),
                        child: Icon(
                          Icons.camera_alt, 
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: settings.iconSize * 0.7,
                        ),
                      ),
                    ),
                    SizedBox(height: settings.cardPadding.vertical),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Nombre',
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: settings.subtitleFontSize,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: settings.subtitleFontSize,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancelar',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: settings.subtitleFontSize,
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
                  child: Text(
                    'Agregar',
                    style: TextStyle(fontSize: settings.subtitleFontSize),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, Person person, Function(String) onImageUpdated) {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
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
                  fontSize: settings.titleFontSize,
                ),
              ),
              backgroundColor: Theme.of(context).colorScheme.surface,
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final newImage = await _showImageSourceDialog(context);
                        if (newImage != null && mounted) {
                          setState(() {
                            currentImagePath = newImage;
                          });
                          onImageUpdated(newImage);
                        }
                      },
                      child: CircleAvatar(
                        radius: settings.avatarRadius,
                        backgroundImage: currentImagePath.startsWith('assets/')
                            ? AssetImage(currentImagePath) as ImageProvider
                            : FileImage(File(currentImagePath)),
                        child: Icon(
                          Icons.camera_alt, 
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: settings.iconSize * 0.7,
                        ),
                      ),
                    ),
                    SizedBox(height: settings.cardPadding.vertical),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Nombre',
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: settings.subtitleFontSize,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: settings.subtitleFontSize,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancelar',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: settings.subtitleFontSize,
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
                  child: Text(
                    'Guardar',
                    style: TextStyle(fontSize: settings.subtitleFontSize),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, Person person) {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final peopleProvider = Provider.of<PeopleProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Eliminar persona',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: settings.titleFontSize,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
          content: Text(
            '¿Eliminar a ${person.name}?',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: settings.subtitleFontSize,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: settings.subtitleFontSize,
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
              child: Text(
                'Eliminar',
                style: TextStyle(fontSize: settings.subtitleFontSize),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilterButton(BuildContext context, String text, FilterType filterType, IconData icon) {
    final isSelected = _currentFilter == filterType;
    final settings = Provider.of<SettingsProvider>(context);
    
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _currentFilter = filterType;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
            ? Theme.of(context).colorScheme.primaryContainer
            : Theme.of(context).colorScheme.surface,
        foregroundColor: isSelected
            ? Theme.of(context).colorScheme.onPrimaryContainer
            : Theme.of(context).colorScheme.onSurface,
        padding: EdgeInsets.symmetric(
          horizontal: settings.cardPadding.horizontal * 0.5,
          vertical: settings.cardPadding.vertical * 0.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: settings.iconSize * 0.5),
          const SizedBox(width: 4),
          Text(
            text, 
            style: TextStyle(fontSize: settings.subtitleFontSize),
          ),
        ],
      ),
    );
  }

  String _getEmptyStateMessage() {
    if (_searchQuery.isNotEmpty) return 'No se encontraron resultados';
    
    switch (_currentFilter) {
      case FilterType.critical:
        return 'No hay personas críticas';
      case FilterType.ready:
        return 'No hay personas listas';
      case FilterType.all:
        return 'No hay personas registradas';
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final peopleProvider = Provider.of<PeopleProvider>(context);
    final remediesProvider = Provider.of<RemediesProvider>(context);
    
    final filteredPeople = _searchQuery.isEmpty
        ? peopleProvider.people
        : peopleProvider.people
            .where((person) => person.name.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

    final displayedPeople = filteredPeople.where((person) {
      final hasDueRemedies = remediesProvider.isAnyRemedyDueSoon(person.name);
      final allRemediesTaken = remediesProvider.areAllRemediesTaken(person.name);
      
      switch (_currentFilter) {
        case FilterType.critical:
          return hasDueRemedies;
        case FilterType.ready:
          return allRemediesTaken;
        case FilterType.all:
          return true;
      }
    }).toList();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: const ModelDrawer(),
      appBar: AppBar(
        title: Text(
          '',
          style: TextStyle(
            fontSize: settings.titleFontSize * 1.5,
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(
                Icons.menu, 
                size: settings.iconSize,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).colorScheme.primary,
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: settings.cardPadding.vertical * 1.5,
              horizontal: settings.cardPadding.horizontal * 1.5,
            ),
            child: Column(
              children: [
                Text(
                  'LISTA DE PERSONAS',
                  style: TextStyle(
                    fontSize: settings.titleFontSize * 1.5,
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: settings.cardPadding.vertical),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: settings.cardPadding.horizontal * 1.5,
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                      hintText: 'Buscar personas...',
                      hintStyle: TextStyle(
                        fontSize: settings.subtitleFontSize,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        size: settings.iconSize * 0.7,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: settings.cardPadding.vertical * 0.5,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: settings.subtitleFontSize,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
                SizedBox(height: settings.cardPadding.vertical * 0.5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildFilterButton(
                      context,
                      'Todos',
                      FilterType.all,
                      Icons.people_alt,
                    ),
                    _buildFilterButton(
                      context,
                      'Críticos',
                      FilterType.critical,
                      Icons.warning,
                    ),
                    _buildFilterButton(
                      context,
                      'Listos',
                      FilterType.ready,
                      Icons.check_circle,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: settings.cardPadding,
              child: displayedPeople.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people,
                            size: settings.avatarRadius * 2,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          SizedBox(height: settings.cardPadding.vertical * 2),
                          Text(
                            _getEmptyStateMessage(),
                            style: TextStyle(
                              fontSize: settings.titleFontSize,
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: settings.crossAxisCount,
                        crossAxisSpacing: settings.cardPadding.horizontal,
                        mainAxisSpacing: settings.cardPadding.vertical,
                        childAspectRatio: settings.childAspectRatio,
                      ),
                      itemCount: displayedPeople.length,
                      itemBuilder: (BuildContext context, int index) {
                        final person = displayedPeople[index];
                        final hasDueRemedies = remediesProvider.isAnyRemedyDueSoon(person.name);
                        final allRemediesTaken = remediesProvider.areAllRemediesTaken(person.name);

                        Color cardColor;
                        if (allRemediesTaken) {
                          cardColor = const Color.fromARGB(255, 25, 169, 29);
                        } else if (hasDueRemedies) {
                          cardColor = const Color.fromARGB(255, 198, 33, 50);
                        } else {
                          cardColor = Theme.of(context).colorScheme.surfaceContainer;
                        }

                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: cardColor,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return Stack(
                                children: [
                                  InkWell(
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
                                      padding: EdgeInsets.all(constraints.maxWidth * 0.05),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          CircleAvatar(
                                            radius: constraints.maxWidth * 0.24,
                                            backgroundImage: person.imagePath.startsWith('assets/')
                                                ? AssetImage(person.imagePath) as ImageProvider
                                                : FileImage(File(person.imagePath)),
                                          ),
                                          Flexible(
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: constraints.maxWidth * 0.05),
                                                constraints: BoxConstraints(
                                                  maxWidth: constraints.maxWidth * 0.9,
                                                ),
                                                child: Text(
                                                  person.name,
                                                  style: TextStyle(
                                                    fontSize: 30,
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context).colorScheme.onSurface,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              IconButton(
                                                icon: Icon(
                                                  Icons.edit,
                                                  size: constraints.maxWidth * 0.12,
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
                                                  size: constraints.maxWidth * 0.12,
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
                                  if (allRemediesTaken)
                                    Positioned(
                                      top: constraints.maxHeight * 0.02,
                                      right: constraints.maxWidth * 0.02,
                                      child: Container(
                                        padding: EdgeInsets.all(constraints.maxWidth * 0.05),
                                        decoration: const BoxDecoration(
                                          color: Colors.green,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.check,
                                          size: constraints.maxWidth * 0.08,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
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
        child: Icon(
          Icons.person_add, 
          size: settings.iconSize,
        ),
      ),
    );
  }
}