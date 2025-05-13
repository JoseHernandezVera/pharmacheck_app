import 'package:flutter/material.dart';
import 'profile.dart';
import 'remenber.dart';
import 'splash.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: const Center(child: Text("Bienvenido", style: TextStyle(fontSize: 24))),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Drawer Header', style: TextStyle(color: Colors.white)),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () => _navigateTo(context, const HomePage()),
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
      ),
    );
  }
}
