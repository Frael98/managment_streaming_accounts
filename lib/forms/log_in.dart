import 'dart:developer';

import 'package:f_managment_stream_accounts/controllers/mongo/user_controller_mongo.dart';
import 'package:f_managment_stream_accounts/forms/components/custom_elevated_button.dart';
import 'package:f_managment_stream_accounts/models/user.dart';
import 'package:f_managment_stream_accounts/router/rutas.dart';
import 'package:f_managment_stream_accounts/shared_preferences/preferences.dart';
import 'package:f_managment_stream_accounts/utils/helpful_functions.dart';
//import 'package:f_managment_stream_accounts/utils/helpful_functions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toast/toast.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});
  //final String title;

  @override
  State<StatefulWidget> createState() {
    return LogInState();
  }
}

///  Manejador de los estados de mi clase
class LogInState extends State<LogIn> {
  final GlobalKey<FormState> _key = GlobalKey();
  late TextEditingController userController;
  late TextEditingController passwordController;

  //Estado Inicio
  @override
  void initState() {
    userController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
    validateUserLogged();
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

// Limpia campos
  void clearTexts() {
    userController.clear();
    passwordController.clear();
  }

  /// Logeo
  void logIn() async {
    String user = userController.text.trim();
    String pass = passwordController.text.trim();

    log(user);
    //var datos = await UserControllerSQLite.logIn(User.validation(user, pass));
    var datos = await UserControllerMongo.logIn(User.validation(user, pass));
    var name = '', email = '';

    if (datos != null) {
      log(datos.toString());
      await MySharedPreferences.prefs.setString('usuario', datos.name!);
      await MySharedPreferences.prefs.setString('correo', datos.email!);
      MySharedPreferences.setIsLogged(true);

      name = datos.name!;
      email = datos.email!;
    } else {
      showToast('action', '', 'Usuario no existe');
      return;
    }

    showToast(
        'Iniciar Sesion',
        ' Acceso concedido');
    // ignore: use_build_context_synchronously
    /* Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (context) => Home(
            usuario: name,
            correo: email,
          ),
        )); */
    // ignore: use_build_context_synchronously
    context.pushReplacementNamed(RutasNombres.inicio.name,
        queryParameters: {'usuario': name, 'correo': email});
    clearTexts();
  }

  Widget formLogIn() {
    return Form(
      key: _key,
      child: Center(
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
              child: TextFormField(
                validator: messageValidator,
                style: const TextStyle(color: Colors.white),
                controller: userController,
                decoration: const InputDecoration(
                  labelText: 'Usuario',
                ),
                maxLength: 25,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(bottom: 20.0, left: 50.0, right: 50.0),
              child: TextFormField(
                validator: messageValidator,
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
                  //logIn();
                  if (_key.currentState!.validate()) {
                    logIn();
                  }
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
                  /* Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpScreen())); */
                  context.goNamed(RutasNombres.signUp.name);
                },
                title: 'Registrarse',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void validateUserLogged() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var logged = MySharedPreferences.getIsLogged();
      if (isNotNull(logged) && logged) {
        log('usuario esta logeado');
        context.goNamed(RutasNombres.inicio.name, queryParameters: {
          'usuario': MySharedPreferences.prefs.getString('usuario')!,
          'correo': MySharedPreferences.prefs.getString('correo')!
        });
      }
    });
  }
}
