// ignore_for_file: overridden_fields
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

  /// metodo general para resolver el widget de resultado de busqueda
  final Widget Function(BuildContext, List<T>) buildResultsWidget;

  SearchFieldDelegate(this.data, this.getData,
      {this.returnData = false, required this.buildResultsWidget}); //, this.historial);

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
      buildResultsWidget: buildResultsWidget,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return SearchResultsWidget<T>(
      data: this.filterData,
      returnData_: returnData,
      buildResultsWidget: buildResultsWidget,
    );
  }
}

class SearchResultsWidget<T> extends StatelessWidget {
  final List<T> data;
  final bool returnData_;

  //final StatefulWidget state; // temporal
  final Widget Function(BuildContext, List<T>) buildResultsWidget;

  const SearchResultsWidget(
      {super.key, required this.data, this.returnData_ = false, required this.buildResultsWidget});

  @override
  Widget build(BuildContext context) {
    /* if (data is List<Client>) {
      return ClientListViewState.buildClientTile(context, data as List<Client>);
    }

    if ( state is AccountListViewState && data is List<Account>) {
      AccountListViewState newState = AccountListViewState(state);
      return state.buildAccountList(context, data as List<Account>);
    } */

   if(data.isNotEmpty){
    return buildResultsWidget(context, data);
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
