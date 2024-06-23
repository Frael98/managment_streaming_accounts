import 'dart:developer';

import 'package:f_managment_stream_accounts/controllers/mongo/account_controller_mongo.dart';
import 'package:f_managment_stream_accounts/forms/cliente/client_list.dart';
import 'package:f_managment_stream_accounts/forms/components/custom_date_picker.dart';
import 'package:f_managment_stream_accounts/forms/components/custom_dropdown_field.dart';
import 'package:f_managment_stream_accounts/forms/components/custom_elevated_button.dart';
import 'package:f_managment_stream_accounts/forms/cuentas/account_list.dart';
import 'package:f_managment_stream_accounts/models/account.dart';
import 'package:f_managment_stream_accounts/models/client.dart';
import 'package:f_managment_stream_accounts/utils/constantes.dart';
import 'package:f_managment_stream_accounts/utils/helpful_functions.dart';
import 'package:flutter/material.dart';

class SubscriptionFormScreen extends StatefulWidget {
  const SubscriptionFormScreen({super.key});

  @override
  State<SubscriptionFormScreen> createState() => _SubscriptionFormScreenState();
}

class _SubscriptionFormScreenState extends State<SubscriptionFormScreen> {
  //List<Account> cuentas = [];
  Account? _account;
  List<Client> _clients = [];
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  //final TextEditingController _accountController = TextEditingController();
  int accountCapacity = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Subscripción'),
        ),
        body: formSubscription(context)
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: ExpansionTile(
              title: isNull(_account)
                  ? Text(_account!.email)
                  : const Text('Agregue una cuenta!.'),
              children: [
                isNull(_account)
                    ? Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Row(
                              children: [
                                const Text(
                                  "Fecha Compra: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                    '${Format.toDateMonthLetter(_account!.registerDate)} Hora ${_account!.registerDate.toLocal().hour}:${_account!.registerDate.toLocal().minute}')
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
                                Text(Format.toDateMonthLetter(
                                    _account!.expireDate))
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Row(
                              children: [
                                const Text(
                                  "Tiempo comprado: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
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
                                  "Tipo Cuenta: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(_account!.typeAccount.nameTypeAccount!)
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Row(
                              children: [
                                const Text(
                                  "Plataforma: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(_account!.platform.namePlatform!)
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Row(
                              children: [
                                const Text(
                                  "Capacidad: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(_account!.perfilQuantity.toString())
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
                                      color: colorStates[_account!.state]),
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
          Wrap(
            children: _clients
                .map((client) => GestureDetector(
                      onTap: () {
                        // Show client details
                      },
                      child: CircleAvatar(
                        child: Text(client
                            .nameClient!), // Placeholder for client photo or initials
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

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
        accountCapacity = _account!.perfilQuantity;
      });
    }
  }

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
          _clients.add(result);
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Capacity reached'),
      ));
    }
  }
}
