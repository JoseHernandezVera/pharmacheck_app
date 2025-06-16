import 'package:flutter/material.dart';
import '../models/model_drawer.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const ModelDrawer(),
      appBar: AppBar(
        title: const Text(
          'Mapa',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 3, 99, 179),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, size: 32),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
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