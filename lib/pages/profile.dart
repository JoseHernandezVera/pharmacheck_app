import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/model_drawer.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _editField(String title, String value, Function(String) onSave, BuildContext context, 
      {bool isEmail = false, bool isPhone = false}) {
    final TextEditingController controller = TextEditingController(text: value);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Editar $title'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(labelText: title),
            keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
            maxLength: isPhone ? 15 : null,
            validator: (val) {
              if (val == null || val.isEmpty) {
                return 'Este campo es obligatorio';
              }
              if (isEmail) {
                if (!RegExp(r'^[\w-\.]+@(gmail|hotmail|outlook)\.com$').hasMatch(val)) {
                  return 'Ingrese un correo válido';
                }
              }
              if (isPhone) {
                if (!RegExp(r'^[0-9]+$').hasMatch(val)) {
                  return 'Solo se permiten números';
                }
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                String newValue = controller.text;
                if (isPhone && newValue.length > 15) {
                  newValue = '${newValue.substring(0, 12)}...';
                }
                onSave(newValue);
                Navigator.pop(context);
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  String _formatPhone(String phone) {
    if (phone.length > 15) {
      return '${phone.substring(0, 12)}...';
    }
    return phone;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    final avatarSize = screenWidth * 0.35;
    final fontSizeText = screenWidth * 0.045;
    final fontSizeButton = screenWidth * 0.04;

    return Scaffold(
      drawer: const ModelDrawer(),
      backgroundColor: const Color.fromARGB(255, 110, 179, 235),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 3, 99, 179),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, size: 32, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: const Color.fromARGB(255, 3, 99, 179),
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.04, horizontal: screenWidth * 0.04),
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
                margin: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.03, horizontal: screenWidth * 0.05),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Nombre: ${user.name}',
                        style: TextStyle(fontSize: fontSizeText),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: screenHeight * 0.008),
                      ElevatedButton(
                        onPressed: () => _editField('Nombre', user.name, (val) {
                          userProvider.updateUser(name: val);
                        }, context),
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12)),
                        child: Text('Editar nombre',
                            style: TextStyle(fontSize: fontSizeButton)),
                      ),
                      SizedBox(height: screenHeight * 0.025),
                      Text(
                        'Correo: ${user.email}',
                        style: TextStyle(fontSize: fontSizeText),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: screenHeight * 0.008),
                      ElevatedButton(
                        onPressed: () => _editField('Correo', user.email, (val) {
                          userProvider.updateUser(email: val);
                        }, context, isEmail: true),
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12)),
                        child: Text('Editar correo',
                            style: TextStyle(fontSize: fontSizeButton)),
                      ),
                      SizedBox(height: screenHeight * 0.025),
                      Text(
                        'Fecha de nacimiento: ${user.birthdate}',
                        style: TextStyle(fontSize: fontSizeText),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: screenHeight * 0.008),
                      ElevatedButton(
                        onPressed: () => _editField(
                            'Fecha de nacimiento', user.birthdate, (val) {
                          userProvider.updateUser(birthdate: val);
                        }, context),
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12)),
                        child: Text('Editar fecha de nacimiento',
                            style: TextStyle(fontSize: fontSizeButton)),
                      ),
                      SizedBox(height: screenHeight * 0.025),
                      Text(
                        'Teléfono: ${_formatPhone(user.phone)}',
                        style: TextStyle(fontSize: fontSizeText),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: screenHeight * 0.008),
                      ElevatedButton(
                        onPressed: () => _editField('Teléfono', user.phone, (val) {
                          userProvider.updateUser(phone: val);
                        }, context, isPhone: true),
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12)),
                        child: Text('Editar teléfono',
                            style: TextStyle(fontSize: fontSizeButton)),
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