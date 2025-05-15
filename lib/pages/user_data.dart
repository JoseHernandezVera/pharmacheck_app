import 'package:flutter/material.dart';

class UserData extends ChangeNotifier {
  String _name = 'Jose Hernandez';
  String _email = 'jose@gmail.com';

  String get name => _name;
  String get email => _email;

  void updateName(String newName) {
    _name = newName;
    notifyListeners();
  }

  void updateEmail(String newEmail) {
    _email = newEmail;
    notifyListeners();
  }
}