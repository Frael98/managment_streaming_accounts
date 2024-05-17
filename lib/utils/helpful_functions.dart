import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:toast/toast.dart';

/// Verifica si un objeto es nulo
bool isNull(Object? object){
  return object != null;
}

///Validacion de cualquier tipo de campo
String? messageValidator(String? formText) {
  if (formText!.isEmpty) return "Campo obligatorio";

  return null;
}

///Validacion de formato email
String? validateEmail(String? formEmail) {
  if (formEmail!.isEmpty) return "Email obligatorio";

  String patron = r'\w+@\w+\.\w+';
  RegExp regex = RegExp(patron);

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
    Function? callbackNo}) {
  showPlatformDialog(
      context: context,
      builder: (_) => BasicDialogAlert(
            title: Text(isNull(title) ? title : 'Mensaje',
                style: const TextStyle(fontSize: 20),
                textAlign: TextAlign.justify),
            actions: [
              BasicDialogAction(
                title: Text(isNull(titleActionOne) ? titleActionOne : 'Sí'),
                onPressed: () {
                  if (isNull(callbackYes)) {
                    callbackYes!(context);
                  } else {
                    showToast('Aceptado');
                  }
                  Navigator.pop(context);
                },
              ),
              BasicDialogAction(
                title: Text(isNull(titleActionTwo) ? titleActionTwo : 'No'),
                onPressed: () {
                  if (isNull(callbackNo)) {
                    callbackNo!(context);
                  }
                  Navigator.pop(context);
                },
              )
            ],
          ));
}
