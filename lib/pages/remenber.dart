import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/model_drawer.dart';
import '../providers/settings_provider.dart';

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
    final settings = Provider.of<SettingsProvider>(context);
    final userData = userProvider.user.name;

    return Scaffold(
      drawer: const ModelDrawer(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Noticias',
          style: TextStyle(
            fontSize: settings.titleFontSize * 1.3,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.menu, 
              size: settings.iconSize,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(settings.cardPadding.horizontal),
        itemCount: noticias.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(
              vertical: settings.cardPadding.vertical * 0.2),
            color: Theme.of(context).colorScheme.surfaceContainer,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Icon(
                Icons.article_outlined,
                size: settings.iconSize * 0.7,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                noticias[index],
                style: TextStyle(
                  fontSize: settings.subtitleFontSize,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              subtitle: Text(
                "Hola, $userData",
                style: TextStyle(
                  fontSize: settings.subtitleFontSize * 0.8,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: settings.cardPadding.horizontal,
                vertical: settings.cardPadding.vertical * 0.8,
              ),
            ),
          );
        },
      ),
    );
  }
}