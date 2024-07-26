import 'package:f_managment_stream_accounts/interfaces/entity.dart';
import 'package:f_managment_stream_accounts/models/account.dart';
import 'package:f_managment_stream_accounts/models/client.dart';
//import 'package:mongo_dart/mongo_dart.dart';

/// Subscripcion
class Subscription extends Entity {
  String? _codSubscription;
  Account? _account;
  List<Client>? _clients;
  DateTime? _dateStarted;
  DateTime? _dateFinish;
  double? _valueToPay;

  Subscription({
    String? codSubscription,
    uid,
    id,
    Account? account,
    List<Client>? clients,
    DateTime? dateStarted,
    DateTime? dateFinish,
    double? valueToPay,
    state,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  })  : _codSubscription = codSubscription,
        _account = account,
        _clients = clients,
        _dateStarted = dateStarted,
        _dateFinish = dateFinish,
        _valueToPay = valueToPay,
        super(
            uid: uid,
            id: id,
            state: state,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt);

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
          codSubscription: map['cod_subscription'],
          uid: map['_id'],
          id: map['id_subscription'] ?? map['ID_SUBSCRIPTION'] ?? 0,
          account: Account.fromMapObject(map['account'] ?? map['ACCOUNT']),
          clients: clientes,
          dateStarted: map['date_started'] ?? map['DATE_STARTED'],
          dateFinish: map['date_finish'] ?? map['DATE_FINISH'],
          valueToPay: map['value_to_pay'] ?? map['VALUE_TO_PAY']);
    } catch (e) {
      throw FormatException(
          'Error al convertir el mapa a objeto Subscription $e');
    }
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'cod_subscription': codSubscription,
      'account': account!.uid,
      'clients': clients!.map((c) => c.uid).toList(),
      'date_started': dateStarted,
      'date_finish': dateFinish,
      'value_to_pay': valueToPay,
      'state': state,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt
    };
  }

  // Getter methods
  //String? get idSubscription => _idSubscription;
  Account? get account => _account!;
  List<Client>? get clients => _clients!;
  DateTime get dateStarted => _dateStarted!;
  DateTime get dateFinish => _dateFinish!;
  double get valueToPay => _valueToPay!;
  String? get codSubscription => _codSubscription;

  @override
  String toString() {
    return "Subscription(uid(MongoId): $uid, id(SQLite); $id, idAccount: $account, idClient: ${_clients.toString()}, dateStarted: $dateStarted, dateFinish: $dateFinish, valueToPay: $valueToPay)";
  }

  @override
  Map<String, dynamic> toMapForSQLite() {
    return {
      'account': account,
      'clients': clients,
      'date_started': dateStarted.toIso8601String(),
      'date_finish': dateFinish.toIso8601String(),
      'value_to_pay': valueToPay
    };
  }
}
