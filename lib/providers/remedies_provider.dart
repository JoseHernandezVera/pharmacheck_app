import 'package:flutter/material.dart';
import '../models/remedy_model.dart';

class RemediesProvider with ChangeNotifier {
  final Map<String, List<Remedy>> _remedies = {};

  List<Remedy> getRemediesForPerson(String personName) {
    return _remedies[personName] ?? [];
  }

  void addRemedy(String personName, String name, String time) {
    if (!_remedies.containsKey(personName)) {
      _remedies[personName] = [];
    }
    _remedies[personName]!.add(Remedy(name: name, time: time));
    notifyListeners();
  }

  void toggleRemedyStatus(String personName, int index) {
    if (_remedies.containsKey(personName) && index < _remedies[personName]!.length) {
      _remedies[personName]![index].isTaken = !_remedies[personName]![index].isTaken;
      notifyListeners();
    }
  }

  void removeRemedy(String personName, int index) {
    if (_remedies.containsKey(personName) && index < _remedies[personName]!.length) {
      _remedies[personName]!.removeAt(index);
      notifyListeners();
    }
  }
}