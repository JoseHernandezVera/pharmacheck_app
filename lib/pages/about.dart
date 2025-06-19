import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/model_drawer.dart';
import '../providers/settings_provider.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final TextEditingController _idController = TextEditingController();
  Map<String, dynamic>? _questions;
  Map<String, List<int>> _answers = {};
  bool _isLoading = true;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    setState(() => _isLoading = true);
    try {
      final jsonString = await rootBundle.loadString('assets/questions/questions.json');
      final data = json.decode(jsonString) as Map<String, dynamic>;
      if (data.isEmpty) throw Exception('El JSON está vacío');
      
      setState(() {
        _questions = data;
        _initializeAnswers();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Error'),
            content: Text('No se pudieron cargar las preguntas: $e'),
            actions: [
              TextButton(
                onPressed: () => _loadQuestions(),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> _initializeAnswers() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('feedback_data');
    
    setState(() {
      _answers = _questions?.map((category, questions) {
        final savedCategory = savedData != null 
            ? Map<String, dynamic>.from(json.decode(savedData))[category] 
            : null;
        
        return MapEntry(
          category,
          savedCategory ?? List<int>.filled(questions.length, 0),
        );
      }) ?? {};
    });
  }

  Future<void> _updateAnswer(String category, int index, int value) async {
    setState(() => _answers[category]![index] = value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('feedback_data', json.encode(_answers));
  }

  Future<void> _sendFeedback() async {
    if (_idController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingresa tu nombre o correo')),
      );
      return;
    }

    for (final category in _answers.keys) {
      if (_answers[category]!.any((rating) => rating == 0)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Responde todas las preguntas!')),
        );
        return;
      }
    }

    setState(() => _isSending = true);

    final emailBody = _buildEmailBody();
    final emailUri = Uri(
      scheme: 'mailto',
      path: 'jh0280381@gmail.com',
      queryParameters: {
        'subject': 'Feedback de PharmaCheck App - ${_idController.text}',
        'body': emailBody,
      },
    );

    try {
      await launchUrl(emailUri);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Gracias por tu feedback!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al enviar: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }

  String _buildEmailBody() {
    final buffer = StringBuffer();
    buffer.writeln('Usuario: ${_idController.text}\n');
    buffer.writeln('Fecha: ${DateTime.now()}\n\n');
    
    _questions!.forEach((category, questions) {
      buffer.writeln('=== ${category.toUpperCase()} ===\n');
      for (int i = 0; i < questions.length; i++) {
        buffer.writeln('⭐ Pregunta: ${questions[i]['titulo']}');
        buffer.writeln('   Valoración: ${_answers[category]![i]}/5 estrellas');
        buffer.writeln('   Comentario: ${questions[i]['min']} → ${questions[i]['max']}\n');
      }
    });

    buffer.writeln('\n---\nApp: PharmaCheck v1.0.0');
    buffer.writeln('Desarrollador: José Hernández Vera');
    buffer.writeln('Contacto: jh0280381@gmail.com');
    return buffer.toString();
  }

  Widget _buildQuestionCard(Map<String, dynamic> question, String category, int index) {
    final theme = Theme.of(context);
    final settings = Provider.of<SettingsProvider>(context, listen: false);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      color: theme.colorScheme.surfaceContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question['titulo'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: settings.subtitleFontSize,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    question['min'],
                    style: TextStyle(
                      fontSize: settings.subtitleFontSize * 0.8,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    question['max'],
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: settings.subtitleFontSize * 0.8,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (starIndex) {
                return IconButton(
                  icon: Icon(
                    _answers[category]![index] >= starIndex + 1
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.amber,
                    size: 32,
                  ),
                  onPressed: () => _updateAnswer(category, index, starIndex + 1),
                );
              }),
            ),
            Center(
              child: Text(
                '${_answers[category]![index]}/5 estrellas',
                style: TextStyle(
                  fontSize: settings.subtitleFontSize * 0.9,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      drawer: const ModelDrawer(),
      appBar: AppBar(
        title: Text(
          'Acerca de PharmaCheck',
          style: TextStyle(
            fontSize: settings.titleFontSize,
            color: theme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: theme.colorScheme.primary,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.menu,
              size: settings.iconSize,
              color: theme.colorScheme.onPrimary,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 4,
                    color: theme.colorScheme.surfaceContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/logo.png',
                            width: 80,
                            height: 80,
                            errorBuilder: (_, __, ___) => const Icon(Icons.medical_services, size: 60),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'PharmaCheck',
                            style: TextStyle(
                              fontSize: settings.titleFontSize * 1.2,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Aplicación diseñada para ayudar en el seguimiento de medicamentos y tratamientos médicos.',
                            style: TextStyle(
                              fontSize: settings.subtitleFontSize,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 16),
                          Text(
                            'Desarrollador:',
                            style: TextStyle(
                              fontSize: settings.subtitleFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'José Hernández Vera',
                            style: TextStyle(
                              fontSize: settings.subtitleFontSize,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Contacto:',
                            style: TextStyle(
                              fontSize: settings.subtitleFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => launchUrl(Uri.parse('mailto:jh0280381@gmail.com')),
                            child: Text(
                              'jh0280381@gmail.com',
                              style: TextStyle(
                                fontSize: settings.subtitleFontSize,
                                color: theme.colorScheme.primary,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    'Valoración de la App',
                    style: TextStyle(
                      fontSize: settings.titleFontSize,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'Identificación',
                    style: TextStyle(
                      fontSize: settings.subtitleFontSize,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _idController,
                    decoration: InputDecoration(
                      hintText: 'Nombre o correo electrónico',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                      filled: true,
                      fillColor: theme.colorScheme.surfaceContainerHighest,
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    'Cuéntanos tu experiencia:',
                    style: TextStyle(
                      fontSize: settings.subtitleFontSize,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (_questions != null)
                    ..._questions!.entries.map((entry) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.key.toUpperCase(),
                            style: TextStyle(
                              fontSize: settings.subtitleFontSize,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...entry.value.asMap().entries.map((question) {
                            return _buildQuestionCard(
                              question.value,
                              entry.key,
                              question.key,
                            );
                          }),
                          const SizedBox(height: 16),
                        ],
                      );
                    }),

                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _isSending ? null : _sendFeedback,
                      icon: _isSending
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.send),
                      label: Text(
                        _isSending ? 'Enviando...' : 'Enviar Feedback',
                        style: TextStyle(
                          fontSize: settings.subtitleFontSize,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }
}