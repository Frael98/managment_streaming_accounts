import 'package:f_managment_stream_accounts/db/database.dart';
import 'package:f_managment_stream_accounts/forms/login.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initDataBase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema Gestor de Cuentas Streaming',
      theme: ThemeData.dark(),
      home: const LogIn(title: 'Flutter Page'),
    );
  }
}

