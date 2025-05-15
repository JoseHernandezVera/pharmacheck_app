import 'package:flutter/material.dart';

class ClientesPage extends StatefulWidget {
  final String name;

  const ClientesPage({super.key, required this.name});

  @override
  State<ClientesPage> createState() => _ClientesPageState();
}

class _ClientesPageState extends State<ClientesPage> {
  final List<Map<String, dynamic>> remedies = [];

  int? _selectedRemedyIndexForDeletion;

  void _addRemedy(String name, String time) {
    setState(() {
      remedies.add({
        'name': name,
        'time': time,
        'isTaken': false,
      });
    });
  }

  void _deleteRemedy(int index) {
    setState(() {
      remedies.removeAt(index);
      _selectedRemedyIndexForDeletion = null;
    });
  }

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
                          int hour = i + 1;
                          return DropdownMenuItem(
                            value: hour,
                            child: Text(hour.toString().padLeft(2, '0')),
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
                          _addRemedy(nameController.text.trim(), formattedTime);
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
                            title: Text(remedy['name']),
                            subtitle: Text('Hora: ${remedy['time']}'),
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
                          _deleteRemedy(_selectedRemedyIndexForDeletion!);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 110, 179, 235),
      appBar: AppBar(
        toolbarHeight: 150,
        backgroundColor: const Color.fromARGB(255, 3, 99, 179),
        centerTitle: true,
        title: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/images/perfil.jpg'),
            ),
            const SizedBox(height: 8),
            Text(
              widget.name,
              style: const TextStyle(
                fontSize: 40,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: remedies.isEmpty
          ? const Center(child: Text('No hay remedios registrados.'))
          : ListView.builder(
              itemCount: remedies.length,
              itemBuilder: (context, index) {
                final remedy = remedies[index];
                final isTaken = remedy['isTaken'] as bool;

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: isTaken ? Colors.green[200] : const Color.fromARGB(255, 255, 255, 255),
                    border: Border.all(color: Colors.black, width: 3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.medication),
                    title: Text(remedy['name']),
                    subtitle: Text('Hora: ${remedy['time']}'),
                    trailing: Checkbox(
                      value: isTaken,
                      onChanged: (value) {
                        setState(() {
                          remedies[index]['isTaken'] = value!;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showActionChoiceDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}