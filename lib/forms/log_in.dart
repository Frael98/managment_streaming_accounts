import 'dart:developer';

import 'package:f_managment_stream_accounts/controllers/mongo/user_controller_mongo.dart';
import 'package:f_managment_stream_accounts/forms/components/custom_elevated_button.dart';
//import 'package:f_managment_stream_accounts/controllers/sqlite/user_controller_sqlite.dart';
import 'package:f_managment_stream_accounts/forms/home.dart';
import 'package:f_managment_stream_accounts/forms/sign_up.dart';
import 'package:f_managment_stream_accounts/models/user.dart';
import 'package:f_managment_stream_accounts/utils/helpful_functions.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class LogIn extends StatefulWidget {
  const LogIn({required this.title, super.key});
  final String title;

  @override
  State<StatefulWidget> createState() {
    return LogInState();
  }
}

///  Manejador de los estados de mi clase
class LogInState extends State<LogIn> {
  late TextEditingController userController;
  late TextEditingController passwordController;

  //Estado Inicio
  @override
  void initState() {
    userController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(body: formLogIn());
  }

//Muestra mensajes
  void showToast(String action, [data = '', String message = '']) {
    if (action == 'Iniciar Sesión') {
      message += '$message $data';
    }
    if (action == 'Salir') {
      message = 'Ha salido del sistema';
    }

    Toast.show(message, duration: Toast.lengthLong, gravity: Toast.bottom);
  }

// Valida Campos vacios
  bool isValid() {
    return userController.text.isNotEmpty && passwordController.text.isNotEmpty;
  }

// Limpia campos
  void clearTexts() {
    userController.text = '';
    passwordController.text = '';
  }

  /// Logeo
  void logIn() async {
    if (!isValid()) {
      showToast('action', '', 'Por favor llene los campos');
      return;
    }

    String user = userController.text;
    String pass = passwordController.text;

    //var datos = await UserControllerSQLite.logIn(User.validation(user, pass));
    var datos = await UserControllerMongo.logIn(User.validation(user, pass));
    var name = '', email = '';

    if (datos != null) {
      log(datos.toString());
      name = datos.name!;
      email = datos.email!;
    } else {
      showToast('action', '', 'Usuario no existe');
      return;
    }

    showToast(
        'Iniciar Sesion',
        ' ${userController.text.trim()} pass: ${passwordController.text.trim()}',
        ' Acceso concedido');
    // ignore: use_build_context_synchronously
    Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            usuario: name,
            correo: email,
          ),
        ));
    clearTexts();
  }

  Widget formLogIn() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Inicio de sesión',
              style: TextStyle(
                  color: Colors.amber, fontSize: 40, fontFamily: 'bold')),
          /* Image(image: ImageProvider), */
          Padding(
            padding:
                const EdgeInsets.only(bottom: 20.0, left: 50.0, right: 50.0),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              controller: userController,
              decoration: const InputDecoration(labelText: 'Usuario'),
              maxLength: 25,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 20.0, left: 50.0, right: 50.0),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Constraseña'),
              maxLength: 20,
              obscureText: true,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
            child: CustomElevatedButton(
              function: () async {
                logIn();
              },
              color: Colors.blue,
              title: 'Iniciar Sesión',
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
            child: CustomElevatedButton(
              color: Colors.blueGrey,
              function: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignUpScreen()));
              },
              title: 'Registrarse',
            ),
          ),
        ],
      ),
    );
  }
}
