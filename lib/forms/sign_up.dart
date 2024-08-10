import 'dart:developer';

import 'package:f_managment_stream_accounts/forms/components/custom_elevated_button.dart';
import 'package:f_managment_stream_accounts/forms/components/custom_textfield.dart';
import 'package:f_managment_stream_accounts/models/user.dart';
import 'package:f_managment_stream_accounts/router/rutas.dart';
import 'package:f_managment_stream_accounts/shared_preferences/preferences.dart';
import 'package:f_managment_stream_accounts/utils/helpful_functions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../controllers/mongo/user_controller_mongo.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  GlobalKey<FormState> _key = GlobalKey();
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
        body: buildFormRegister());
  }

  Widget buildFormRegister() {
    return Form(
        key: _key,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextFormField(
                    labelText: 'Nombres',
                    controller: _firstNameController,
                    validator: messageValidator,
                    maxLength: 50,
                  ),
                  CustomTextFormField(
                    labelText: 'Apellidos',
                    controller: _lastNameController,
                    validator: messageValidator,
                    maxLength: 50,
                  ),
                  CustomTextFormField(
                    labelText: 'Edad',
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    validator: messageValidator,
                    maxLength: 2,
                  ),
                  CustomTextFormField(
                    controller: _emailController,
                    labelText: 'Correo Electrónico',
                    keyboardType: TextInputType.emailAddress,
                    validator: validateEmail,
                    maxLength: 50,
                  ),
                  CustomTextFormField(
                    labelText: 'Usuario',
                    controller: _userController,
                    validator: messageValidator,
                    maxLength: 50,
                  ),
                  CustomTextFormField(
                    maxLength: 50,
                    controller: _passwordController,
                    labelText: 'Contraseña',
                    obscureText: true,
                    validator: messageValidator,
                  ),
                  CustomElevatedButton(
                    function: () async {
                      if (_key.currentState!.validate()) {
                        _registerUser(context);
                      }
                    },
                    title: 'Registrar',
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  /// Limpiar campos
  void limpiarTexts() {
    _userController.clear();
    _firstNameController.clear();
    _passwordController.clear();
    _lastNameController.clear();
    _ageController.clear();
    _emailController.clear();
  }

  void _registerUser(BuildContext context) async {
    String user = _userController.text.trim();
    String name = _firstNameController.text.trim();
    String lastname = _lastNameController.text.trim();
    int age = int.tryParse(_ageController.text.trim()) ?? 0;
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
      //await UserControllerSQLite.addUser(newUser);
      await UserControllerMongo.addUser(newUser);

      limpiarTexts();
      showToast('Ud ha sido registrado correctamente!');

      // Redirige a la pantalla de perfil del usuario después del registro
      /* Navigator.push(
       // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
            builder: (context) => const LogIn()),
      ); */
      // ignore: use_build_context_synchronously
      MySharedPreferences.setIsLogged(true);
      MySharedPreferences.prefs.setString('usuario', user);
      MySharedPreferences.prefs.setString('correo', email);
      context.goNamed(RutasNombres.login.name);
    } catch (e) {
      log('Error al registrar al usuario: $e');
      showToast('Error al registrar al usuario: $e');
    }
  }
}
