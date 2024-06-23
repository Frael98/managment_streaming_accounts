//import 'package:f_managment_stream_accounts/providers/theme_provider.dart';
import 'dart:developer';
import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CustomDropDownField<T> extends StatefulWidget {
  List<T> items;

  ///Identificador del valor
  final String Function(T) valueText;

  ///Valor a mostrarse en el combo
  final String Function(T) displayText;
  TextEditingController? controller;
  String labelText;
  String hintText;

  CustomDropDownField({
    super.key,
    required this.items,
    this.hintText = '',
    this.labelText = '',
    required this.displayText,
    required this.valueText,
    this.controller,
  });

  @override
  State<CustomDropDownField<T>> createState() =>
      _CustomDropDownButtonState<T>();
}

class _CustomDropDownButtonState<T> extends State<CustomDropDownField<T>> {
  List<T> _options = [];
  late T? _selectedItem;

  @override
  void initState() {
    setState(() {
      _options = widget.items.cast<T>();
    });
    log(widget.items[0].toString());
    super.initState();
  }

  /* @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Inicializa options después de que items esté disponible
    options = widget.items.cast<T>();
    log(widget.items[0].toString());
  } */

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      //padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      value: null,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.white),
      onChanged: (T? newValue) {
        //log(newValue.toString());
        setState(() {
          _selectedItem = newValue;
          widget.controller!.text = widget.valueText(newValue as T);
          log('item Seleccionado $_selectedItem');
        });
      },
      //Asignacion de datos en el combo
      items: [
        if (widget.hintText.isNotEmpty)
          DropdownMenuItem<T>(
            value: null,
            child: Text(widget.hintText),
          ),
        ..._options.map<DropdownMenuItem<T>>((T object) {
          return DropdownMenuItem<T>(
            value: object,
            child: Text(widget.displayText(object)),
          );
        }).toList()
      ],
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        labelText: widget.labelText,
        hintText: widget.hintText,
      ),
    );
  }
}
