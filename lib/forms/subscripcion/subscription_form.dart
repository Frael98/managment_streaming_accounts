import 'dart:developer';

import 'package:f_managment_stream_accounts/controllers/mongo/account_controller_mongo.dart';
import 'package:f_managment_stream_accounts/controllers/mongo/subscription_controller_mongo.dart';
import 'package:f_managment_stream_accounts/forms/cliente/client_list.dart';
import 'package:f_managment_stream_accounts/forms/components/custom_account_card.dart';
import 'package:f_managment_stream_accounts/forms/components/custom_textfield.dart';
import 'package:f_managment_stream_accounts/forms/cuentas/account_list.dart';
import 'package:f_managment_stream_accounts/models/account.dart';
import 'package:f_managment_stream_accounts/models/client.dart';
import 'package:f_managment_stream_accounts/models/subscription.dart';
import 'package:f_managment_stream_accounts/utils/helpful_functions.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
//import 'package:flutter_slidable/flutter_slidable.dart';

// ignore: must_be_immutable
class SubscriptionFormScreen extends StatefulWidget {
  mongo.ObjectId? idSubscription;

  SubscriptionFormScreen({super.key, this.idSubscription});

  @override
  State<SubscriptionFormScreen> createState() => _SubscriptionFormScreenState();
}

class _SubscriptionFormScreenState extends State<SubscriptionFormScreen> {
  Subscription? _subscription;

  String? _codSubscription;
  Account? _account;
  List<Client> _clients = [];
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final Map<mongo.ObjectId, TextEditingController> _pagaController = {};

  int _accountCapacity = 0;
  List<bool> _expandedClients = [];

  @override
  void initState() {
    getSubscription();
    getLastSubscription();
    super.initState();
  }

  //Obtener y setear datos de subscripción
  void getSubscription() {
    if (isNotNull(widget.idSubscription)) {
      SubscriptionControllerMongo.getSubscription(widget.idSubscription!)
          .then((s) {
        setState(() {
          _subscription = s;
          _account = s.account;
          _clients = s.clients!;
          _accountCapacity = _account!.perfilQuantity!;
        });
      });
    }
  }

  /// Obtener última subscripción código
  void getLastSubscription() {
    SubscriptionControllerMongo.requestLastSubscription().then(
      (value) {
        setState(() {
          _codSubscription = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Subscripción'),
      ),
      body: SingleChildScrollView(
        child: isNotNull(_codSubscription)
            ? _formSubscription(context)
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialogMessage(context,
              title: 'Esta seguro de guardar esta subscripcion',
              callbackYes: _saveSubscription);
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.save),
      ),
    );
  }

  ///Formulario Subscripcion
  Widget _formSubscription(BuildContext context) {
    return Form(
      key: _key,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                  isNotNull(_subscription)
                      ? 'SUBS-${_subscription!.codSubscription}'
                      : 'SUBS-$_codSubscription',
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
          isNotNull(_subscription)
              ? const SizedBox(
                  height: 2,
                )
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: OutlinedButton(
                    onPressed: _addAccount,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Icon(Icons.add), Text('Agregar cuenta')],
                    ),
                  ),
                ),
          isNotNull(_account)
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: ImprovedCard(
                    account: _account,
                    disableColorDelete: true,
                    deleteAccount: () {
                      if (_subscription == null) {
                        setState(() {
                          _account = null;
                          _clients.clear();
                        });
                      }
                    },
                  ))
              : /* Container(
                  margin: const EdgeInsets.all(15),
                  child: const Text('Agregue una cuenta', style: TextStyle(fontSize: 20),),
                ) */
              const Card(
                  elevation: 4,
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      "Agregue una cuenta",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: OutlinedButton(
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.resolveWith<Color?>(
                    (Set<WidgetState> states) {
                  return const Color(0xFF21BFBD);
                }),
              ),
              onPressed: _addClient,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Icon(Icons.add), Text('Agregar cliente')],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Wrap(
              spacing: 15.0,
              runSpacing: 6.0,
              children: _clients
                  .map(
                    (client) => GestureDetector(
                      onTap: () {
                        _showClientDetails(client);
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            child: Text(
                              client.nameClient!.substring(0, 1),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(client.nameClient!.split(' ')[0])
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  //TODO: IMPLEMENTAR GUARDADO DE PAGOS DE CLIENTES
  /// Mostrar detalles del cliente en cuenta
  void _showClientDetails(Client client) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        ' ${client.nameClient}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              _clients.remove(client);
                            });
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ))
                    ],
                  ),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    labelText: '\$${_account!.price}',
                    controller: //_pagaController.containsKey(client.uid)
                        _pagaController[client.uid]
                    //: TextEditingController()
                    ,
                    //validator: ,
                    keyboardType: TextInputType.number,
                  ),
                  // Add more client details here
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Agrega una cuenta en vista
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
        _accountCapacity = _account!.perfilQuantity!;
        _expandedClients = [];
      });
    }
  }

  /// Agrega clientes segun la capacidad de la cuenta en vista
  void _addClient() async {
    if (_clients.length >= _accountCapacity) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Capacidad de la cuenta alcanzada'),
      ));
      return;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClientListView(
          returnClient: true,
        ),
      ),
    );

    // si resultado no es nula y el cliente no existe en la lista lo agrega
    if (result != null && !_clients.any((c) => c.uid == result.uid)) {
      log('result client ${result.uid}');

      setState(() {
        _clients.add(result);
        _expandedClients.add(false);
        TextEditingController controller = TextEditingController();
        _pagaController[result.uid] = controller;
      });
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Este cliente ya esta en la lista'),
      ));
    }
  }

  /// Guardar subscripcion en base
  void _saveSubscription() async {
    if (_account != null && _clients.isNotEmpty) {
      Subscription subscription = Subscription(
          codSubscription: 'SUBS-$_codSubscription',
          account: Account.uid(uid: _account!.uid!),
          clients: _clients,
          dateStarted: DateTime.now(),
          dateFinish: DateTime.now().add(const Duration(days: 20)),
          valueToPay: 2.5);

      try {
        var message =
            await SubscriptionControllerMongo.addSubscription(subscription);

        if (!message.contains('error')) {
          String state = "parcialmente disponible";
          if (_clients.length == _accountCapacity) state = "ocupado";

          var message2 = await AccountControllerMongo.updateStateAccount(
              _account!.uid!, state);

          log(message2);
        }

        showToast(message);
      } catch (e) {
        log("Save subscription error: $e");
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Seleccione una cuenta y al menos un cliente'),
      ));
    }
  }
}
