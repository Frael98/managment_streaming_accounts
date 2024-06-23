import 'package:flutter/material.dart';

const List<int> capacidad = [1, 2, 3, 4, 5];

const colorsLinear = [
  LinearGradient(
      colors: [Color.fromARGB(255, 211, 29, 16), Color.fromARGB(255, 221, 42, 42)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter),
  LinearGradient(
      colors: [Color.fromARGB(255, 20, 88, 143), Color.fromARGB(255, 70, 154, 223)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter),
  LinearGradient(
      colors: [Colors.purple, Color.fromARGB(255, 202, 106, 231)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter),
  LinearGradient(
      colors: [Color.fromARGB(255, 46, 128, 49), Color.fromARGB(255, 103, 192, 44)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter),
];

/// Colores para los estados
const colorStates = {
  'disponible': Colors.green,
  'caida': Colors.red,
  'parcialmente disponible': Colors.blue,
  'ocupada': Colors.purple
};

enum StateAccount {
    available('disponible'),
    drop('caida'),
    //agotada('agotada'),
    partialAvailable('parcialmente disponible'),
    busy('ocupada');

    final String nombre;

    const StateAccount(this.nombre);
}