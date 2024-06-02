import 'dart:developer';
import 'package:f_managment_stream_accounts/controllers/mongo/client_controller_mongo.dart';
import 'package:f_managment_stream_accounts/controllers/sqlite/client_controller_sqlite.dart';
import 'package:f_managment_stream_accounts/forms/cliente/client_form.dart';
import 'package:f_managment_stream_accounts/forms/components/search_delegate.dart';
import 'package:f_managment_stream_accounts/models/client.dart';
import 'package:flutter/material.dart';

const _defaultClientImage = 'assets/ichi.jpg';

class ClientListView extends StatefulWidget {
  const ClientListView({super.key});

  @override
  State<StatefulWidget> createState() => ClientListViewState();
}

class ClientListViewState extends State<ClientListView> {
  List<Client>? clientes;
  List<Client>? clientesHistorial = [];

  @override
  void initState() {
    initializeClients();
    super.initState();
  }

  Future initializeClients() async {
    try {
      List<Client>? clientesCargados =
          await ClientControllerMongo.getClients();
          //await ClientControllerSQLite.getClients();
      setState(() {
        clientes = clientesCargados;
      });
      log("Clientes cargados");
    } catch (e) {
      log('Error consultando datos $e');
    }
  }

  /// Widget global
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              //var cliente =
              showSearch(
                  context: context,
                  delegate: SearchFieldDelegate(clientes!, getName));
              //, clientesHistorial!));

              //clientesHistorial!.insert(0, cliente as Client);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () => onClientForm(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: clientes != null
          ? buildClientTile(context, clientes!)
          : const Center(child: CircularProgressIndicator()),
    );
  }

  /// Abrir el formulario para actualizar o agregar cliente
  static void onClientForm(BuildContext context, {int? idClient}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClientFormScreen(idClient ?? 0),
      ),
    );
  }

  ///
  static Widget buildClientTile(BuildContext context, List<Client>? clientes) {
    return ListView.builder(
      itemCount: clientes!.length,
      itemBuilder: (_, index) {
        final client = clientes[index];

        /* return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.grey),
            color: const Color.fromARGB(255, 78, 78, 76)
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.5),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.all(10.0), // padding del listtile
              tileColor:
                  const Color.fromARGB(255, 66, 65, 65), // color del fondo
              leading: AspectRatio(
                aspectRatio: 0.9,
                child: Image.asset(_defaultClientImage),
              ),
              title: Text(client.nameClient!,
                  style: Theme.of(context).textTheme.titleLarge),
              trailing: Text('${client.numberPhone!} '),
              onTap: () => onClientForm(context, idClient: client.idClient),
            ),
          ),
        ); */

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.5),
          child: ListTile(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            contentPadding: const EdgeInsets.all(10.0), // padding del listtile
            tileColor: const Color.fromARGB(255, 66, 65, 65), // color del fondo
            leading: AspectRatio(
              aspectRatio: 0.9,
              child: Image.asset(_defaultClientImage),
            ),
            title: Text(client.nameClient!,
                style: Theme.of(context).textTheme.titleLarge),
            trailing: Text('${client.numberPhone!} '),
            onTap: () => onClientForm(context, idClient: client.idClient),
          ),
        );
      },
    );
  }

  String getName(Client client) {
    return client.nameClient!;
  }
}
