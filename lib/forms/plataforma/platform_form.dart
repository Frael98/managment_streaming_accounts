import 'dart:developer';

import 'package:f_managment_stream_accounts/controllers/mongo/platforms_controller_mongo.dart';
import 'package:f_managment_stream_accounts/forms/components/custom_dropdown_field.dart';
import 'package:f_managment_stream_accounts/forms/components/custom_elevated_button.dart';
import 'package:f_managment_stream_accounts/forms/components/custom_textfield.dart';
import 'package:f_managment_stream_accounts/forms/plataforma/platform_list.dart';
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
  dynamic idPlatform = 0;
  late AnimationController _controller;

  final TextEditingController _platformNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    obtenerPlatformAsync();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> obtenerPlatformAsync() async {
    if (widget.idPlatform != 0) {
      Platform? plataforma =
          await PlatformControllerMongo.getPlatform(widget.idPlatform);
      log(plataforma.toString());
      setState(() {
        idPlatform = plataforma.id ?? plataforma.uid;
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
      body: Form(
        child: Column(
          children: [
            //const SizedBox(height: 10,),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
              child: CustomTextFormField(
                  labelText: 'Platforma', controller: _platformNameController),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
              child: CustomTextFormField(
                  labelText: 'Descripcion', controller: _descriptionController),
            ),
            //const CustomDropDownField(),
            CustomElevatedButton(
                color: Colors.deepOrange,
                title: "Eliminar",
                function: () async {
                  // if (_formkey3.currentState != null &&
                  //     _formkey3.currentState!.validate()) {
                  //await Updatetask(widget.docId, context);
                  // }
                })
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.save),
      ),
    );
  }

  /// Limpiar campos
  void limpiarTexts() {
    _platformNameController.text = '';
    _descriptionController.text = '';
  }

  /// Registrar plataforma
  void registerPlatform(BuildContext context) async {
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
        limpiarTexts();
        goToPlatformList();
      }
      showToast(message);
    } catch (e) {
      log('Error al registrar al cliente: $e');
    }
  }

  /// Actualizar plataforma
  void updatePlatform(BuildContext context) async {
    String name = _platformNameController.text.trim();
    String description = _descriptionController.text.trim();

    /// Aqui se crea un nuevo objeto con el id, el toMap() solo hara que los campos necesarios se actualizen
    Platform updated = Platform(
      uid: idPlatform is mongo.ObjectId ? idPlatform : null,
      id: idPlatform is int ? idPlatform : 0,
      namePlatform: name,
      description: description,
      updatedAt: DateTime.now(),
    );
    log(updated.toString());
    try {
      var message = await PlatformControllerMongo.updatePlatform(updated);

      if (!message.toLowerCase().contains("error")) {
        limpiarTexts();
      }
      showToast(message);
      goToPlatformList();
    } catch (e) {
      log('Error al actualizar plataforma: $e');
    }
  }

  /// Eliminar plataforma
  void deletePlatform(BuildContext context) async {
    try {
      var message =
          await PlatformControllerMongo.updatePlatform(widget.idPlatform);
      if (!message.toLowerCase().contains("error")) {
        goToPlatformList();
      }
      showToast(message);
    } catch (e) {
      log('Error en eliminacion de plataforma $e');
    }
  }

  /// Navegar a lista de plataformas
  void goToPlatformList() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const PlatformListView(),
      ),
    );
  }
}// End class
