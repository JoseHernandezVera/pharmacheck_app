import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../models/model_drawer.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context, listen: true);

    return Scaffold(
      drawer: const ModelDrawer(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Configuración',
          style: TextStyle(
            fontSize: settings.titleFontSize * 1.5,
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
      body: ListView(
        padding: settings.cardPadding,
        children: [
          Text(
            'Tamaño de las cosas:',
            style: TextStyle(
              fontSize: settings.titleFontSize,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSizeButton(context, size: CardSize.small, label: 'Pequeño'),
              _buildSizeButton(context, size: CardSize.medium, label: 'Mediano'),
              _buildSizeButton(context, size: CardSize.large, label: 'Grande'),
            ],
          ),

          const Divider(height: 40),

          Text(
            'Tema de la aplicación:',
            style: TextStyle(
              fontSize: settings.titleFontSize,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          _buildThemeOption(
            context,
            mode: ThemeMode.light,
            currentMode: settings.themeMode,
            label: 'Tema claro',
            icon: Icons.light_mode,
            onChanged: () => settings.setThemeMode(ThemeMode.light),
            settings: settings,
          ),
          _buildThemeOption(
            context,
            mode: ThemeMode.dark,
            currentMode: settings.themeMode,
            label: 'Tema oscuro',
            icon: Icons.dark_mode,
            onChanged: () => settings.setThemeMode(ThemeMode.dark),
            settings: settings,
          ),
          _buildThemeOption(
            context,
            mode: ThemeMode.system,
            currentMode: settings.themeMode,
            label: 'Sistema',
            icon: Icons.settings_suggest,
            onChanged: () => settings.setThemeMode(ThemeMode.system),
            settings: settings,
          ),
        ],
      ),
    );
  }

  Widget _buildSizeButton(
    BuildContext context, {
    required CardSize size,
    required String label,
  }) {
    final settings = Provider.of<SettingsProvider>(context, listen: true);
    final isSelected = settings.cardSize == size;

    return ElevatedButton(
      onPressed: () => settings.setCardSize(size),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
            ? Theme.of(context).colorScheme.primaryContainer
            : Theme.of(context).colorScheme.surfaceContainerHighest,
        foregroundColor: isSelected
            ? Theme.of(context).colorScheme.onPrimaryContainer
            : Theme.of(context).colorScheme.onSurface,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline,
            width: 1,
          ),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: settings.subtitleFontSize,
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context, {
    required ThemeMode mode,
    required ThemeMode currentMode,
    required String label,
    required IconData icon,
    required VoidCallback onChanged,
    required SettingsProvider settings,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: onChanged,
        child: Padding(
          padding: settings.cardPadding,
          child: Row(
            children: [
              Icon(
                icon,
                size: settings.iconSize,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: settings.subtitleFontSize,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              if (mode == currentMode)
                Icon(
                  Icons.check_circle,
                  size: settings.iconSize,
                  color: Theme.of(context).colorScheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}