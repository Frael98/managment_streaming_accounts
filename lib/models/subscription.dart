import 'package:f_managment_stream_accounts/interfaces/entity.dart';
import 'package:mongo_dart/mongo_dart.dart';

/// Subscripcion
class Subscription extends Entity {
  final ObjectId _idAccount;
  final List<ObjectId> _clients;
  final DateTime _dateStarted;
  final DateTime _dateFinish;
  final double _valueToPay;

  Subscription({
    uid,
    id,
    required ObjectId idAccount,
    required List<ObjectId> clients,
    required DateTime dateStarted,
    required DateTime dateFinish,
    required double valueToPay,
    state,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  })  : _idAccount = idAccount,
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

  factory Subscription.fromMap(Map<String, dynamic> map) {
    return Subscription(
        uid: map['_id'],
        id: map['id_subscription'] ?? map['ID_SUBSCRIPTION'],
        idAccount: map['id_account'] ?? map['ID_ACCOUNT'],
        clients: map['id_client'] ?? map['ID_CLIENT'],
        dateStarted: map['date_started'] ?? map['DATE_STARTED'],
        dateFinish: map['date_finish'] ?? map['DATE_FINISH'],
        valueToPay: map['value_to_pay'] ?? map['VALUE_TO_PAY']);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id_account': idAccount,
      'id_client': clients,
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
  ObjectId get idAccount => _idAccount;
  List<ObjectId> get clients => _clients;
  DateTime get dateStarted => _dateStarted;
  DateTime get dateFinish => _dateFinish;
  double get valueToPay => _valueToPay;

  @override
  String toString() {
    return "Subscription(uid(MongoId): $uid, id(SQLite); $id, idAccount: $idAccount, idClient: ${_clients.toString()}, dateStarted: $dateStarted, dateFinish: $dateFinish, valueToPay: $valueToPay)";
  }

  @override
  Map<String, dynamic> toMapForSQLite() {
    return {
      'id_account': idAccount,
      'id_client': _clients,
      'date_started': dateStarted.toIso8601String(),
      'date_finish': dateFinish.toIso8601String(),
      'value_to_pay': valueToPay
    };
  }
}
