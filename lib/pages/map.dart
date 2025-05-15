import 'package:flutter/material.dart';
import 'profile.dart';
import 'remenber.dart';
import 'home.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  String name = 'Usuario';
  String email = 'usuario@ejemplo.com';

Future<void> _goToHome() async {
  Navigator.pop(context);
  await Future.delayed(const Duration(milliseconds: 250));
  if (!mounted) return;
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Inicio')),
  );
}

  Future<void> _goToProfile() async {
    Navigator.pop(context);
    await Future.delayed(const Duration(milliseconds: 250));
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfilePage()),
    );
  }

  Future<void> _goToRemember() async {
    Navigator.pop(context);
    await Future.delayed(const Duration(milliseconds: 250));
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RemenberPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Mapa'),
        backgroundColor: const Color.fromARGB(255, 3, 99, 179),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(color: Color.fromARGB(255, 3, 99, 179)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.account_circle, size: 64, color: Colors.white),
                  const SizedBox(height: 8),
                  Text(name, style: const TextStyle(color: Colors.white, fontSize: 18)),
                  Text(email, style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            ListTile(
              title: const Text("Inicio"),
              onTap: _goToHome,
            ),
            ListTile(
              title: const Text("Perfil"),
              onTap: _goToProfile,
            ),
            ListTile(
              title: const Text("Recordar"),
              onTap: _goToRemember,
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Image.asset(
            'assets/images/mapa.jpg',
            width: screenWidth * 0.9,
            height: screenHeight * 0.7,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}