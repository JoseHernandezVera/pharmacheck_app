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
    final hasConnection = connectivityResult.isNotEmpty &&
    !connectivityResult.contains(ConnectivityResult.none);
    
    if (!mounted) return;
    
    if (hasConnection) {
      widget.onRetry();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Aún no hay conexión a Internet',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onError,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
    
    if (mounted) {
      setState(() => _isCheckingConnection = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Sin conexión',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off,
              size: 80,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 20),
            Text(
              'No hay conexión a Internet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Por favor, verifica tu conexión e intenta nuevamente',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _isCheckingConnection ? null : _checkConnectionAndRetry,
              icon: _isCheckingConnection
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    )
                  : Icon(
                      Icons.refresh,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              label: Text(
                _isCheckingConnection ? 'Verificando...' : 'Reintentar',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}