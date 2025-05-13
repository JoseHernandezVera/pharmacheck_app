import 'package:flutter/material.dart';
import 'home.dart';
import 'profile.dart';
import 'remenber.dart';

class BasePage extends StatelessWidget {
  final String title;
  final Widget body;

  const BasePage({
    super.key,
    required this.title,
    required this.body,
  });

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.pop(context);
    Future.delayed(const Duration(milliseconds: 250), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => page),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: body,
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                UserAccountsDrawerHeader(
                  accountName: const Text('Jose Hernandez'),
                  accountEmail: const Text('jose@gmail.com'),
                  currentAccountPicture: const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/perfil.jpg'),
                  ),
                  decoration: const BoxDecoration(color: Colors.blue),
                ),
                ListTile(
                  title: const Text('Home'),
                  onTap: () => _navigateTo(context, const MyHomePage(title: 'Home')),
                ),
                ListTile(
                  title: const Text('Profile'),
                  onTap: () => _navigateTo(context, const ProfilePage()),
                ),
                ListTile(
                  title: const Text('Remember'),
                  onTap: () => _navigateTo(context, const RememberPage()),
                ),
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
                  'Cerrar sesion',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
