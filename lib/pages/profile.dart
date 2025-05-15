import 'package:flutter/material.dart';
import 'home.dart';
import 'remenber.dart';
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = 'Usuario';
  String email = 'usuario@ejemplo.com';
  String birthdate = '11/08/2003';
  String phone = '123456789';

  void _editField(String title, String value, Function(String) onSave) {
    final TextEditingController controller = TextEditingController(text: value);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Editar $title'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: title),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                onSave(controller.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  Future<void> _goToHome() async {
    Navigator.pop(context);
    await Future.delayed(const Duration(milliseconds: 250));
    if (!mounted) return;
    if (ModalRoute.of(context)?.settings.name != '/home') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Inicio')),
      );
    }
  }

  Future<void> _goToProfile() async {
    Navigator.pop(context);
    await Future.delayed(const Duration(milliseconds: 250));
    if (!mounted) return;
  }

  Future<void> _goToRemember() async {
    Navigator.pop(context);
    await Future.delayed(const Duration(milliseconds: 250));
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const RemenberPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final avatarSize = screenWidth * 0.35;
    final fontSizeText = screenWidth * 0.045;
    final fontSizeButton = screenWidth * 0.04;

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(color: Color.fromARGB(255, 3, 99, 179)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.account_circle, size: 64, color: Colors.white),
                  const SizedBox(height: 8),
                  Text(name, style: const TextStyle(color: Colors.white, fontSize: 18)),
                  Text(email, style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            ListTile(
              title: const Text("Inicio"),
              onTap: _goToHome,
            ),
            ListTile(
              title: const Text("Perfil"),
              onTap: _goToProfile,
            ),
            ListTile(
              title: const Text("Recordar"),
              onTap: _goToRemember,
            ),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 110, 179, 235),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 3, 99, 179),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: const Color.fromARGB(255, 3, 99, 179),
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.04, horizontal: screenWidth * 0.04),
              child: Center(
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/perfil.jpg',
                    width: avatarSize,
                    height: avatarSize,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Center(
              child: Card(
                elevation: 6,
                margin: EdgeInsets.symmetric(vertical: screenHeight * 0.03, horizontal: screenWidth * 0.05),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Nombre: $name',
                        style: TextStyle(fontSize: fontSizeText),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: screenHeight * 0.008),
                      ElevatedButton(
                        onPressed: () => _editField('Nombre', name, (val) {
                          setState(() => name = val);
                        }),
                        style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                        child: Text('Editar nombre', style: TextStyle(fontSize: fontSizeButton)),
                      ),
                      SizedBox(height: screenHeight * 0.025),
                      Text(
                        'Correo: $email',
                        style: TextStyle(fontSize: fontSizeText),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: screenHeight * 0.008),
                      ElevatedButton(
                        onPressed: () => _editField('Correo', email, (val) {
                          setState(() => email = val);
                        }),
                        style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                        child: Text('Editar correo', style: TextStyle(fontSize: fontSizeButton)),
                      ),
                      SizedBox(height: screenHeight * 0.025),
                      Text(
                        'Fecha de nacimiento: $birthdate',
                        style: TextStyle(fontSize: fontSizeText),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: screenHeight * 0.008),
                      ElevatedButton(
                        onPressed: () => _editField('Fecha de nacimiento', birthdate, (val) {
                          setState(() => birthdate = val);
                        }),
                        style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                        child: Text('Editar fecha de nacimiento', style: TextStyle(fontSize: fontSizeButton)),
                      ),
                      SizedBox(height: screenHeight * 0.025),
                      Text(
                        'Teléfono: $phone',
                        style: TextStyle(fontSize: fontSizeText),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: screenHeight * 0.008),
                      ElevatedButton(
                        onPressed: () => _editField('Teléfono', phone, (val) {
                          setState(() => phone = val);
                        }),
                        style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                        child: Text('Editar teléfono', style: TextStyle(fontSize: fontSizeButton)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}