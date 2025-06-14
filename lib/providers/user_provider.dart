import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  User _user = User(
    name: 'Usuario',
    email: 'usuario@ejemplo.com',
    birthdate: '11/08/2003',
    phone: '123456789',
  );

  User get user => _user;

  void updateUser({
    String? name,
    String? email,
    String? birthdate,
    String? phone,
  }) {
    _user = User(
      name: name ?? _user.name,
      email: email ?? _user.email,
      birthdate: birthdate ?? _user.birthdate,
      phone: phone ?? _user.phone,
    );
    notifyListeners();
  }
}