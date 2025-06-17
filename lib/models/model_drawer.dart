import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../pages/home.dart';
import '../pages/profile.dart';
import '../pages/remenber.dart';
import 'dart:io';

class ModelDrawer extends StatelessWidget {
  const ModelDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    String truncateText(String text, int maxLength) {
      if (text.length <= maxLength) return text;
      return '${text.substring(0, maxLength)}...';
    }

    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              truncateText(userProvider.user.name, 10),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            accountEmail: Text(
              truncateText(userProvider.user.email, 15),
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.surface,
              backgroundImage: userProvider.user.imageUrl.startsWith('assets/')
                  ? AssetImage(userProvider.user.imageUrl) as ImageProvider
                  : FileImage(File(userProvider.user.imageUrl)),
              child: userProvider.user.imageUrl.isEmpty
                  ? Icon(
                      Icons.account_circle, 
                      size: 60, 
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : null,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(
              "Inicio", 
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Inicio')),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.person,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(
              "Perfil", 
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.notifications,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(
              "Recordar", 
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
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