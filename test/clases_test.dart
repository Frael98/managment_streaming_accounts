class Animal {
  final String nombre;

  Animal({required this.nombre});
}

void main() {
 /*  Client cliente = Client(nameClient: 'Juanito');

  print(cliente.nameClient);
  cliente.nameClient = 'Pepito';
  print(cliente.nameClient); */

  Animal perro = Animal(nombre: 'perro');
  print(perro.nombre);
  // perro.nombre = 'otro'; - es final no puede ser modificado
  print(perro.nombre);

 /*  Subscription netflix = Subscription(
      idAccount: ObjectId(),
      clients: List.filled(Random().nextInt(5), ObjectId()),
      dateStarted: DateTime.now(),
      dateFinish: DateTime.now(),
      valueToPay: 2.2);
 */
  /* print(netflix.toString()); */
}
