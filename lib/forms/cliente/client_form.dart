import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
//import 'package:f_managment_stream_accounts/controllers/sqlite/client_controller_sqlite.dart';
import 'package:f_managment_stream_accounts/controllers/mongo/client_controller_mongo.dart';
import 'package:f_managment_stream_accounts/forms/components/custom_elevated_button.dart';
import 'package:f_managment_stream_accounts/forms/components/custom_textfield.dart';
import 'package:f_managment_stream_accounts/models/client.dart';
import 'package:f_managment_stream_accounts/utils/helpful_functions.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  final ImagePicker _imagePicker = ImagePicker();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  //Campos
  File? _image;
  Uint8List? _imagenAlmacenada;
  dynamic idCliente;
  dynamic idImagenAlmacenada;
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

  ///Obtener cliente si viene de list
  Future<void> obtenerClienteAsync() async {
    if (widget.idClient != 0) {
      //Client? cliente = await ClientControllerSQLite.getClient(widget.idClient);
      Client? cliente = await ClientControllerMongo.getClient(widget.idClient);
      log(cliente.toString());
      if (isNotNull(cliente.imagen)) {
        log('Entra aqui en imagen');
        _imagenAlmacenada =
            await ClientControllerMongo.getClientImage(cliente.imagen!);
        //log(_imagenAlmacenada.toString());
      }
      setState(() {
        idCliente = cliente.id ?? cliente.uid;
        idImagenAlmacenada = cliente.imagen;
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
        title: const Text('Cliente'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
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
      body: SingleChildScrollView(
        child: formClient(context),
      ),
    );
  }

  /// Formulario de cliente
  Widget formClient(BuildContext context) {
    return Form(
      key: _key,
      child: Column(
        children: [
          Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: displayImage(),
          ),
          ElevatedButton.icon(
            onPressed: _escogerImagen,
            icon: const Icon(Icons.image),
            label: const Text('Seleccionar Imagen'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
            child: CustomTextFormField(
              labelText: 'Nombres',
              controller: _nameClientController,
              validator: messageValidator,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
            child: CustomTextFormField(
              labelText: 'Número celular',
              controller: _numberPhoneController,
              validator: messageValidator,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
            child: CustomTextFormField(
              labelText: 'Dirección',
              controller: _directionController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
            child: CustomTextFormField(
              labelText: 'Correo',
              controller: _emailController,
              validator: validateEmail,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: CustomElevatedButton(
              function: () async {
                //deleteClient(context);
                showDialogMessage(context,
                    title: '¿Esta seguro que desea eliminar este usuario?',
                    callbackYes: deleteClient);
              },
              color: Colors.red,
              title: 'Eliminar',
            ),
          )
        ],
      ),
    );
  }

  /// Mostrar imagen de la bd
  Widget displayImage() {
    if (_image != null) {
      return ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Image.file(
            _image!,
            height: 200,
            width: 200,
            fit: BoxFit.cover,
          ));
    } else if (_imagenAlmacenada != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.memory(
          _imagenAlmacenada!,
          height: 200,
          width: 200,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Container(
        height: 200,
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.grey[200],
        ),
        child: Icon(
          Icons.camera_alt,
          size: 64.0,
          color: Colors.grey[800],
        ),
      );
    }
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

    mongo.ObjectId? imagenId;
    if (_image != null) {
      imagenId = await ClientControllerMongo.saveImageClient(_image!);
    }

    Client newClient = Client(
        nameClient: name,
        numberPhone: number,
        direction: direction,
        email: email,
        state: 'A',
        createdAt: DateTime.now().toIso8601String(),
        imagen: imagenId);

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

    mongo.ObjectId? imagenId;
    if (_image != null && idImagenAlmacenada != null) {
      var msg = await ClientControllerMongo.updateImageClient(
          _image!, idImagenAlmacenada);
      log('Mensaje actualizar $msg');
    } else {
      if (_image != null) {
        imagenId = await ClientControllerMongo.saveImageClient(_image!);
      }
    }

    /// Aqui se crea un nuevo objeto con el id, el toMap() solo hara que los campos necesarios se actualizen
    Client newClient = Client(
        uid: idCliente is mongo.ObjectId ? idCliente : null,
        id: idCliente is int ? idCliente : 0,
        nameClient: name,
        numberPhone: number,
        direction: direction,
        email: email,
        imagen: idImagenAlmacenada ?? imagenId, // no es necesario
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
    /* Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ClientListView(),
      ),
    ); */
    Navigator.pop(context);
  }

  void _escogerImagen() async {
    final img = await _imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (img != null) {
        log(img.path);
        _image = File(img.path);
      } else {
        log('No selecciono ninguna imagen');
      }
    });
  }
}//End class
