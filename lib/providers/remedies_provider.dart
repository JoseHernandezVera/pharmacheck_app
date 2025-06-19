import 'package:flutter/material.dart';
import '../models/remedy_model.dart';
import 'dart:async';

class RemediesProvider with ChangeNotifier {
  final Map<String, List<Remedy>> _remedies = {};
  Timer? _updateTimer;

  RemediesProvider() {
    _startUpdateTimer();
  }

  void _startUpdateTimer() {
    _updateTimer?.cancel();
    _updateTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

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

  bool isAnyRemedyDueSoon(String personName) {
    final remedies = getRemediesForPerson(personName);
    if (remedies.isEmpty) return false;

    final now = DateTime.now();
    
    for (final remedy in remedies) {
      if (remedy.isTaken) continue;
      
      try {
        final timeParts = remedy.time.split(':');
        final remedyTime = DateTime(
          now.year, 
          now.month, 
          now.day,
          int.parse(timeParts[0]), 
          int.parse(timeParts[1])
        );
        
        final difference = remedyTime.difference(now);
        if (difference.inMinutes <= 60 && difference.inMinutes > 0) {
          return true;
        }
      } catch (e) {
        debugPrint('Error al parsear hora del remedio: $e');
      }
    }
    
    return false;
  }

  bool areAllRemediesTaken(String personName) {
    final remedies = getRemediesForPerson(personName);
    if (remedies.isEmpty) return false;
    
    return remedies.every((remedy) => remedy.isTaken);
  }

  CardStatus getCardStatus(String personName) {
    if (areAllRemediesTaken(personName)) {
      return CardStatus.allTaken;
    } else if (isAnyRemedyDueSoon(personName)) {
      return CardStatus.dueSoon;
    }
    return CardStatus.normal;
  }

  void updateRemedy(String personName, int index, {String? name, String? time}) {
    if (_remedies.containsKey(personName) && index < _remedies[personName]!.length) {
      final remedy = _remedies[personName]![index];
      if (name != null) remedy.name = name;
      if (time != null) remedy.time = time;
      notifyListeners();
    }
  }
}

enum CardStatus {
  normal,
  dueSoon,
  allTaken
}