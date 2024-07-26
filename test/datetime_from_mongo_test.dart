// ignore_for_file: avoid_print

import 'package:f_managment_stream_accounts/models/client.dart';
import 'package:mongo_dart/mongo_dart.dart';

void main() async {
  print('************ probando conversion de datetime - consulta de datos');

  try {
    Db db = Db('mongodb://localhost:27017/msi_dart');
    await db.open();

    var clientCollection = db.collection('clients');

    var result = await clientCollection.findOne();

    print(Client.fromMap(result!).toString());
    print(Client.fromMapAudit(result).toString());

    print('************ CLIENTE');
    print('**** REGISTAR CLIENTE');

    Client c = Client(nameClient: 'Juanito', createdAt: DateTime.now());

    var register = await clientCollection.insertOne(c.toMap());

    if (register.isSuccess) {
      print("Cliente registrado ${register.document}");
    } else {
      print(register.errmsg);
    }

    print('**** ACTUALIZAR CLIENTE');

    /* Client updated = Client(
      nameClient: "Pepito"
    ); */
    Client casteado = Client.fromMap(register.document!);

    Client updated = Client(
      uid: casteado.uid,
      id: casteado.id,
      nameClient: "Pepito",
      numberPhone: '09329262242',
      direction: "direction",
      email: "email",
      updatedAt: DateTime.now(),
    );

    var result2 = await clientCollection.updateOne(
      where.eq('_id', updated.uid),
      ModifierBuilder()
          .set('name_client', updated.nameClient)
          .set("number_phone", updated.numberPhone)
          .set('updated_at', updated.updatedAt),
    );

    if (result2.isSuccess) {
      print("Exito ${result2.nModified}");
    } else {
      print("error ${result2.errmsg}");
    }

    await db.close();
  } catch (e) {
    print("Error conectando: $e");
  }
}
