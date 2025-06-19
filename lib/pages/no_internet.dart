import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NoInternetPage extends StatefulWidget {
  final VoidCallback onRetry;
  final String? previousRoute;

  const NoInternetPage({
    super.key,
    required this.onRetry,
    this.previousRoute,
  });

  @override
  State<NoInternetPage> createState() => _NoInternetPageState();
}

class _NoInternetPageState extends State<NoInternetPage> {
  bool _isCheckingConnection = false;

  Future<void> _checkConnectionAndRetry() async {
    setState(() => _isCheckingConnection = true);
    
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      widget.onRetry();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aún no hay conexión a Internet')),
      );
    }
    
    setState(() => _isCheckingConnection = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sin conexión'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.wifi_off,
              size: 80,
              color: Colors.red,
            ),
            const SizedBox(height: 20),
            const Text(
              'No hay conexión a Internet',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Por favor, verifica tu conexión e intenta nuevamente',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _isCheckingConnection ? null : _checkConnectionAndRetry,
              icon: _isCheckingConnection
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.refresh),
              label: Text(_isCheckingConnection ? 'Verificando...' : 'Reintentar'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}