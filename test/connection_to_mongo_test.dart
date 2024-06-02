// ignore_for_file: avoid_print

import 'package:f_managment_stream_accounts/models/platform.dart';
import 'package:mongo_dart/mongo_dart.dart';

void main() async {
  
  try {
    Db db = Db('mongodb://localhost:27017/msi_dart');
    await db.open();

    /*  print("conexion exitosa");
    print("Consultando datos");

    var libroCollection = db.collection('libro');

    libroCollection.find().forEach((e) => print(e.toString()));
    var libros = await libroCollection.find().toList();

    print(libros.first.toString());
    var libro = libros.first;
    print(libro['_id']);

    var otrolibro =
        await libroCollection.find(where.eq("_id", libro['_id'])).toList();

    print("Busqueda de libro por object_id");
    print(otrolibro.first.toString());

    print('/******************* lookup */');
    final lookup = Lookup(
        from: 'usuario',
        localField: 'id_usuario',
        foreignField: '_id',
        as: 'usuario');

    final unwind = Unwind(const Field('usuario'));

    final pipeline =
        AggregationPipelineBuilder().addStage(lookup).addStage(unwind).build();

    var result = await libroCollection.aggregateToStream(pipeline).toList();

    for (var e in result) {
      print(e.toString());
    } */
    var plataformCollection = db.collection('platform');

    print('/******************* PRUEBAS INSERT MONGO ****************/');

    Platform p = Platform(namePlatform: 'test', description: 'resting');

    var result = await plataformCollection.insertOne(p.toMap());

    print(result.document!);

    var fromMap = Platform.fromMap(result.document!);

    print(fromMap.toString());

    print('/******************* PRUEBAS UPDATE MONGO ****************/');

    var plataforma = await plataformCollection.findOne({'_id': fromMap.uid});

    print(plataforma.toString());

    var objPlatform = Platform.fromMap(plataforma!);

    print(objPlatform.toString());

    await db.close();

    print("Conexion cerrada");
  } catch (e) {
    print("message $e");
  }
}
