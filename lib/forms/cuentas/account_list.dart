import 'dart:async';
import 'dart:developer';

import 'package:f_managment_stream_accounts/controllers/mongo/account_controller_mongo.dart';
import 'package:f_managment_stream_accounts/forms/components/custom_date_picker.dart';
import 'package:f_managment_stream_accounts/forms/cuentas/account_form.dart';
import 'package:f_managment_stream_accounts/models/account.dart';
import 'package:f_managment_stream_accounts/utils/constantes.dart';
import 'package:f_managment_stream_accounts/utils/helpful_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AccountListView extends StatefulWidget {
  bool returnAccount;
  AccountListView({super.key, this.returnAccount = false});
  @override
  State<StatefulWidget> createState() {
    return AccountListViewState();
  }
}

class AccountListViewState extends State<AccountListView> {
  Future<List<Account>>? accounts;
  bool _isExpanded = false;

  @override
  void initState() {
    //getAccountsAsync();
    accounts = AccountControllerMongo.getAccountsList();
    accounts!.then((d) {
      log(d.first.toString());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cuentas"),
      ),
      body: FutureBuilder<List<Account>>(
        future: accounts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            log(snapshot.error.toString());
            return Center(
                child: Text(
                    'Error al cargar las cuentas ${snapshot.error.toString()}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No se encontraron cuentas'));
          } else {
            return board(context, snapshot.data!);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AccountFormScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget board(BuildContext context_, List<Account> cuentas) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: ListView.builder(
        itemCount: cuentas.length,
        itemBuilder: (context, index) {
          return Slidable(
            key: Key(cuentas[index].uid!.oid),
            endActionPane: ActionPane(motion: const ScrollMotion(), children: [
              SlidableAction(
                onPressed: (context) {
                  //deleteAcccount(cuentas[index].uid!, context);
                  showDialogMessage(context_, //Pasamos el context del padre
                      title: '¿Esta seguro que desea eliminar esta cuenta?',
                      callbackYes: () =>
                          deleteAcccount(context_, cuentas[index].uid!));
                },
                icon: Icons.delete,
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.black,
                flex: 4,
              ),
            ]),
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: ExpansionTile(
                trailing: widget.returnAccount
                    ? IconButton(
                        onPressed: () {
                          log('retornando objectos');
                          log(cuentas[index].toString());
                          Navigator.pop(context, cuentas[index]);
                        },
                        icon: const Icon(Icons.add))
                    : Icon(_isExpanded
                        ?  Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down),
                onExpansionChanged: (bool expanded) {
                  setState(() {
                    _isExpanded = expanded;
                  });
                },
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                childrenPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                //backgroundColor: Colors.grey,
                leading: const Icon(Icons.account_circle),
                title: Text(
                  cuentas[index].email,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isNull(cuentas[index].state)
                          ? colorStates[cuentas[index].state]
                          : Colors.grey),
                ),
                subtitle: Row(
                  children: [
                    const Icon(
                      Icons.event_seat_rounded,
                      size: 18,
                    ),
                    Text('${cuentas[index].perfilQuantity}'),
                    const SizedBox(
                      width: 10,
                    ),
                    const Icon(
                      Icons.attach_money,
                      size: 18,
                    ),
                    Text('${cuentas[index].price}')
                  ],
                ),
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
                            '${Format.toDateMonthLetter(cuentas[index].registerDate)} Hora ${cuentas[index].registerDate.toLocal().hour}:${cuentas[index].registerDate.toLocal().minute}')
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
                        Text(
                            Format.toDateMonthLetter(cuentas[index].expireDate))
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
                        Text(cuentas[index].timeLimit!)
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
                        Text(cuentas[index].typeAccount.nameTypeAccount!)
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
                        Text(cuentas[index].platform.namePlatform!)
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
                        Text(cuentas[index].perfilQuantity.toString())
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
                        Text('\$ ${cuentas[index].price!}')
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
                          '${cuentas[index].state}',
                          style: TextStyle(
                              color: colorStates[cuentas[index].state]),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  ///Eliminar cuenta
  ///[uid] Objectid de la cuenta
  void deleteAcccount(BuildContext context, mongo.ObjectId uid) async {
    try {
      var message = await AccountControllerMongo.deleteAccount(uid);
      showToast(message);
      setState(() {
        accounts = AccountControllerMongo.getAccountsList();
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('cuenta eliminada correctamente!')));
    } catch (e) {
      log('Error en eliminacion de cuenta $e');
    }
  }
}
