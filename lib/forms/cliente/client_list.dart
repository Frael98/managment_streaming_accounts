import 'dart:developer';
import 'package:f_managment_stream_accounts/controllers/client_controller.dart';
import 'package:f_managment_stream_accounts/forms/cliente/client_form.dart';
import 'package:f_managment_stream_accounts/models/client.dart';
import 'package:flutter/material.dart';

class ClientListView extends StatelessWidget {
  const ClientListView({super.key});

  /// Widget global
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () => onClientForm(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: FutureBuilder(future: getClients(context), builder: getBuilder),
    );
  }

  ///Obtiene lista de clientes de la BD
  Future<List<Widget>> getClients(BuildContext context) async {
    try {
      List<Client>? clientes = await ClientController.getClients();
      return clientes!
          .map((cliente) => buildClientTile(context, cliente))
          .toList();
    } catch (e) {
      log('Error consultando datos $e');
      return [];
    }
  }

  ///
  Widget buildClientTile(BuildContext context, Client client) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: AspectRatio(
          aspectRatio: 0.9,
          child: Image.asset('assets/ichi.jpg'),
        ),
        title: Text(client.nameClient!,
            style: Theme.of(context).textTheme.titleLarge),
        trailing: Text('${client.numberPhone!} '),
        onTap: () => onClientForm(context, idClient: client.idClient),
      ),
    );
  }

  /// Abrir el formulario para actualizar o agregar cliente
  void onClientForm(BuildContext context, {int? idClient}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClientFormScreen(idClient ?? 0),
      ),
    );
  }

  Widget searchFieldText() {
    return const TextField(
        autofocus: true,
        decoration: InputDecoration(hintText: 'Buscar cliente'));
  }

  /// Widget de los tiles
  Widget getBuilder(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            searchFieldText(),
            ...snapshot.data as List<Widget>,
            ...List.generate(30, (index) => const ListTile(leading: Text('data'), )),
            const SizedBox(height: 20.0),
          ],
        ),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}
