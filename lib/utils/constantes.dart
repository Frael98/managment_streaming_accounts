// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

const List<int> capacidad = [1, 2, 3, 4, 5];

const colorsLinear = [
  LinearGradient(
      colors: [Color(0xFFBEC5FC), Color(0xFFE0C3FC)],
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
      transform: GradientRotation(62.0)),
  LinearGradient(
      colors: [Color(0xFF85FFBD), Color(0xFFFFFB70)],
      begin: Alignment.bottomLeft,
      end: Alignment.topRight),
  /* LinearGradient(
      colors: [Colors.purple, Color.fromARGB(255, 202, 106, 231)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter), */
  LinearGradient(
      colors: [Color(0xFFFBAB7E), Color(0xFFF7CE68)],
      begin: Alignment.bottomLeft,
      end: Alignment.topRight),
  LinearGradient(
      colors: [Color(0xFF8BC6EC), Color(0xFF9599E2)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter),
  LinearGradient(
      colors: [Color(0xFFF4D03D), Color(0xFF16A085)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight),
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

class Menu {
  static const String LOG_OUT = 'Cerrar Sesión';
  static const String CLIENTS = 'Clientes';
  static const String ACCOUNTS = 'Cuentas';
  static const String SUBSCRIPTIONS = 'Subscripciones';
  static const String PLATFORMS = 'Plataformas';

  final String nombre;
  final String ruta;

  Menu(this.nombre, this.ruta);
}
