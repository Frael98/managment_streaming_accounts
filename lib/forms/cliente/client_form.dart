import 'dart:developer';
import 'package:f_managment_stream_accounts/controllers/client_controller.dart';
import 'package:f_managment_stream_accounts/forms/cliente/client_list.dart';
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
    obtenerClienteAsync();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
      ),
      body: Form(
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
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.red),
              ),
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
