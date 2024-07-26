import 'dart:developer';

import 'package:f_managment_stream_accounts/controllers/mongo/platforms_controller_mongo.dart';
import 'package:f_managment_stream_accounts/forms/components/custom_elevated_button.dart';
import 'package:f_managment_stream_accounts/forms/components/custom_textfield.dart';
//import 'package:f_managment_stream_accounts/forms/plataforma/platform_list.dart';
import 'package:f_managment_stream_accounts/models/platform.dart';
import 'package:f_managment_stream_accounts/utils/helpful_functions.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

// ignore: must_be_immutable
class PlatformFormScreen extends StatefulWidget {
  PlatformFormScreen({super.key, this.idPlatform});
  dynamic idPlatform;

  @override
  State<PlatformFormScreen> createState() => _PlatformFormScreenState();
}

class _PlatformFormScreenState extends State<PlatformFormScreen>
    with SingleTickerProviderStateMixin {
  dynamic _idPlatform = 0;
  late AnimationController _controller;

  // Fields
  final GlobalKey<FormState> _key = GlobalKey();
  final TextEditingController _platformNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _obtenerPlatformAsync();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _obtenerPlatformAsync() async {
    if (widget.idPlatform != 0) {
      Platform? plataforma =
          await PlatformControllerMongo.getPlatform(widget.idPlatform);
      log(plataforma.toString());
      setState(() {
        _idPlatform = plataforma.id ?? plataforma.uid;
      });
      _platformNameController.text = plataforma.namePlatform!;
      _descriptionController.text = plataforma.description!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plataforma'),
      ),
      body: _formPlatform(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_key.currentState!.validate()) {
            if (_idPlatform != 0) {
              _updatePlatform(context);
            } else {
              _registerPlatform(context);
            }
          }
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.save),
      ),
    );
  }

  /// Formulario
  Widget _formPlatform() {
    return Form(
      key: _key,
      child: Column(
        children: [
          //const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
            child: CustomTextFormField(
              labelText: 'Platforma',
              controller: _platformNameController,
              validator: messageValidator,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
            child: CustomTextFormField(
                labelText: 'Descripcion', controller: _descriptionController),
          ),
          //const CustomDropDownField(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: CustomElevatedButton(
                color: Colors.red,
                title: "Eliminar",
                //isIcon: true,
                function: () async {
                  await Future.delayed(const Duration(seconds: 2), () {
                    // Código para ejecutar después de 2 segundos
                    log('¡Esta línea se imprimirá después de 10 segundos!');
                  });
                }),
          ),
        ],
      ),
    );
  }

  /// Limpiar campos
  void _limpiarTexts() {
    _platformNameController.text = '';
    _descriptionController.text = '';
  }

  /// Registrar plataforma
  void _registerPlatform(BuildContext context) async {
    String platformName = _platformNameController.text.trim();
    String description = _descriptionController.text.trim();

    Platform newPlatform = Platform(
        namePlatform: platformName,
        description: description,
        state: 'A',
        createdAt: DateTime.now().toIso8601String());

    try {
      var message = await PlatformControllerMongo.addPlatform(newPlatform);
      if (!message.toLowerCase().contains("error")) {
        _limpiarTexts();
        _goToPlatformList();
      }
      showToast(message);
    } catch (e) {
      log('Error al registrar al cliente: $e');
    }
  }

  /// Actualizar plataforma
  void _updatePlatform(BuildContext context) async {
    String name = _platformNameController.text.trim();
    String description = _descriptionController.text.trim();

    /// Aqui se crea un nuevo objeto con el id, el toMap() solo hara que los campos necesarios se actualizen
    Platform updated = Platform(
      uid: _idPlatform is mongo.ObjectId ? _idPlatform : null,
      id: _idPlatform is int ? _idPlatform : 0,
      namePlatform: name,
      description: description,
      updatedAt: DateTime.now(),
    );
    log(updated.toString());
    try {
      var message = await PlatformControllerMongo.updatePlatform(updated);

      if (!message.toLowerCase().contains("error")) {
        _limpiarTexts();
      }
      showToast(message);
      _goToPlatformList();
    } catch (e) {
      log('Error al actualizar plataforma: $e');
    }
  }

  /// Eliminar plataforma
  void _deletePlatform(BuildContext context) async {
    try {
      var message =
          await PlatformControllerMongo.deletePlatform(widget.idPlatform);
      if (!message.toLowerCase().contains("error")) {
        _goToPlatformList();
      }
      showToast(message);
    } catch (e) {
      log('Error en eliminacion de plataforma $e');
    }
  }

  /// Navegar a lista de plataformas
  void _goToPlatformList() {
    Navigator /* pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const PlatformListView(),
      ),
    ) */
        .pop(context);
  }
} // End class
