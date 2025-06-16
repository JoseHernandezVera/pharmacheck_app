import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/model_drawer.dart';

class RemenberPage extends StatelessWidget {
  const RemenberPage({super.key});

  static const List<String> noticias = [
    "En Cruz Verde hay descuento del 40% en paracetamol",
    "Campaña de vacunación contra la influenza hasta el 30 de junio",
    "Nuevo horario en farmacias: abiertas hasta las 10 pm",
    "Consulta médica gratuita los sábados en la clínica central",
    "Oferta en vitaminas: 2x1 en farmacia San Juan",
  ];

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userData = userProvider.user.name;

    return Scaffold(
      drawer: const ModelDrawer(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Noticias',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
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
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: noticias.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            color: Theme.of(context).colorScheme.surfaceContainer,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Icon(
                Icons.article_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                noticias[index],
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              subtitle: Text(
                "Hola, $userData",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          );
        },
      ),
    );
  }
}