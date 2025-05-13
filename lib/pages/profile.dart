import 'package:flutter/material.dart';
import 'base_pages.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Profile',
      body: const Center(
        child: Text("Esta es la pagina de perfil", style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
