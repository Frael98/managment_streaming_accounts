import 'dart:developer';

//import 'package:f_managment_stream_accounts/controllers/mongo/user_controller_mongo.dart';
import 'package:f_managment_stream_accounts/controllers/sqlite/user_controller_sqlite.dart';
import 'package:f_managment_stream_accounts/forms/log_in.dart';
import 'package:f_managment_stream_accounts/models/user.dart';
import 'package:f_managment_stream_accounts/utils/helpful_functions.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Registro de Usuario'),
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(labelText: 'Nombres'),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(labelText: 'Apellidos'),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _ageController,
                    decoration: const InputDecoration(labelText: 'Edad'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _emailController,
                    decoration:
                        const InputDecoration(labelText: 'Correo Electrónico'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _userController,
                    decoration: const InputDecoration(labelText: 'Usuario'),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Contraseña'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      registerUser(context);
                    },
                    child: const Text('Registrar'),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  /// Limpiar campos
  void limpiarTexts() {
    _userController.text = '';
    _firstNameController.text = '';
    _passwordController.text = '';
    _lastNameController.text = '';
    _ageController.text = '';
    _emailController.text = '';
  }

  void registerUser(BuildContext context) async {
    String user = _userController.text.trim();
    String name = _firstNameController.text.trim();
    String lastname = _lastNameController.text.trim();
    int age = int.tryParse(_ageController.text) ?? 0;
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    User newUser = User(
        name: name,
        lastname: lastname,
        user: user,
        email: email,
        age: age,
        password: password);

    try {

      await UserControllerSQLite.addUser(newUser);
      //await UserControllerMongo.addUser(newUser);

      limpiarTexts();
      showToast('Ud ha sido registrado correctamente!');

      // Redirige a la pantalla de perfil del usuario después del registro
       Navigator.push(
       // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
            builder: (context) => const LogIn(
                  title: '',
                )),
      );
    } catch (e) {
      log('Error al registrar al usuario: $e');
      showToast('Error al registrar al usuario: $e');
    }
  }
}
