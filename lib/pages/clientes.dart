import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/remedies_provider.dart';
import '../models/model_drawer.dart';
import 'map.dart';

class ClientesPage extends StatefulWidget {
  final String name;

  const ClientesPage({super.key, required this.name});

  @override
  State<ClientesPage> createState() => _ClientesPageState();
}

class _ClientesPageState extends State<ClientesPage> {
  int? _selectedRemedyIndexForDeletion;
  int _selectedIndex = 0;

  void _showAddRemedyDialog() {
    final TextEditingController nameController = TextEditingController();
    int selectedHour = 8;
    int selectedMinute = 0;
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
                    decoration: const InputDecoration(labelText: 'Nombre del remedio'),
                  ),
                  const SizedBox(height: 16),
                  const Text('Hora de toma', style: TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DropdownButton<int>(
                        value: selectedHour,
                        items: List.generate(24, (i) {
                          return DropdownMenuItem(
                            value: i,
                            child: Text(i.toString().padLeft(2, '0')),
                          );
                        }),
                        onChanged: (value) {
                          setStateDialog(() {
                            selectedHour = value!;
                          });
                        },
                      ),
                      const SizedBox(width: 10),
                      DropdownButton<int>(
                        value: selectedMinute,
                        items: List.generate(60, (i) {
                          return DropdownMenuItem(
                            value: i,
                            child: Text(i.toString().padLeft(2, '0')),
                          );
                        }),
                        onChanged: (value) {
                          setStateDialog(() {
                            selectedMinute = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: canAdd
                      ? () {
                          String formattedTime =
                              "${selectedHour.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')}";
                          Provider.of<RemediesProvider>(context, listen: false)
                              .addRemedy(widget.name, nameController.text.trim(), formattedTime);
                          Navigator.pop(context);
                        }
                      : null,
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
              content: remedies.isEmpty
                  ? const Text('No hay remedios para eliminar.')
                  : SizedBox(
                      width: double.maxFinite,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: remedies.length,
                        itemBuilder: (context, index) {
                          final remedy = remedies[index];
                          final isSelected = _selectedRemedyIndexForDeletion == index;
                          return ListTile(
                            title: Text(remedy.name),
                            subtitle: Text('Hora: ${remedy.time}'),
                            tileColor: isSelected ? Colors.red[100] : null,
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
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: _selectedRemedyIndexForDeletion == null
                      ? null
                      : () {
                          remediesProvider.removeRemedy(widget.name, _selectedRemedyIndexForDeletion!);
                          Navigator.pop(context);
                        },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
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
        title: const Text('¿Qué deseas hacer?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showAddRemedyDialog();
            },
            child: const Text('Agregar remedio'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showDeleteRemedyDialog();
            },
            child: const Text('Eliminar remedio'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
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

  @override
  Widget build(BuildContext context) {
    final remediesProvider = Provider.of<RemediesProvider>(context);
    final remedies = remediesProvider.getRemediesForPerson(widget.name);

    return Scaffold(
      drawer: const ModelDrawer(),
      backgroundColor: const Color.fromARGB(255, 110, 179, 235),
      appBar: AppBar(
        toolbarHeight: 150,
        backgroundColor: const Color.fromARGB(255, 3, 99, 179),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, size: 32, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        centerTitle: true,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/images/perfil.jpg'),
            ),
            const SizedBox(height: 8),
            Text(
              widget.name,
              style: const TextStyle(
                fontSize: 30,
                color: Colors.white,
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
                  const Text(
                    'No hay remedios registrados',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _showAddRemedyDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Agregar Primer Remedio',
                      style: TextStyle(
                        color: Color.fromARGB(255, 3, 99, 179),
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
                        ? Colors.green[200]
                        : const Color.fromARGB(255, 255, 255, 255),
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    leading: const Icon(Icons.medication,
                        size: 36, color: Colors.blue),
                    title: Text(
                      remedy.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Hora: ${remedy.time}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    trailing: Checkbox(
                      value: isTaken,
                      onChanged: (value) {
                        remediesProvider.toggleRemedyStatus(widget.name, index);
                      },
                      activeColor: Colors.green,
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTap,
        backgroundColor: const Color.fromARGB(255, 3, 99, 179),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map, color: Colors.white),
            label: 'Donde vive',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add, color: Colors.white),
            label: 'Más remedios',
          ),
        ],
      ),
    );
  }
}