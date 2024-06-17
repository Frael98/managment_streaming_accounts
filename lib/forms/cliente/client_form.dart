import 'dart:developer';
//import 'package:f_managment_stream_accounts/controllers/sqlite/client_controller_sqlite.dart';
import 'package:f_managment_stream_accounts/controllers/mongo/client_controller_mongo.dart';
import 'package:f_managment_stream_accounts/forms/cliente/client_list.dart';
import 'package:f_managment_stream_accounts/models/client.dart';
import 'package:f_managment_stream_accounts/utils/helpful_functions.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

// ignore: must_be_immutable
class ClientFormScreen extends StatefulWidget {
  ClientFormScreen(this.idClient, {super.key});
  dynamic idClient;

  @override
  // ignore: library_private_types_in_public_api
  _ClientFormScreenState createState() => _ClientFormScreenState();
}

class _ClientFormScreenState extends State<ClientFormScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  dynamic idCliente = 0;
  final TextEditingController _nameClientController = TextEditingController();
  final TextEditingController _numberPhoneController = TextEditingController();
  final TextEditingController _directionController = TextEditingController();
  late final TextEditingController? _emailController;

  @override
  void initState() {
    obtenerClienteAsync();
    super.initState();
    _emailController = TextEditingController();
  }

  Future<void> obtenerClienteAsync() async {
    if (widget.idClient != 0) {
      //Client? cliente = await ClientControllerSQLite.getClient(widget.idClient);
      Client? cliente = await ClientControllerMongo.getClient(widget.idClient);
      log(cliente.toString());
      setState(() {
        idCliente = cliente.id ?? cliente.uid;
      });
      _nameClientController.text = cliente.nameClient!;
      _numberPhoneController.text = cliente.numberPhone!;
      _directionController.text = cliente.direction!;
      _emailController!.text = cliente.email!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
      ),
      body: Form(
        key: _key,
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
                maxLength: 10,
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
                maxLength: 35,
                decoration: const InputDecoration(
                  labelText: 'Dirección',
                  contentPadding: EdgeInsets.all(15.0),
                ),
                controller: _directionController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFormField(
                maxLength: 25,
                decoration: const InputDecoration(
                  labelText: 'Email*',
                  contentPadding: EdgeInsets.all(15.0),
                ),
                controller: _emailController,
                validator: validateEmail,
              ),
            ),
            ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.deepOrange),
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
          if (_key.currentState!.validate()) {
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

  /// Limpiar campos
  void limpiarTexts() {
    _nameClientController.text = '';
    _numberPhoneController.text = '';
    _directionController.text = '';
    _emailController!.text = '';
  }

  /// Registrar cliente
  void registerClient(BuildContext context) async {
    String name = _nameClientController.text.trim();
    String number = _numberPhoneController.text.trim();
    String direction = _directionController.text.trim();
    String email = _emailController!.text.trim();

    Client newClient = Client(
        nameClient: name,
        numberPhone: number,
        direction: direction,
        email: email,
        state: 'A',
        createdAt: DateTime.now().toIso8601String());

    try {
      //var message = await ClientControllerSQLite.addClient(newClient);
      var message = await ClientControllerMongo.addClient(newClient);
      if (!message.toLowerCase().contains("error")) {
        limpiarTexts();
      }
      showToast(message);
      goToClientList();
    } catch (e) {
      log('Error al registrar al cliente: $e');
    }
  }

  /// Actualizar cliente
  void updateClient(BuildContext context) async {
    String name = _nameClientController.text.trim();
    String number = _numberPhoneController.text.trim();
    String direction = _directionController.text.trim();
    String email = _emailController!.text.trim();

    /// Aqui se crea un nuevo objeto con el id, el toMap() solo hara que los campos necesarios se actualizen
    Client newClient = Client(
        uid: idCliente is mongo.ObjectId ? idCliente : null,
        id: idCliente is int ? idCliente : 0,
        nameClient: name,
        numberPhone: number,
        direction: direction,
        email: email,
        updatedAt: DateTime.now());
    log(newClient.toString());
    try {
      var message = await ClientControllerMongo.updateClient(newClient);
      //var message = await ClientControllerSQLite.updateClient(newClient);
      if (!message.toLowerCase().contains("error")) {
        limpiarTexts();
      }
      showToast(message);
      goToClientList();
    } catch (e) {
      log('Error al actualizar al usuario: $e');
    }
  }

  /// Eliminar cliente
  void deleteClient() async {
    try {
      //var message = await ClientControllerSQLite.deleteClient(widget.idClient);
      var message = await ClientControllerMongo.deleteClient(widget.idClient);
      if (!message.toLowerCase().contains("error")) {
        goToClientList();
      }
      showToast(message);
    } catch (e) {
      log('Error en eliminacion de cliente $e');
    }
  }

  /// Navegar a lista de clientes
  void goToClientList() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const ClientListView(),
      ),
    );
  }

}//End class
