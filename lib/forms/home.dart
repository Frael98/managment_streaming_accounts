import 'package:f_managment_stream_accounts/forms/cliente/client_list.dart';
import 'package:f_managment_stream_accounts/forms/components/custom_expansion_tile.dart';
import 'package:f_managment_stream_accounts/forms/cuentas/account_form.dart';
import 'package:f_managment_stream_accounts/forms/cuentas/account_list.dart';
import 'package:f_managment_stream_accounts/forms/log_in.dart';
import 'package:f_managment_stream_accounts/forms/plataforma/platform_list.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class HomeScreen extends StatelessWidget {
  final String usuario;
  final String correo;

  const HomeScreen({super.key, required this.usuario, required this.correo});

  @override
  Widget build(BuildContext context) {
    if (ToastContext().context == null) {
      ToastContext().init(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(usuario),
              accountEmail: Text(correo),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage('assets/ichi.jpg'), // Imagen
              ),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 17, 27, 54),
              ),
            ),
            ...menus(context)
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Usuario: $usuario',
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  List<Widget> submenus(BuildContext context) {
    return [
      ListTile(
        leading: const Icon(Icons.contact_mail),
        title: const Text('Clientes'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ClientListView(),
            ),
          );
        },
      ),
      ListTile(
        leading: const Icon(Icons.account_box_rounded),
        title: const Text('Cuentas'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AccountListView(),
            ),
          );
        },
      ),
      ListTile(
        leading: const Icon(Icons.dvr),
        title: const Text('Plataformas'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PlatformListView(),
            ),
          );
        },
      ),
    ];
  }

  List<Widget> menus(BuildContext context) {
    return [
      CustomExpansionTile(title: 'Acciones', tiles: submenus(context)),
      ListTile(
        leading: const Icon(Icons.logout),
        title: const Text('Cerrar sesión'),
        onTap: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const LogIn(title: ''),
            ),
            (route) =>
                false, // Elimina todas las rutas anteriores del historial de navegación
          );
        },
      ),
    ];
  }
}
