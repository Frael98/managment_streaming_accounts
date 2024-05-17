import 'dart:developer';

import 'package:f_managment_stream_accounts/controllers/client_controller.dart';
import 'package:f_managment_stream_accounts/forms/cliente/cliente_list.dart';
import 'package:f_managment_stream_accounts/models/client.dart';
import 'package:f_managment_stream_accounts/utils/helpful_functions.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ClientFormScreen extends StatefulWidget {
  ClientFormScreen(this.idClient, {super.key});
  var idClient = 0;

  @override
  // ignore: library_private_types_in_public_api
  _ClientFormScreenState createState() => _ClientFormScreenState();
}

class _ClientFormScreenState extends State<ClientFormScreen> {
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  int? idCliente = 0;
  final TextEditingController _nameClientController = TextEditingController();
  final TextEditingController _numberPhoneController = TextEditingController();
  final TextEditingController _directionController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    //log("no es null");
    /* log(widget.cliente!.toString());
      _nameClientController.text = widget.cliente!.nameClient!;
      _numberPhoneController.text = widget.cliente!.numberPhone!;
      _directionController.text = widget.cliente!.direction!;
      _emailController.text = widget.cliente!.email!; */
    obtenerClienteAsync();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
      ),
      body: /* ListView(
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
                    if (idCliente != 0) {
                      updateClient(context);
                    } else {
                      log(idCliente.toString());
                      registerClient(context);
                    }
                  },
                  child: const Text('Guardar Cliente'),
                ),
                ElevatedButton(
                  onPressed: () {
                    deleteClient(context);
                  },
                  child: const Text('Eliminar cliente'),
                ),
              ],
            ),
          ),
        ],
      ), */
          Form(
        key: key,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFormField(
                maxLength: 25,
                decoration: const InputDecoration(
                    labelText: 'Nombres*',
                    labelStyle: TextStyle(color: Colors.blue),
                    //filled: true,
                    contentPadding: EdgeInsets.all(15.0)),
                controller: _nameClientController,
                validator: messageValidator,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFormField(
                maxLength: 25,
                decoration: const InputDecoration(
                  labelText: 'Número celular*',
                  contentPadding: EdgeInsets.all(15.0),
                ),
                controller: _numberPhoneController,
                validator: messageValidator,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFormField(
                maxLength: 25,
                decoration: const InputDecoration(labelText: 'Dirección'),
                controller: _directionController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFormField(
                maxLength: 25,
                decoration: const InputDecoration(labelText: 'Email*'),
                controller: _emailController,
                validator: validateEmail,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                //deleteClient(context);
                showDialogMessage(context,
                    title: '¿Esta seguro que desea eliminar este usuario?',
                    callbackYes: deleteClient);
              },
              child: const Text('Eliminar cliente'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () {
          if (key.currentState!.validate()) {
            if (idCliente != 0) {
              updateClient(context);
            } else {
              log(idCliente.toString());
              registerClient(context);
            }
          }
        },
      ),
    );
  }

  Future<void> obtenerClienteAsync() async {
    if (widget.idClient != 0) {
      Client? cliente = await ClientController.getClient(widget.idClient);

      if (cliente != null) {
        idCliente = cliente.idClient;
        _nameClientController.text = cliente.nameClient!;
        _numberPhoneController.text = cliente.numberPhone!;
        _directionController.text = cliente.direction!;
        _emailController.text = cliente.email!;
      }
    }
  }

  /// Limpiar campos
  void limpiarTexts() {
    _nameClientController.text = '';
    _numberPhoneController.text = '';
    _directionController.text = '';
    _emailController.text = '';
  }

  void registerClient(BuildContext context) async {
    String name = _nameClientController.text.trim();
    String number = _numberPhoneController.text.trim();
    String direction = _directionController.text.trim();
    String email = _emailController.text.trim();

    Client newClient = Client(
        nameClient: name,
        numberPhone: number,
        direction: direction,
        email: email,
        createdAt: DateTime.now().toIso8601String());

    try {
      await ClientController.addClient(newClient);
      limpiarTexts();
      showToast('Cliente guardado correctamente!');
      goToClientList();
    } catch (e) {
      log('Error al registrar al usuario: $e');
    }
  }

  void updateClient(BuildContext context) async {
    String name = _nameClientController.text.trim();
    String number = _numberPhoneController.text.trim();
    String direction = _directionController.text.trim();
    String email = _emailController.text.trim();

    Client newClient = Client(
        idClient: idCliente,
        nameClient: name,
        numberPhone: number,
        direction: direction,
        email: email,
        updatedAt: DateTime.now().toIso8601String());

    /* widget.cliente!.nameClient = _nameClientController.text;
    widget.cliente!.numberPhone = _numberPhoneController.text;
    widget.cliente!.direction = _directionController.text;
    widget.cliente!.email = _emailController.text;
    widget.cliente!.createdAt = DateTime.now(); */

    try {
      await ClientController.updateClient(newClient);
      limpiarTexts();
      showToast('Cliente actualizado correctamente!');
      goToClientList();
    } catch (e) {
      log('Error al actualizar al usuario: $e');
    }
  }

  void deleteClient(BuildContext context) async {
    try {
      int id = await ClientController.deleteClient(widget.idClient);
      if (id != 0) {
        showToast("Cliente eliminado correctamente");
        goToClientList();
      }
    } catch (e) {
      log('Error en eliminacion de cliente $e');
    }
  }

  void goToClientList() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const ClientListView(),
      ),
    );
  }
}//End class
