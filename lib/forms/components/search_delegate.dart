import 'package:flutter/material.dart';

class SearchFieldDelegate<T> extends SearchDelegate<T> {
  late final List<T> data;
  late final Function(T) getData;

  SearchFieldDelegate(this.data, this.getData);

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
          close(context, T as T);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<T> datosFiltrados = data.where((d) {
      return getData(d).toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: datosFiltrados.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(getData(datosFiltrados[index])),
          onTap: () {
            close(context, datosFiltrados[index]);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Text('This is a suggestions');
  }
}
