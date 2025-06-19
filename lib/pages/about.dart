import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
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

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      final jsonString = await rootBundle.loadString('assets/questions/questions.json');
      setState(() {
        _questions = json.decode(jsonString);
        _initializeAnswers();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading questions: $e')),
      );
    }
  }

  void _initializeAnswers() {
    if (_questions != null) {
      _questions!.forEach((category, questions) {
        _answers[category] = List<int>.filled(questions.length, 0);
      });
    }
  }

  void _updateAnswer(String category, int questionIndex, int value) {
    setState(() {
      _answers[category]![questionIndex] = value;
    });
  }

  Future<void> _sendFeedback() async {
    if (_idController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingresa tu identificación (nombre o correo)')),
      );
      return;
    }

    final emailBody = _buildEmailBody();
    final emailUri = Uri(
      scheme: 'mailto',
      path: 'jh0280381@gmail.com',
      queryParameters: {
        'subject': 'Feedback de PharmaCheck App',
        'body': emailBody,
      },
    );

    try {
      await launchUrl(emailUri);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al abrir el cliente de correo: $e')),
      );
    }
  }

  String _buildEmailBody() {
    final buffer = StringBuffer();
    buffer.writeln('Identificación del usuario: ${_idController.text}\n\n');
    
    _questions!.forEach((category, questions) {
      buffer.writeln('=== ${category.toUpperCase()} ===\n');
      for (int i = 0; i < questions.length; i++) {
        buffer.writeln('Pregunta: ${questions[i]['titulo']}');
        buffer.writeln('Respuesta: ${_answers[category]![i]} estrellas\n');
      }
      buffer.writeln();
    });

    return buffer.toString();
  }

  Widget _buildQuestionCard(Map<String, dynamic> question, String category, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question['titulo'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    question['min'],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    question['max'],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Slider(
              value: _answers[category]![index].toDouble(),
              min: 0,
              max: 5,
              divisions: 5,
              label: '${_answers[category]![index]}',
              onChanged: (value) {
                _updateAnswer(category, index, value.toInt());
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      drawer: const ModelDrawer(),
      appBar: AppBar(
        title: Text(
          'Acerca de',
          style: TextStyle(
            fontSize: settings.titleFontSize,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PharmaCheck App',
                            style: TextStyle(
                              fontSize: settings.titleFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Aplicación diseñada para ayudar en el seguimiento de medicamentos y tratamientos médicos.',
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Desarrollador:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Text('José Fernando Hernández Vera'),
                          const Text('Contacto: jh0280381@gmail.com'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    'Identificación (nombre o correo)',
                    style: TextStyle(
                      fontSize: settings.subtitleFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _idController,
                    decoration: const InputDecoration(
                      hintText: 'Ingresa tu nombre o correo',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    'Por favor califica tu experiencia:',
                    style: TextStyle(
                      fontSize: settings.subtitleFontSize,
                      fontWeight: FontWeight.bold,
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
                              color: Theme.of(context).colorScheme.primary,
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
                    child: ElevatedButton(
                      onPressed: _sendFeedback,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                      ),
                      child: const Text('Enviar Respuestas'),
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