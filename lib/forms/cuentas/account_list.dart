import 'dart:async';
import 'dart:developer';

import 'package:f_managment_stream_accounts/controllers/mongo/account_controller_mongo.dart';
import 'package:f_managment_stream_accounts/forms/components/custom_date_picker.dart';
import 'package:f_managment_stream_accounts/forms/components/search_delegate.dart';
import 'package:f_managment_stream_accounts/forms/cuentas/account_form.dart';
import 'package:f_managment_stream_accounts/models/account.dart';
import 'package:f_managment_stream_accounts/utils/constantes.dart';
import 'package:f_managment_stream_accounts/utils/helpful_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ignore: must_be_immutable
class AccountListView extends StatefulWidget {
  bool? returnAccount;
  AccountListView({super.key, this.returnAccount});
  @override
  State<StatefulWidget> createState() {
    return AccountListViewState();
  }
}

class AccountListViewState extends State<AccountListView> {
  Future<List<Account>>? accounts;
  bool returnAccount_;
  final Map<String, bool> _expandedState = {};

  AccountListViewState({this.returnAccount_ = false});

  @override
  void initState() {
    //getAccountsAsync();
    returnAccount_ = widget.returnAccount ?? returnAccount_;
    if (returnAccount_) {
      accounts =
          AccountControllerMongo.getAccountsSinSubscriptionYDisponibles();
    } else {
      accounts = AccountControllerMongo.getAccountsList();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cuentas"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () async {
                List<Account>? accountList;
                accountList = await AccountControllerMongo.getAccountsList();
                if (returnAccount_) {
                  //log('evento del bton $returnAccount_');
                  var tmp = await showSearch(
                      // ignore: use_build_context_synchronously
                      context: context,
                      delegate: SearchFieldDelegate<Account>(
                          accountList, _getName,
                          returnData: returnAccount_, state: this));
                  //log('Cuenta from search ...');
                  //log(tmp.toString());
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context, tmp);
                } else {
                  //log(' $returnAccount_');
                  showSearch(
                      // ignore: use_build_context_synchronously
                      context: context,
                      delegate: SearchFieldDelegate<Account>(
                        accountList,
                        _getName,
                        state: this,
                      ));
                }
              },
            ),
          )
        ],
      ),
      body: FutureBuilder<List<Account>>(
        future: accounts,
        builder: _builder,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AccountFormScreen(),
            ),
          );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }

  Widget _builder(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      log(snapshot.error.toString());
      return Center(
          child:
              Text('Error al cargar las cuentas ${snapshot.error.toString()}'));
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const Center(child: Text('No se encontraron cuentas'));
    } else {
      return buildAccountList(context, snapshot.data!);
    }
  }

  /// Contruye la lista de cuentas
  Widget buildAccountList(BuildContext context_, List<Account> cuentas) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: cuentas.length,
        itemBuilder: (context, index) {
          final account = cuentas[index];
          final accountId = account.uid!.oid;

          return Slidable(
            key: Key(accountId),
            endActionPane: ActionPane(motion: const ScrollMotion(), children: [
              SlidableAction(
                onPressed: (context) {
                  //_deleteAcccount(cuentas[index].uid!, context);
                  showDialogMessage(context_, //Pasamos el context del padre
                      title: '¿Esta seguro que desea eliminar esta cuenta?',
                      callbackYes: () =>
                          _deleteAcccount(context_, cuentas[index].uid!));
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
                trailing: _buildTrailingWidget(context_, account),
                onExpansionChanged: (bool expanded) {
                  /* if (mounted) { */
                  setState(() {
                    _expandedState[accountId] = expanded;
                  });
                  /*  } */
                },
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                childrenPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                //backgroundColor: Colors.grey,
                leading: const Icon(Icons.account_circle),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      cuentas[index].email!,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isNotNull(cuentas[index].state)
                              ? colorStates[cuentas[index].state]
                              : Colors.grey),
                    ),
                    const SizedBox(width: 8.0),
                    //_accountExpiredIcon(cuentas[index].expireDate)
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .end, // Alineación del icono a la derecha
                        children: [
                          _accountExpiredIcon(cuentas[index].expireDate),
                        ],
                      ),
                    ),
                  ],
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
                            '${Format.toDateMonthLetter(cuentas[index].registerDate!)} Hora ${cuentas[index].registerDate!.toLocal().hour}:${cuentas[index].registerDate!.toLocal().minute}')
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
                            cuentas[index].expireDate!))
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
                        Text(cuentas[index].typeAccount!.nameTypeAccount!)
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
                        Text(cuentas[index].platform!.namePlatform!)
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
  void _deleteAcccount(BuildContext context, mongo.ObjectId uid) async {
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

  Widget _buildTrailingWidget(BuildContext context_, Account account) {
    // log('retorna es : $returnAccount_');
    if (returnAccount_) {
      return SizedBox(
        width: 30.0,
        child: IconButton(
          onPressed: () {
            //log('retornando objectos');
            //log(account.toString());
            //close(context_, account);
            Navigator.pop(context_, account);
          },
          icon: const Icon(Icons.add),
        ),
      );
    } else {
      //log('Ventana normal');
      // Verifica si el account.uid no es nulo y tiene un valor válido.
      if (account.uid != null) {
        final accountOid = account.uid!.oid;
        //log('Id no es nulo');
        // Inicializa _expandedState[accountOid] si no existe.
        if (!_expandedState.containsKey(accountOid)) {
          _expandedState[accountOid] = false;
          //log('seteado ${_expandedState[accountOid]}');
        }
        final isExpanded = _expandedState[accountOid] ?? false;
        //log('$isExpanded');
        return Icon(
            isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down);
      } else {
        return const Icon(Icons.error,
            color: Colors
                .red); // Muestra un icono de error si account.uid es nulo.
      }
    }
  }

  ///Obtener nombre para SearchDelegate
  String _getName(Account account) {
    return account.email!;
  }

  ///Display icon de expirado en cuentas
  Widget _accountExpiredIcon(DateTime? time) {
    if (time == null) {
      return Container();
    }
    // si la fecha actual es posterior aun ha expirado
    if (time.toLocal().isAfter(DateTime.now())) {
      var left = time.toLocal().difference(DateTime.now()).inDays;

      return Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            'A $left',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
          ));
    } else {
      // si es anterior ya ha experido
      return Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Text(
            'Expirado',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ));
    }
  }
}
