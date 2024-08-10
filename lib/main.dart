//import 'package:f_managment_stream_accounts/db/sqlite/sqlflite_db.dart';
import 'package:f_managment_stream_accounts/forms/home.dart';
import 'package:f_managment_stream_accounts/router/config.dart';
import 'package:f_managment_stream_accounts/shared_preferences/preferences.dart';
import 'package:f_managment_stream_accounts/utils/helpful_functions.dart';
import 'package:flutter/material.dart';
//import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //initOrCreateTables();
  await MySharedPreferences.initPreferences();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Sistema Gestor de Cuentas Streaming',
      theme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      routerConfig: enrutador,
    );
  }
}
