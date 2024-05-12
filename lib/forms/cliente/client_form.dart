import 'dart:developer';

import 'package:f_managment_stream_accounts/controllers/client_controller.dart';
import 'package:f_managment_stream_accounts/models/client.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class ClientFormScreen extends StatefulWidget {
  const ClientFormScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ClientFormScreenState createState() => _ClientFormScreenState();
}

class _ClientFormScreenState extends State<ClientFormScreen> {
  final TextEditingController _nameClientController = TextEditingController();
  final TextEditingController _numberPhoneController = TextEditingController();
  final TextEditingController _directionController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Clientes'),
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _nameClientController,
                    decoration: const InputDecoration(labelText: 'Nombres'),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _numberPhoneController,
                    decoration:
                        const InputDecoration(labelText: 'Número Celular'),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _directionController,
                    decoration: const InputDecoration(labelText: 'Dirección'),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _emailController,
                    decoration:
                        const InputDecoration(labelText: 'Correo Electrónico'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      _registerUser(context);
                    },
                    child: const Text('Guardar Cliente'),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  /// Limpiar campos
  void limpiarTexts() {
    _nameClientController.text = '';
    _numberPhoneController.text = '';
    _directionController.text = '';
    _emailController.text = '';
  }

  void _registerUser(BuildContext context) async {
    String name = _nameClientController.text.trim();
    String number = _numberPhoneController.text.trim();
    String direction = _directionController.text.trim();
    String email = _emailController.text.trim();

    Client newClient = Client(
        nameClient: name,
        numberPhone: number,
        direction: direction,
        email: email);

    try {
      await ClientController.addClient(newClient);
      limpiarTexts();
      showToast('Cliente guardado correctamente!');
    } catch (e) {
      log('Error al registrar al usuario: $e');
    }
  }

  //Muestra mensajes
  void showToast(String message) {
    Toast.show(message, duration: Toast.lengthLong, gravity: Toast.bottom);
  }
}
