import 'dart:developer';
import 'dart:typed_data';
//import 'package:f_managment_stream_accounts/controllers/sqlite/client_controller_sqlite.dart';
import 'package:f_managment_stream_accounts/controllers/mongo/client_controller_mongo.dart';
import 'package:f_managment_stream_accounts/forms/cliente/client_form.dart';
import 'package:f_managment_stream_accounts/forms/components/search_delegate.dart';
import 'package:f_managment_stream_accounts/models/client.dart';
import 'package:f_managment_stream_accounts/utils/helpful_functions.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

const _defaultClientImage = 'assets/ichi.jpg';

// ignore: must_be_immutable
class ClientListView extends StatefulWidget {
  bool returnClient;
  ClientListView({super.key, this.returnClient = false});

  @override
  State<StatefulWidget> createState() => ClientListViewState();
}

class ClientListViewState extends State<ClientListView> {
  static bool returnClient = false;
  List<Client>? clientes;
  List<Client>? clientesHistorial = [];

  @override
  void initState() {
    initializeClients();
    setState(() {
      returnClient = widget.returnClient;
    });
    super.initState();
  }

  Future initializeClients() async {
    try {
      List<Client>? clientesCargados = await ClientControllerMongo.getClients();
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
              //var cliente = await
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
        onPressed: () => _onClientForm(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: clientes != null
          ? buildClientTile(context, clientes!)
          : const Center(child: CircularProgressIndicator()),
    );
  }

  /// Abrir el formulario para actualizar o agregar cliente
  static void _onClientForm(BuildContext context, {dynamic idClient}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClientFormScreen(idClient),
      ),
    );
  }

  ///Contruir client space tile
  static Widget buildClientTile(BuildContext context, List<Client>? clientes) {
    return ListView.builder(
      itemCount: clientes!.length,
      itemBuilder: (_, index) {
        final client = clientes[index];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.5),
          child: ListTile(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 10.0, vertical: 5), // padding del listtile
            //tileColor: const Color.fromARGB(255, 43, 42, 42), // color del fondo
            leading: AspectRatio(
              aspectRatio: 0.9,
              //child: Image.asset(_defaultClientImage),
              child: isNotNull(client.imagen)
                  ? FutureBuilder(
                      future: getImageClient(client.imagen),
                      builder: builderImage,
                    )
                  : Image.asset(_defaultClientImage),
            ),
            title: Text('${client.nameClient}',
                style: Theme.of(context).textTheme.titleLarge),
            subtitle: Row(
              children: [
                const Icon(Icons.numbers),
                Text('${client.numberPhone}')
              ],
            ),
            trailing: Text('${client.numberPhone} '),
            onTap: () {
              if (returnClient) {
                log('Retornando cliente ...');
                log(client.toString());
                Navigator.pop(context, client);
              } else {
                _onClientForm(context, idClient: client.id ?? client.uid);
              }
            },
          ),
        );
      },
    );
  }

  ///Retorna campo nombre para SearchDelegate
  String getName(Client client) {
    return client.nameClient!;
  }

  /// Obtener imagen de cliente
  static Future<Uint8List> getImageClient(mongo.ObjectId? idImage) async {
    Uint8List? imgList = await ClientControllerMongo.getClientImage(idImage!);
    return imgList!;
  }

  /// Construir imagen de cliente
  static Widget builderImage(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const CircularProgressIndicator();
    } else {
      return Image.memory(snapshot.data!);
    }
  }
}
