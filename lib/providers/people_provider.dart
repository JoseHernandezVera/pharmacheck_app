import 'package:flutter/material.dart';
import '../models/person_model.dart';

class PeopleProvider with ChangeNotifier {
  final List<Person> _people = [
    Person(name: 'Jonathan Catalan', imagePath: 'assets/images/perfil.jpg'),
    Person(name: 'Fabian Arevalo', imagePath: 'assets/images/perfil.jpg'),
    Person(name: 'Martin Bascuñan', imagePath: 'assets/images/perfil.jpg'),
  ];

  List<Person> get people => _people;

  void addPerson(String name, String imagePath) {
    _people.add(Person(name: name, imagePath: imagePath));
    notifyListeners();
  }

  void removePerson(int index) {
    _people.removeAt(index);
    notifyListeners();
  }

  void editPerson(int index, String newName) {
    _people[index] = Person(
      name: newName,
      imagePath: _people[index].imagePath,
    );
    notifyListeners();
  }

  void updatePersonImage(int index, String newImagePath) {
    final person = people[index];
    people[index] = Person(
      name: person.name,
      imagePath: newImagePath,
    );
    notifyListeners();
  }
}