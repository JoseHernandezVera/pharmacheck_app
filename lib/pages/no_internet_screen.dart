import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:io';
import 'splash.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  Future<bool> _checkRealInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 110, 179, 235),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, size: 80, color: Colors.white),
            const SizedBox(height: 20),
            const Text(
              'Sin conexión a internet',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 3, 99, 179),
              ),
              onPressed: () async {
                final connectivityResult = await Connectivity().checkConnectivity();
                final hasNetwork = connectivityResult != ConnectivityResult.none;
                final hasInternet = hasNetwork && await _checkRealInternet();

                if (hasInternet && context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const SplashPage()),
                  );
                } else if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Aún sin conexión a internet"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text('Reintentar', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}