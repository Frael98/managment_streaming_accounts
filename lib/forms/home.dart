import 'dart:developer';

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String usuario;
  final String correo;

  const HomeScreen({super.key, required this.usuario, required this.correo});

  @override
  Widget build(BuildContext context) {
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
                backgroundImage:
                    AssetImage('assets/imagen_usuario.jpg'), // Imagen
              ),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 17, 27, 54),
              ),
            ),
            ListTile(
              title: const Text('Resurantes Cerca'),
              onTap: () {
                /* Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MapPage(),
                  ),
                ); */
              },
            ),
            ListTile(
              title: const Text('Pedir a domicilio'),
              onTap: () {
                /* Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RestaurantesPage(),
                  ),
                ); */
              },
            ),
            ListTile(
              title: const Text('Configuración'),
              onTap: () {
                // TODO
              },
            ),
            ListTile(
              title: const Text('Cerrar sesión'),
              onTap: () {
                /* Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LogIn(title: ''),
                  ),
                  (route) =>
                      false, // Elimina todas las rutas anteriores del historial de navegación
                ); */
              },
            ),
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
            ElevatedButton(
              onPressed: () {},
              child: const Text('Resurantes cerca'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                log('Pedir a Domicilio');
              },
              child: const Text('Pedir a Domicilio'),
            ),
          ],
        ),
      ),
    );
  }
}
