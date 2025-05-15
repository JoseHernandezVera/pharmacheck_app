import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home.dart';
import 'profile.dart';
import 'remenber.dart';
import 'user_data.dart';

class BasePage extends StatelessWidget {
  final String title;

  const BasePage({
    super.key,
    required this.title,
  });

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.pop(context);
    Future.delayed(const Duration(milliseconds: 250), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => page),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context);

    Widget buildMenuItem(String text, VoidCallback onTap) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          title: Text(text),
          onTap: onTap,
        ),
      );
    }

    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(userData.name),
                accountEmail: Text(userData.email),
                currentAccountPicture: const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/perfil.jpg'),
                ),
                decoration: const BoxDecoration(color: Colors.blue),
              ),
              buildMenuItem("Home", () => _navigateTo(context, const MyHomePage(title: 'Home'))),
              buildMenuItem("Profile", () => _navigateTo(context, ProfilePage())),
              buildMenuItem("Remember", () => _navigateTo(context, const RememberPage())),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: ListTile(
              leading: Image.asset(
                'assets/images/salida.png',
                width: 24,
                height: 24,
                color: Colors.red,
              ),
              title: const Text(
                'Cerrar sesión',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}