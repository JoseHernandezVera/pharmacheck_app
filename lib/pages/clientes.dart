import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../providers/remedies_provider.dart';
import '../models/remedy_model.dart';
import '../models/model_drawer.dart';
import 'map.dart';

class ClientesPage extends StatefulWidget {
  final String name;
  final String imagePath;

  const ClientesPage({
    super.key, 
    required this.name,
    required this.imagePath,
  });

  @override
  State<ClientesPage> createState() => _ClientesPageState();
}

class _ClientesPageState extends State<ClientesPage> {
  int? _selectedRemedyIndexForDeletion;
  int _selectedIndex = 0;
  late String _currentImagePath;
  
  final List<String> _hours = List.generate(24, (index) => index.toString().padLeft(2, '0'));
  final List<String> _minutes = List.generate(60, (index) => index.toString().padLeft(2, '0'));

  @override
  void initState() {
    super.initState();
    _currentImagePath = widget.imagePath;
  }

  void _showEditRemedyDialog(int index) {
    final remediesProvider = Provider.of<RemediesProvider>(context, listen: false);
    final remedies = remediesProvider.getRemediesForPerson(widget.name);
    final remedy = remedies[index];
    
    final TextEditingController nameController = TextEditingController(text: remedy.name);
    
    final timeParts = remedy.time.split(':');
    String selectedHour = timeParts[0];
    String selectedMinute = timeParts[1];
    
    bool canSave = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            nameController.addListener(() {
              final isNotEmpty = nameController.text.trim().isNotEmpty;
              if (isNotEmpty != canSave) {
                setStateDialog(() {
                  canSave = isNotEmpty;
                });
              }
            });

            return AlertDialog(
              title: const Text('Editar remedio'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Nombre del remedio',
                      labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedHour,
                          items: _hours.map((hour) {
                            return DropdownMenuItem(
                              value: hour,
                              child: Text(
                                hour,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setStateDialog(() {
                                selectedHour = value;
                              });
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Hora',
                            labelStyle: TextStyle(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        ':',
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedMinute,
                          items: _minutes.map((minute) {
                            return DropdownMenuItem(
                              value: minute,
                              child: Text(
                                minute,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setStateDialog(() {
                                selectedMinute = value;
                              });
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Minutos',
                            labelStyle: TextStyle(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              backgroundColor: Theme.of(context).colorScheme.surface,
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
                          remediesProvider.updateRemedy(
                            widget.name, 
                            index,
                            name: nameController.text.trim(),
                            time: '$selectedHour:$selectedMinute',
                          );
                          Navigator.pop(context);
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

  void _showAddRemedyDialog() {
    final TextEditingController nameController = TextEditingController();
    String selectedHour = '08';
    String selectedMinute = '00';
    bool canAdd = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            nameController.addListener(() {
              final isNotEmpty = nameController.text.trim().isNotEmpty;
              if (isNotEmpty != canAdd) {
                setStateDialog(() {
                  canAdd = isNotEmpty;
                });
              }
            });

            return AlertDialog(
              title: const Text('Agregar remedio'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Nombre del remedio',
                      labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedHour,
                          items: _hours.map((hour) {
                            return DropdownMenuItem(
                              value: hour,
                              child: Text(
                                hour,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setStateDialog(() {
                                selectedHour = value;
                              });
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Hora',
                            labelStyle: TextStyle(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        ':',
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedMinute,
                          items: _minutes.map((minute) {
                            return DropdownMenuItem(
                              value: minute,
                              child: Text(
                                minute,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setStateDialog(() {
                                selectedMinute = value;
                              });
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Minutos',
                            labelStyle: TextStyle(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              backgroundColor: Theme.of(context).colorScheme.surface,
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
                          Provider.of<RemediesProvider>(context, listen: false)
                              .addRemedy(widget.name, nameController.text.trim(), '$selectedHour:$selectedMinute');
                          Navigator.pop(context);
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

  void _showDeleteRemedyDialog() {
    _selectedRemedyIndexForDeletion = null;
    final remediesProvider = Provider.of<RemediesProvider>(context, listen: false);
    final remedies = remediesProvider.getRemediesForPerson(widget.name);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Eliminar remedio'),
              backgroundColor: Theme.of(context).colorScheme.surface,
              content: remedies.isEmpty
                  ? Text(
                      'No hay remedios para eliminar.',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    )
                  : SizedBox(
                      width: double.maxFinite,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: remedies.length,
                        itemBuilder: (context, index) {
                          final remedy = remedies[index];
                          final isSelected = _selectedRemedyIndexForDeletion == index;
                          return ListTile(
                            title: Text(
                              remedy.name,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            subtitle: Text(
                              'Hora: ${remedy.time}',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                            tileColor: isSelected 
                                ? Theme.of(context).colorScheme.errorContainer 
                                : null,
                            onTap: () {
                              setStateDialog(() {
                                _selectedRemedyIndexForDeletion = index;
                              });
                            },
                          );
                        },
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
                  onPressed: _selectedRemedyIndexForDeletion == null
                      ? null
                      : () {
                          remediesProvider.removeRemedy(widget.name, _selectedRemedyIndexForDeletion!);
                          Navigator.pop(context);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.error,
                    foregroundColor: Theme.of(context).colorScheme.onError,
                  ),
                  child: const Text('Borrar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showActionChoiceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          '¿Qué deseas hacer?',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showAddRemedyDialog();
            },
            child: Text(
              'Agregar remedio',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showDeleteRemedyDialog();
            },
            child: Text(
              'Eliminar remedio',
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MapPage()),
      );
    } else if (index == 1) {
      _showActionChoiceDialog();
    }
  }

  List<Remedy> _sortRemedies(List<Remedy> remedies) {
    final now = DateTime.now();
    final currentHour = now.hour;
    final currentMinute = now.minute;

    remedies.sort((a, b) {
      final aTimeParts = a.time.split(':');
      final bTimeParts = b.time.split(':');
      
      final aHour = int.parse(aTimeParts[0]);
      final aMinute = int.parse(aTimeParts[1]);
      final bHour = int.parse(bTimeParts[0]);
      final bMinute = int.parse(bTimeParts[1]);

      int aDiff = (aHour - currentHour) * 60 + (aMinute - currentMinute);
      int bDiff = (bHour - currentHour) * 60 + (bMinute - currentMinute);

      if (aDiff < 0) aDiff += 24 * 60;
      if (bDiff < 0) bDiff += 24 * 60;

      return aDiff.compareTo(bDiff);
    });

    return remedies;
  }

  @override
  Widget build(BuildContext context) {
    final remediesProvider = Provider.of<RemediesProvider>(context);
    final remedies = _sortRemedies(remediesProvider.getRemediesForPerson(widget.name));

    return Scaffold(
      drawer: const ModelDrawer(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        toolbarHeight: 150,
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
        centerTitle: true,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: _currentImagePath.startsWith('assets/')
                  ? AssetImage(_currentImagePath) as ImageProvider
                  : FileImage(File(_currentImagePath)),
            ),
            const SizedBox(height: 8),
            Text(
              widget.name,
              style: TextStyle(
                fontSize: 30,
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: remedies.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.medication,
                    size: 60,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'No hay remedios registrados',
                    style: TextStyle(
                      fontSize: 24,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _showAddRemedyDialog,
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
                      'Agregar Primer Remedio',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(top: 20),
              itemCount: remedies.length,
              itemBuilder: (context, index) {
                final remedy = remedies[index];
                final isTaken = remedy.isTaken;

                return Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: isTaken
                        ? Colors.green[700]
                        : Theme.of(context).colorScheme.surfaceContainer,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.shadow,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    leading: IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () => _showEditRemedyDialog(index),
                    ),
                    title: Text(
                      remedy.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    subtitle: Text(
                      'Hora: ${remedy.time}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    trailing: Checkbox(
                      value: isTaken,
                      onChanged: (value) {
                        remediesProvider.toggleRemedyStatus(widget.name, index);
                      },
                      activeColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTap,
        backgroundColor: Theme.of(context).colorScheme.primary,
        selectedItemColor: Theme.of(context).colorScheme.onPrimary,
        unselectedItemColor: Theme.of(context).colorScheme.onPrimary,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.map, 
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            label: 'Donde vive',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add, 
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            label: 'Más remedios',
          ),
        ],
      ),
    );
  }
}