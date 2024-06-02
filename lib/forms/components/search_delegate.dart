// ignore_for_file: overridden_fields

import 'package:f_managment_stream_accounts/forms/cliente/client_list.dart';
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

  SearchFieldDelegate(this.data, this.getData );//, this.historial);

  ///Acciones
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, data.first);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return SearchResultsWidget<T>(data: this.filterData);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    filterData = data.where((d) {
      return getData(d).toLowerCase().contains(query.toLowerCase().trim());
    }).toList();
    return SearchResultsWidget<T>(data: filterData);
  }
}

class SearchResultsWidget<T> extends StatelessWidget {
  final List<T> data;

  const SearchResultsWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data is List<Client>) {
      return ClientListViewState.buildClientTile(context, data as List<Client>);
    }
    /* final filteredData = data.where((d) {
      return getData(d).toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: filteredData.length,
      itemBuilder: (context, index) {
        final result = filteredData[index];
        return ListTile(
          title: Text(getData(result)),
          onTap: () => onTap(result),
        );
      },
    ); */
    return const Text("No hay datos");
  }
}
