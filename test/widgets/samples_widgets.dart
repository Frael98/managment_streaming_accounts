import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget cardsVistaHorizontal() {
  return const Padding(
    padding: EdgeInsets.all(20), //
    child: SingleChildScrollView(
      scrollDirection:
          Axis.horizontal, // Establecer el desplazamiento horizontal
      child: Row(
        children: [
          Card(
              elevation: 8,
              color: Colors.green,
              child: InkWell(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text("Hola como estas"),
                ),
              )),
          Card(
            color: Colors.blue,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text("Hola como estas"),
            ),
          ),
          Card(
            color: Colors.red,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text("Hola como estas"),
            ),
          ),
        ],
      ),
    ),
  );
}

/// Simple cards verticales
Widget cardsVistaVertical() {
  return const Padding(
    padding: EdgeInsets.all(20),
    child: Column(
      children: [
        Padding(
          padding: EdgeInsets.all(20),
          child: ListTile(
            title: Text('hola que bien'),
            tileColor: Colors.deepPurple,
          ),
        ),
        SizedBox(
          height: 120,
          child: ListTile(
            title: Text('hola que bien'),
            tileColor: Colors.white70,
          ),
        ),
        ListTile(
          title: Text('hola que bien'),
        ),
        ListTile(
          title: Text('hola que bien'),
        ),
      ],
    ),
  );
}

Widget board(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(20),
          child: ListTile(
            titleAlignment: ListTileTitleAlignment.center,
            title: Text('ListTile dentro de un Padding'),
            tileColor: Colors.deepPurple,
          ),
        ),
        const SizedBox(
          height: 120,
          child: ListTile(
            title: Text('ListTile dentro de un SizedBox'),
            tileColor: Colors.black26,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        const ListTile(
          title: Text('hola que bien'),
          tileColor: Colors.redAccent,
        ),
        const ListTile(
          tileColor: Colors.pink,
          title: Text('Solo un ListTile'),
        ),
        const SizedBox(
          height: 8,
        ),
        const Card(
          child: ListTile(
            title: Text(
              'Esto es un LitsTile dentro de un Card',
              textAlign: TextAlign.center,
            ),
            titleAlignment: ListTileTitleAlignment.center,
          ),
        ),
        // Expansion Tiles
        ExpansionTile(
          leading: const FaIcon(FontAwesomeIcons.twitter),
          title: const Text(
            'test@email.com.ec',
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent),
          ),
          children: [
            const ListTile(
              title: Row(
                children: [
                  Text(
                    "Tiempo comprado: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('1 mes')
                ],
              ),
            ),
            ListTile(
              title: Row(
                children: [
                  const Text(
                    "Fecha Compra: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(MaterialLocalizations.of(context)
                      .formatShortDate(DateTime.now()))
                ],
              ),
              subtitle: const Text('derechos reservados'),
            ),
            ListTile(
              title: Row(
                children: [
                  const Text(
                    "Fecha Corte: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(MaterialLocalizations.of(context)
                      .formatShortDate(DateTime.now()))
                ],
              ),
            ),
            const ListTile(
              title: Row(
                children: [
                  Text(
                    "Contraseña: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'thiisapassword',
                  )
                ],
              ),
            ),
            const ListTile(
              title: Row(
                children: [
                  Text(
                    "Costo: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\$2.50',
                  )
                ],
              ),
            ),
            const ListTile(
              title: Row(
                children: [
                  Text(
                    "Estado: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Agotada',
                    style: TextStyle(color: Colors.redAccent),
                  )
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          leading: const FaIcon(FontAwesomeIcons.instagram),
          title: const Text(
            'test@email.com.ec',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.lineThrough,
                color: Colors.redAccent),
          ),
          children: [
            const Padding(
              padding: EdgeInsets.all(5),
              child: Row(
                children: [
                  Text(
                    "Tiempo comprado: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('1 mes')
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  const Text(
                    "Fecha Compra: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(MaterialLocalizations.of(context)
                      .formatShortDate(DateTime.now()))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  const Text(
                    "Fecha Corte: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(MaterialLocalizations.of(context).formatShortDate(
                      DateTime.now().add(const Duration(days: 30))))
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(5),
              child: Row(
                children: [
                  Text(
                    'Costo: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text('\$2.50')
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(5),
              child: Row(
                children: [
                  Text(
                    'Estado: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Desuso',
                    style: TextStyle(color: Colors.redAccent),
                  )
                ],
              ),
            )
          ],
        ),
        ExpansionTile(
          leading: const FaIcon(FontAwesomeIcons.facebookF),
          title: const Text(
            'test@email.com.ec',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                color: Colors.blueAccent),
          ),
          children: [
            const Padding(
              padding: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Tiempo comprado: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('1 mes')
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    "Fecha Compra: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(MaterialLocalizations.of(context)
                      .formatShortDate(DateTime.now()))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    "Fecha Corte: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(MaterialLocalizations.of(context).formatShortDate(
                      DateTime.now().add(const Duration(days: 30))))
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Costo: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text('\$2.50')
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Estado: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Caida',
                    style: TextStyle(color: Colors.redAccent),
                  )
                ],
              ),
            )
          ],
        ),
        ExpansionTile(
          leading: const FaIcon(FontAwesomeIcons.linkedin),
          title: const Text(
            'test@email.com.ec',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.cyan),
          ),
          children: [
            const Padding(
              padding: EdgeInsets.all(5),
              child: Row(
                children: [
                  Text(
                    "Tiempo comprado: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('1 mes')
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  const Text(
                    "Fecha Compra: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(MaterialLocalizations.of(context)
                      .formatShortDate(DateTime.now()))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  const Text(
                    "Fecha Corte: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(MaterialLocalizations.of(context).formatShortDate(
                      DateTime.now().add(const Duration(days: 30))))
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(5),
              child: Row(
                children: [
                  Text(
                    'Costo: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text('\$2.50')
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(5),
              child: Row(
                children: [
                  Text(
                    'Estado: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Totalmente Ocupada',
                    style: TextStyle(color: Colors.cyan),
                  )
                ],
              ),
            )
          ],
        ),
        ExpansionTile(
          leading: const FaIcon(FontAwesomeIcons.tiktok),
          title: const Text(
            'test@email.com.ec',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
          ),
          children: [
            const Padding(
              padding: EdgeInsets.all(5),
              child: Row(
                children: [
                  Text(
                    "Tiempo comprado: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('1 mes')
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  const Text(
                    "Fecha Compra: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(MaterialLocalizations.of(context)
                      .formatShortDate(DateTime.now()))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  const Text(
                    "Fecha Corte: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(MaterialLocalizations.of(context).formatShortDate(
                      DateTime.now().add(const Duration(days: 30))))
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(5),
              child: Row(
                children: [
                  Text(
                    'Costo: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text('\$2.50')
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(5),
              child: Row(
                children: [
                  Text(
                    'Estado: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Totalmente Ocupado',
                    style: TextStyle(color: Colors.green),
                  )
                ],
              ),
            )
          ],
        )
      ],
    ),
  );
}
