import 'dart:developer';
import 'package:f_managment_stream_accounts/controllers/client_controller.dart';
import 'package:f_managment_stream_accounts/forms/cliente/client_form.dart';
import 'package:f_managment_stream_accounts/models/client.dart';
import 'package:flutter/material.dart';

class ClientListView extends StatelessWidget {
  const ClientListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Clientes'),
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.plus_one),
            onPressed: () => onClientForm(context)),
        body: FutureBuilder(
            future: getClients(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ...snapshot.data as List<Widget>,
                      const SizedBox(height: 20.0),
                    ],
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }

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

  void onClientForm(BuildContext context, {int? idClient}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ClientFormScreen(idClient ?? 0),
      ),
    );
  }
}
