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