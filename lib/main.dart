//import 'package:f_managment_stream_accounts/db/sqlite/sqlflite_db.dart';
import 'package:f_managment_stream_accounts/forms/home.dart';
import 'package:f_managment_stream_accounts/forms/log_in.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //initOrCreateTables();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sistema Gestor de Cuentas Streaming',
      theme: ThemeData.dark(),
      //home: const LogIn(title: ''),
      home: const Home(usuario: 'Test', correo: 'test@email.com'),
      //routes: ,
    );
  }
}

