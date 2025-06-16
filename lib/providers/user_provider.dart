import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  User _user = User.guest();

  User get user => _user;

  Future<void> loginUser({
    required String email,
    String name = 'Usuario',
    String birthdate = '01/01/2000',
    String phone = '0000000000',
    String imageUrl = 'assets/images/perfil.jpg',
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    _user = User(
      name: name,
      email: email,
      birthdate: birthdate,
      phone: phone,
      imageUrl: imageUrl,
    );
    
    notifyListeners();
  }

  void logoutUser() {
    _user = User.guest();
    notifyListeners();
  }

  void updateUser({
    String? name,
    String? email,
    String? birthdate,
    String? phone,
    String? imageUrl,
  }) {
    _user = User(
      name: name ?? _user.name,
      email: email ?? _user.email,
      birthdate: birthdate ?? _user.birthdate,
      phone: phone ?? _user.phone,
      imageUrl: imageUrl ?? _user.imageUrl,
    );
    notifyListeners();
  }

  bool get isAuthenticated => _user.email != 'invitado@example.com';
}