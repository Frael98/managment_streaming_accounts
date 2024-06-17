import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:toast/toast.dart';

/// Verifica si un objeto es nulo
bool isNull(Object? object) {
  return object != null;
}

///Validacion de cualquier tipo de campo
String? messageValidator(String? formText) {
  if (formText!.isEmpty) return "Campo obligatorio";

  return null;
}

///Validacion de formato email
String? validateEmail(String? formEmail) {
  if (formEmail == null || formEmail.isEmpty) return "Email obligatorio";

  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern);
  //String patron = r'\w+@\w+\.\w+';
  //RegExp regex = RegExp(patron);

  if (!regex.hasMatch(formEmail)) return "Email invalido";

  return null;
}

///Validacion de contraseña segura
/// alt + 126
String? validatePassword(String? formPassword) {
  if (formPassword!.isEmpty) return "Contraseña es requerida";

  String patron =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  RegExp regex = RegExp(patron);

  if (!regex.hasMatch(formPassword)) {
    return "Contraseña debe contener al menos 8 caracteres, incluidos mayusculas, minusculas, numeros y simnbolos";
  }

  return null;
}

///Muestra mensajes toast
void showToast(String message) {
  Toast.show(message, duration: Toast.lengthLong, gravity: Toast.bottom);
}

/// Muestra dialogo de confirmación
void showDialogMessage(BuildContext context,
    {title,
    titleActionOne,
    titleActionTwo,
    Function? callbackYes,
    Function? callbackNo,
    uid}) {
  //BuildContext dialogContext = context;

  showPlatformDialog(
      context: context,
      builder: (_) => BasicDialogAlert(
            title: Text(isNull(title) ? title : 'Mensaje',
                style: const TextStyle(fontSize: 20),
                textAlign: TextAlign.start),
            actions: [
              BasicDialogAction(
                title: Text(
                  isNull(titleActionTwo) ? titleActionTwo : 'No',
                  style: const TextStyle(fontSize: 22),
                ),
                onPressed: () {
                  if (isNull(callbackNo)) {
                    callbackNo!();
                  }
                  Navigator.pop(context);
                },
              ),
              BasicDialogAction(
                title: Text(
                  isNull(titleActionOne) ? titleActionOne : 'Sí',
                  style: const TextStyle(fontSize: 22),
                ),
                onPressed: () {
                  if (isNull(callbackYes)) {
                    callbackYes!();
                  } else {
                    showToast('Aceptado');
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          ));
}

String? validateInt(value) {
  if (value == null || value.isEmpty) {
    return 'Por favor ingrese un número entero.';
  }
  final isNumeric = double.tryParse(value);
  if (isNumeric == null) {
    return 'Debe ser un número válido.';
  }
  return null; // Todo está bien
}
