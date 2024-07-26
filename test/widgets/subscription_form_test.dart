import 'dart:developer';

import 'package:f_managment_stream_accounts/forms/cliente/client_list.dart';
import 'package:f_managment_stream_accounts/forms/components/custom_date_picker.dart';
import 'package:f_managment_stream_accounts/forms/components/custom_textfield.dart';
import 'package:f_managment_stream_accounts/forms/cuentas/account_list.dart';
import 'package:f_managment_stream_accounts/models/account.dart';
import 'package:f_managment_stream_accounts/models/client.dart';
import 'package:f_managment_stream_accounts/utils/constantes.dart';
import 'package:f_managment_stream_accounts/utils/helpful_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SubscriptionFormScreenTest extends StatefulWidget {
  const SubscriptionFormScreenTest({super.key});

  @override
  State<SubscriptionFormScreenTest> createState() => _SubscriptionFormScreenState();
}

class _SubscriptionFormScreenState extends State<SubscriptionFormScreenTest> {
  //List<Account> cuentas = [];
  Account? _account;
  final List<Client> _clients = [];
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  //final TextEditingController _accountController = TextEditingController();
  int accountCapacity = 0;
  List<bool> _expandedClients = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Subscripción'),
        ),
        body: SingleChildScrollView(
          child: formSubscription(context),
        )
        /* cuentas.isNotEmpty
          ? formSubscription(context)
          : const Center(
              child: CircularProgressIndicator(),
            ), */
        );
  }

  @override
  void initState() {
    //getComboAccounts();
    super.initState();
  }

  Widget formSubscription(BuildContext context) {
    return Form(
      key: _key,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: OutlinedButton(
              onPressed: _addAccount,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Icon(Icons.add), Text('Agregar cuenta')],
              ),
            ),
          ),
          isNotNull(_account)
              ? Slidable(
                  key: Key(isNotNull(_account) ? _account!.uid!.oid : ''),
                  endActionPane:
                      ActionPane(motion: const ScrollMotion(), children: [
                    SlidableAction(
                      onPressed: (context) {
                        //showAboutDialog(context)
                        log('Elimando cuenta');
                      },
                      icon: Icons.delete,
                    )
                  ]),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: ExpansionTile(
                      title: isNotNull(_account)
                          ? Text(
                              _account!.email!,
                              style: TextStyle(
                                  color: colorStates[_account!.state]),
                            )
                          : const Text('Agregue una cuenta!.'),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: isNotNull(_account)
                            ? [
                                Text(_account!.typeAccount!.nameTypeAccount!),
                                Text(_account!.platform!.namePlatform!),
                              ]
                            : [],
                      ),
                      children: [
                        isNotNull(_account)
                            ? Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Row(
                                      children: [
                                        const Text(
                                          "Fecha Compra: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                            '${Format.toDateMonthLetter(_account!.registerDate!)} Hora ${_account!.registerDate!.toLocal().hour}:${_account!.registerDate!.toLocal().minute}')
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Row(
                                      children: [
                                        const Text(
                                          "Fecha Corte: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(Format.toDateMonthLetter(
                                            _account!.expireDate!))
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Row(
                                      children: [
                                        const Text(
                                          "Tiempo comprado: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(_account!.timeLimit!)
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Row(
                                      children: [
                                        const Text(
                                          "Capacidad: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                            _account!.perfilQuantity.toString())
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Row(
                                      children: [
                                        const Text(
                                          'Costo: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text('\$ ${_account!.price!}')
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Row(
                                      children: [
                                        const Text(
                                          'Estado: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          '${_account!.state}',
                                          style: TextStyle(
                                              color:
                                                  colorStates[_account!.state]),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              )
                            : const Text('No data'),
                      ],
                    ),
                  ),
                )
              : const Card(
                  child: Text('Agregue una cuenta!'),
                ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: OutlinedButton(
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.resolveWith<Color?>(
                    (Set<WidgetState> states) {
                  // Here, you can define different colors for different states if needed.
                  return const Color(
                      0xFF21BFBD); // Replace with your desired icon color
                }),
              ),
              onPressed: _addClient,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Icon(Icons.add), Text('Agregar cliente')],
              ),
            ),
          ),
          /*  Wrap(
            crossAxisAlignment: WrapCrossAlignment.start,
            //alignment: WrapAlignment.spaceBetween,
            children: _clients
                .map((client) => Padding(
                      padding: const EdgeInsets.all(10),
                      child: GestureDetector(
                        onTap: () {
                          log(client.toString());
                        },
                        child: CircleAvatar(
                          child: Text(client.nameClient!.substring(0, 1)),
                        ),
                      ),
                    ))
                .toList(),
          ), */
          /*  Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: ListView(
                children: [ */
          ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                _expandedClients[index] = isExpanded;
                log('index ${index.toString()}');
              });
            },
            children: _clients.map<ExpansionPanel>((Client client) {
              int index = _clients.indexOf(client);

              return ExpansionPanel(
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(client.nameClient!.substring(0, 1)),
                    ),
                    title: Text(client.email!),
                  );
                },
                body: /* ListTile(
                          title: Text('Details about $client'),
                          subtitle: Text('More details here...'),
                        ), */
                    Card(
                  child: Row(
                    children: [
                      //Text('Paga:'),
                      Container(
                        width: 200,
                        height: 50,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        margin: const EdgeInsets.all(10),
                        child: CustomTextFormField(
                            labelText: 'Paga',
                            controller: TextEditingController()),
                      )
                    ],
                  ),
                ),
                isExpanded: _expandedClients[index],
              );
            }).toList(),
          ),
          /*        ],
              ),
            ),
          ) */
        ],
      ),
    );
  }

  /// Agrega una cuenta
  void _addAccount() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AccountListView(
          returnAccount: true,
        ),
      ),
    );
    if (result != null) {
      setState(() {
        _account = result;
        accountCapacity = _account!.perfilQuantity!;
        _expandedClients = [];
      });
    }
  }

  /// Agrega clientes segun la capacidad de la cuenta
  void _addClient() async {
    if (_clients.length < accountCapacity) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ClientListView(
            returnClient: true,
          ),
        ),
      );
      if (result != null && !_clients.contains(result)) {
        setState(() {
          log('agregando cliente a la lista');
          _clients.add(result);
          _expandedClients.add(false);
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Capacidad de la cuenta alcanzada'),
      ));
    }
  }

  // added 30/06/2024 15:09
  Widget _buildExpandableClientCard(Client client, int index) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              child: Text(client.nameClient!.substring(0, 1)),
            ),
            title: Text(client.nameClient!),
            trailing: Icon(_expandedClients[index]
                ? Icons.expand_less
                : Icons.expand_more),
            onTap: () {
              setState(() {
                _expandedClients[index] = !_expandedClients[index];
              });
            },
          ),
          if (_expandedClients[index])
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Email: ${client.numberPhone}'),
                  Text('Teléfono: ${client.direction}'),
                  // Agrega más detalles del cliente aquí
                ],
              ),
            ),
        ],
      ),
    );
  }

}
