import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'base_pages.dart';
import 'user_data.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context);

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final avatarSize = screenWidth * 0.35;
    final fontSizeText = screenWidth * 0.045;
    final fontSizeButton = screenWidth * 0.04;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 110, 179, 235),
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: const Color.fromARGB(255, 3, 99, 179),
      ),
      drawer: const BasePage(title: 'Profile'),
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
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Nombre: ${userData.name}',
                            style: TextStyle(fontSize: fontSizeText),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: screenHeight * 0.008),
                          ElevatedButton(
                            onPressed: () => _editField('Nombre', userData.name, (val) {
                              userData.updateName(val);
                            }),
                            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                            child: Text('Editar nombre', style: TextStyle(fontSize: fontSizeButton)),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.025),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Correo: ${userData.email}',
                            style: TextStyle(fontSize: fontSizeText),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: screenHeight * 0.008),
                          ElevatedButton(
                            onPressed: () => _editField('Correo', userData.email, (val) {
                              userData.updateEmail(val);
                            }),
                            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                            child: Text('Editar correo', style: TextStyle(fontSize: fontSizeButton)),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.025),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
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
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.025),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
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