// ignore_for_file: overridden_fields

import 'dart:developer';

import 'package:f_managment_stream_accounts/forms/cliente/client_list.dart';
import 'package:f_managment_stream_accounts/forms/cuentas/account_list.dart';
import 'package:f_managment_stream_accounts/models/account.dart';
import 'package:f_managment_stream_accounts/models/client.dart';
import 'package:flutter/material.dart';

class SearchFieldDelegate<T> extends SearchDelegate<T> {
  /// Lista de datos a buscar
  late final List<T> data;

  /// Lista de datos filtrados
  List<T> filterData = [];

  /// Funcion para obtener el tipo de valor a filtrar
  late final Function(T) getData;

  /// historial para sugerencias - no implementado
  //List<T> historial;

  @override
  final String searchFieldLabel = 'Buscar...';

  bool returnData;

  final AccountListViewState? state;

  SearchFieldDelegate(this.data, this.getData,
      {this.returnData = false, this.state}); //, this.historial);

  ///Acciones
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: IconButton(
            onPressed: () {
              query = "";
            },
            icon: const Icon(Icons.clear)),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.of(context).pop(null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    filterData = data.where((d) {
      return getData(d).toLowerCase().contains(query.toLowerCase().trim());
    }).toList();
    return SearchResultsWidget<T>(
      data: this.filterData,
      returnData_: returnData,
      state: state!,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return SearchResultsWidget<T>(
      data: this.filterData,
      returnData_: returnData,
      state: state!,
    );
  }
}

class SearchResultsWidget<T> extends StatelessWidget {
  final List<T> data;
  final bool returnData_;

  final AccountListViewState state; // temporal
  const SearchResultsWidget(
      {super.key, required this.data, this.returnData_ = false, required this.state});

  @override
  Widget build(BuildContext context) {
    if (data is List<Client>) {
      return ClientListViewState.buildClientTile(context, data as List<Client>);
    }

    if (data is List<Account>) {
      return state.buildAccountList(context, data as List<Account>);
    }

    return const Center(
      child: Card(
        elevation: 5,
        margin: EdgeInsets.all(5),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Text("No hay datos"),
        ),
      ),
    );
  }
}
