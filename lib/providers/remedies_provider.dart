import 'package:flutter/material.dart';
import '../models/remedy_model.dart';
import 'dart:async';
import '../notification/notification_service.dart';

class RemediesProvider with ChangeNotifier {
  final Map<String, List<Remedy>> _userRemedies = {};
  Timer? _updateTimer;
  final NotificationService _notificationService = NotificationService();

  RemediesProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    await _notificationService.initialize();
    _startUpdateTimer();
  }

  void _startUpdateTimer() {
    _updateTimer?.cancel();
    _updateTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      _checkDueRemedies();
      notifyListeners();
    });
  }

  void _checkDueRemedies() {
    for (final userEmail in _userRemedies.keys) {
      final remedies = getRemediesForUser(userEmail);
      for (final remedy in remedies) {
        if (remedy.isTaken) continue;

        final now = DateTime.now();
        final timeParts = remedy.time.split(':');
        
        try {
          final remedyTime = DateTime(
            now.year,
            now.month,
            now.day,
            int.parse(timeParts[0]),
            int.parse(timeParts[1]),
          );

          final difference = remedyTime.difference(now);
          
          if (difference.inMinutes == 60) {
            _scheduleNotification(
              userEmail: userEmail,
              remedy: remedy,
              minutesBefore: 60,
            );
          }
          
          if (difference.inMinutes == 15) {
            _scheduleNotification(
              userEmail: userEmail,
              remedy: remedy,
              minutesBefore: 15,
            );
          }
        } catch (e) {
          debugPrint('Error al verificar remedio: $e');
        }
      }
    }
  }

  void _scheduleNotification({
    required String userEmail,
    required Remedy remedy,
    required int minutesBefore,
  }) {
    final timeParts = remedy.time.split(':');
    final now = DateTime.now();
    final notificationTime = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
    ).subtract(Duration(minutes: minutesBefore));

    _notificationService.scheduleRemedyNotification(
      title: 'Recordatorio de remedio',
      body: '$userEmail debe tomar ${remedy.name} en $minutesBefore minutos',
      scheduledTime: notificationTime,
      id: _generateNotificationId(userEmail, remedy.name, minutesBefore),
    );
  }

  int _generateNotificationId(String userEmail, String remedyName, int minutesBefore) {
    return userEmail.hashCode + remedyName.hashCode + minutesBefore;
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    _notificationService.cancelAllNotifications();
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
      
      if (remedies[index].isTaken) {
        _notificationService.cancelNotification(
          _generateNotificationId(userEmail, remedies[index].name, 60));
        _notificationService.cancelNotification(
          _generateNotificationId(userEmail, remedies[index].name, 15));
      }
      
      notifyListeners();
    }
  }

  void removeRemedy(String userEmail, int index) {
    final remedies = _userRemedies[userEmail];
    if (remedies != null && index < remedies.length) {
      _notificationService.cancelNotification(
        _generateNotificationId(userEmail, remedies[index].name, 60));
      _notificationService.cancelNotification(
        _generateNotificationId(userEmail, remedies[index].name, 15));
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
