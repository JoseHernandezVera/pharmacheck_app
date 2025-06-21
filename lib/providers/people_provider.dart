import 'package:flutter/material.dart';
import '../models/person_model.dart';

class PeopleProvider with ChangeNotifier {
  final Map<String, List<Person>> _peopleByUser = {};
  String _currentEmail = '';

  void setCurrentUserEmail(String email) {
    _currentEmail = email;
    _peopleByUser.putIfAbsent(email, () => []);
    notifyListeners();
  }

  List<Person> get people => _peopleByUser[_currentEmail] ?? [];

  void addPerson(String name, String imagePath) {
    _peopleByUser[_currentEmail] ??= [];
    _peopleByUser[_currentEmail]!.add(Person(name: name, imagePath: imagePath));
    notifyListeners();
  }

  void removePerson(int index) {
    _peopleByUser[_currentEmail]?.removeAt(index);
    notifyListeners();
  }

  void editPerson(int index, String newName) {
    final person = _peopleByUser[_currentEmail]?[index];
    if (person != null) {
      _peopleByUser[_currentEmail]![index] = Person(
        name: newName,
        imagePath: person.imagePath,
      );
      notifyListeners();
    }
  }

  void updatePersonImage(int index, String newImagePath) {
    final person = _peopleByUser[_currentEmail]?[index];
    if (person != null) {
      _peopleByUser[_currentEmail]![index] = Person(
        name: person.name,
        imagePath: newImagePath,
      );
      notifyListeners();
    }
  }
}
