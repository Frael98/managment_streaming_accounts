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
    super.initState();

    userController = TextEditingController();
    passwordController = TextEditingController();
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

// Logeo
  void logIn() async {
    
    var user = '', correo = '';

    /* if (datos != null) {
      user = datos.get('usuario');
      correo = datos.get('correo');

      
    } else {
      showToast('action', '', 'Usuario no existe');
      return;
    }

    if (!isValid()) {
      showToast('action', '', 'Por favor llene los campos');
      return;
    } */

    showToast(
        'Iniciar Sesion',
        ' ${userController.text.trim()} pass: ${passwordController.text.trim()}',
        ' Acceso concedido');
    // ignore: use_build_context_synchronously
    /* Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            usuario: user,
            correo: correo,
          ),
        )); */
    clearTexts();
  }

  Widget formLogIn() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Log In',
              style: TextStyle(
                  color: Colors.amber, fontSize: 50, fontFamily: 'bold')),
          /* Image(image: ImageProvider), */
          Padding(
            padding:
                const EdgeInsets.only(bottom: 20.0, left: 50.0, right: 50.0),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              controller: userController,
              decoration: const InputDecoration(labelText: 'User'),
              maxLength: 25,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 20.0, left: 50.0, right: 50.0),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              maxLength: 20,
              obscureText: true,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(onPressed: logIn, child: const Text('Iniciar Sesion')),
          ElevatedButton(
              onPressed: () {
                /* Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpScreen()
                    )); */
              },
              child: const Text('Registrarse')),
        ],
      ),
    );
  }
}
