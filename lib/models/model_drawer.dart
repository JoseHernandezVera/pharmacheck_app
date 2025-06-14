import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../pages/home.dart';
import '../pages/profile.dart';
import '../pages/remenber.dart';

class ModelDrawer extends StatelessWidget {
  const ModelDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    String _truncateText(String text, int maxLength) {
      if (text.length <= maxLength) return text;
      return '${text.substring(0, maxLength)}...';
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              _truncateText(userProvider.user.name, 10),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              _truncateText(userProvider.user.email, 15),
              style: const TextStyle(fontSize: 16),
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.account_circle, size: 60, color: Colors.blue),
            ),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 3, 99, 179),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home, color: Colors.blue),
            title: const Text("Inicio", style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Inicio')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.blue),
            title: const Text("Perfil", style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications, color: Colors.blue),
            title: const Text("Recordar", style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const RemenberPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}