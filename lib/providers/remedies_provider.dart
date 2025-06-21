import 'package:flutter/material.dart';
import '../models/remedy_model.dart';
import 'dart:async';

class RemediesProvider with ChangeNotifier {
  final Map<String, List<Remedy>> _userRemedies = {};
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

  List<Remedy> getRemediesForUser(String userEmail) {
    return _userRemedies[userEmail] ?? [];
  }

  void addRemedyForUser(String userEmail, String name, String time) {
    if (!_userRemedies.containsKey(userEmail)) {
      _userRemedies[userEmail] = [];
    }
    _userRemedies[userEmail]!.add(Remedy(name: name, time: time));
    notifyListeners();
  }

  void toggleRemedyStatus(String userEmail, int index) {
    final remedies = _userRemedies[userEmail];
    if (remedies != null && index < remedies.length) {
      remedies[index].isTaken = !remedies[index].isTaken;
      notifyListeners();
    }
  }

  void removeRemedy(String userEmail, int index) {
    final remedies = _userRemedies[userEmail];
    if (remedies != null && index < remedies.length) {
      remedies.removeAt(index);
      notifyListeners();
    }
  }

  void updateRemedy(String userEmail, int index, {String? name, String? time}) {
    final remedies = _userRemedies[userEmail];
    if (remedies != null && index < remedies.length) {
      final remedy = remedies[index];
      if (name != null) remedy.name = name;
      if (time != null) remedy.time = time;
      notifyListeners();
    }
  }

  bool isAnyRemedyDueSoon(String userEmail) {
    final remedies = getRemediesForUser(userEmail);
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
          int.parse(timeParts[1]),
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

  bool areAllRemediesTaken(String userEmail) {
    final remedies = getRemediesForUser(userEmail);
    if (remedies.isEmpty) return false;
    return remedies.every((r) => r.isTaken);
  }

  CardStatus getCardStatus(String userEmail) {
    if (areAllRemediesTaken(userEmail)) {
      return CardStatus.allTaken;
    } else if (isAnyRemedyDueSoon(userEmail)) {
      return CardStatus.dueSoon;
    }
    return CardStatus.normal;
  }
}

enum CardStatus {
  normal,
  dueSoon,
  allTaken,
}
