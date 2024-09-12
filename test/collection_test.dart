import 'dart:developer';
import 'package:f_managment_stream_accounts/models/client.dart';
import 'package:mongo_dart/mongo_dart.dart';

class Subscription {
  String? _cod;
  List<Client>? _clients;
  double? _valueToPay;

  Subscription(
      {String? codSubscription, List<Client>? clients, double? valueToPay})
      : _cod = codSubscription,
        _clients = clients,
        _valueToPay = valueToPay;

  factory Subscription.fromMapObject(Map<String, dynamic> map) {
    // Parseando la lista de clientes desde el mapa
    //log(map.toString());
    try {
      dynamic clientsData = (map['clients'] ?? map['CLIENTS']);
      //log(clientsData.toString());
      List<Client> clientes = clientsData
          .map((clientMap) => Client.fromMap(clientMap))
          .toList()
          .cast<Client>();

      //log(clientes.toString());
      return Subscription(
          codSubscription: map['cod_subscription'], clients: clientes);
    } catch (e) {
      throw FormatException(
          'Error al convertir el mapa a objeto Subscription $e');
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'cod_subscription': codSubscription,
      'clients': clients!.map((c) => c.toMapIdAndPrice()).toList(),
      'value_to_pay': valueToPay,
    };
  }

  // Getter methods
  String? get codSubscription => _cod;
  List<Client>? get clients => _clients!;
  double get valueToPay => _valueToPay!;
}

void main() async {
  Db? db;

  try {
    db = Db('mongodb://localhost:27017/test');
    await db.open();
  } catch (e) {
    log('$e');
  }

  ///Crear la subscripcion
  List<Client> clientes = [
    Client(nameClient: 'Eduardo', direction: 'Olmedo'),
    Client(nameClient: 'Jaime', direction: 'Quevedo'),
    Client(nameClient: 'Pedro', direction: 'Cordova'),
  ];

  Subscription subscription =
      Subscription(codSubscription: "001", clients: clientes, valueToPay: 20);
  final collection = db!.collection('subscripcion_test');
  var res = await collection.insertOne(subscription.toMap());

  log("${res.isSuccess}");

  //var result = await collection!.findOne({'_id': uid});
  final match =
      Match({'_id': ObjectId.fromHexString('66dddd7f22f8b293d0000000')});
  var result = await collection.findOne({'_id': ObjectId.fromHexString('66dddd7f22f8b293d0000000')});
  //var result = await collection!.aggregateToStream(pipeline).first;
  print("{$result}");

  await db.close();
}
