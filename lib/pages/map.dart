import 'package:flutter/material.dart';
import '../models/model_drawer.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: const ModelDrawer(),
      appBar: AppBar(
        title: Text(
          'Mapa',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.menu,
              size: 32,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.shadow,
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/images/mapa.jpg',
                width: screenWidth * 0.9,
                height: screenHeight * 0.7,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}