// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/* void main() {
  print(DateTime.parse('20240616'));

  print(DateFormat('dd-MM-yyyy').format(DateTime.now()));

  DateTime date = DateFormat('dd-MM-yyyy').parse('16-06-2024');
  TimeOfDay time = TimeOfDay.now();
  print(DateTime(date.year, date.month, date.day, time.hour, time.minute));
} */

TimeOfDay? timeFromString(String timeString) {
  TimeOfDay? time;
  try {
    // Parsear la cadena de tiempo en un objeto DateTime
    DateTime parsedTime = DateFormat.jm().parse(timeString);

    // Crear un objeto TimeOfDay a partir del DateTime parseado
    time = TimeOfDay.fromDateTime(parsedTime);
  } catch (e) {
    print(e);
  }

  return time;
}

void main() {
  // Ejemplo de uso
  String timeString = '6:30 PM';
  TimeOfDay timeOfDay = timeFromString(timeString)!;

  print('Hora del día: ${timeOfDay.hour}:${timeOfDay.minute}');
}
