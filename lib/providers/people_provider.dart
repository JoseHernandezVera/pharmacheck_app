import 'package:flutter/material.dart';
import '../models/person_model.dart';

class PeopleProvider with ChangeNotifier {
  final List<Person> _people = [
    Person(name: 'Jonathan Catalan', image: 'assets/images/perfil.jpg'),
    Person(name: 'Fabian Arevalo', image: 'assets/images/perfil.jpg'),
    Person(name: 'Martin Bascuñan', image: 'assets/images/perfil.jpg'),
  ];

  List<Person> get people => _people;

  void addPerson(String name) {
    _people.add(Person(name: name, image: 'assets/images/perfil.jpg'));
    notifyListeners();
  }

  void removePerson(int index) {
    _people.removeAt(index);
    notifyListeners();
  }
}