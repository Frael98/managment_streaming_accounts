import 'dart:developer';

import 'package:f_managment_stream_accounts/controllers/mongo/account_controller_mongo.dart';
import 'package:f_managment_stream_accounts/controllers/mongo/platforms_controller_mongo.dart';
import 'package:f_managment_stream_accounts/controllers/mongo/typeaccount_controller_mongo.dart';
import 'package:f_managment_stream_accounts/forms/components/custom_date_picker.dart';
import 'package:f_managment_stream_accounts/forms/components/custom_dropdown_field.dart';
import 'package:f_managment_stream_accounts/forms/components/custom_textfield.dart';
import 'package:f_managment_stream_accounts/forms/components/custom_time_picker.dart';
import 'package:f_managment_stream_accounts/models/account.dart';
import 'package:f_managment_stream_accounts/models/platform.dart';
import 'package:f_managment_stream_accounts/models/type_account.dart';
//import 'package:f_managment_stream_accounts/providers/time_provider.dart';
import 'package:f_managment_stream_accounts/utils/constantes.dart';
import 'package:f_managment_stream_accounts/utils/helpful_functions.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
//import 'package:provider/provider.dart';

class AccountFormScreen extends StatefulWidget {
  const AccountFormScreen({super.key});

  @override
  State<AccountFormScreen> createState() => _AccountFormScreenState();
}

class _AccountFormScreenState extends State<AccountFormScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fechaInicioController = TextEditingController();
  final TextEditingController _horaInicioController = TextEditingController();
  final TextEditingController _fechaTerminaController = TextEditingController();
  final TextEditingController _tiempoCompradoController =
      TextEditingController();
  final TextEditingController _accountCapacityController =
      TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  final TextEditingController _platform = TextEditingController();
  final TextEditingController _typeAccount = TextEditingController();

  List<Platform> _plataformas = [];
  List<TypeAccount> _typesAccount = [];

  @override
  void initState() {
    getCombos();
    super.initState();
  }

  Future<void> getCombos() async {
    List<Platform> tmpPlatforms = [];
    List<TypeAccount> tmpTypeAccounts = [];
    try {
      tmpPlatforms = await PlatformControllerMongo.getPlatforms();
      tmpTypeAccounts = await TypeAccountControllerMongo.getTypeAccounts();
      log('Lista llenada ${tmpPlatforms.first.toString()}');
    } catch (e) {
      log('Error cargando combos');
    }
    setState(() {
      _plataformas = tmpPlatforms;
      _typesAccount = tmpTypeAccounts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuenta'),
      ),
      body: _plataformas.isEmpty || _typesAccount.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: formAccount(context),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_key.currentState!.validate()) {
            log('Guardando datos...');
            //log(idCliente.toString());
            registerAccount(context);
          }
        },
        child: const Icon(Icons.save),
      ),
    );
  }

  Widget formAccount(BuildContext context) {
    //final timeProvider = Provider.of<TimeProvider>(context, listen: false);
    return Form(
      key: _key,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
            child: CustomTextFormField(
              labelText: 'Email',
              controller: _emailController,
              validator: validateEmail,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
            child: CustomTextFormField(
              labelText: 'Contraseña',
              controller: _passwordController,
              validator: messageValidator,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
            child: Row(
              children: [
                Expanded(
                  child: CustomTextFormField(
                    labelText: 'Fecha Inicio',
                    controller: _fechaInicioController,
                    sufIcon: IconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();

                        DatePicker datePicker = DatePicker(
                          labelText: 'Select Date',
                          selectedDate: DateTime.now(),
                          onSelectedDate: (DateTime date) {
                            log(Format.dateShort(date));
                            _fechaInicioController.text =
                                Format.dateShort(date);
                          },
                        );
                        datePicker.selectDate(context);
                      },
                      icon: const Icon(Icons.calendar_month_rounded),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: CustomTextFormField(
                    labelText: 'Hora inicio',
                    controller: _horaInicioController,
                    sufIcon: IconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        TimePicker timePicker = TimePicker(
                          labelText: 'Select Time',
                          selectedTime: TimeOfDay.now(),
                          onSelectedTime: (TimeOfDay time) {
                            log('Hora es: ${formatTime(time, context)}');
                            _horaInicioController.text =
                                formatTime(time, context);
                          },
                        );
                        timePicker.selectTime(context);
                      },
                      icon: const Icon(Icons.calendar_month_rounded),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
            child: CustomTextFormField(
              labelText: 'Fecha Expira',
              controller: _fechaTerminaController,
              sufIcon: IconButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();

                  DatePicker datePicker = DatePicker(
                    labelText: 'Seleccione fecha',
                    selectedDate: DateTime.now(),
                    onSelectedDate: (DateTime date) {
                      //log(Format.dateShort(date));
                      _fechaTerminaController.text = Format.dateShort(date);
                      calcularTiempoComprado();
                    },
                  );
                  datePicker.selectDate(context);
                },
                icon: const Icon(Icons.calendar_month_rounded),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
            child: CustomTextFormField(
              enabled: false,
              labelText: 'Tiempo comprado',
              controller: _tiempoCompradoController,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: CustomDropDownField<Platform>(
              items: _plataformas,
              displayText: (p) => p.namePlatform!,
              valueText: (p) => p.uid!.oid, // le pasamos el uid
              hintText: 'Seleccione Plataforma',
              labelText: 'Plataforma',
              controller: _platform,
              validator: validatorCombo,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: CustomDropDownField<TypeAccount>(
              items: _typesAccount,
              displayText: (t) => t.nameTypeAccount!,
              valueText: (t) => t.uid!.oid,
              hintText: 'Seleccione tipo de cuenta',
              labelText: 'Tipo de Cuenta',
              controller: _typeAccount,
              validator: validatorCombo,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
            child: Row(
              children: [
                Expanded(
                  child: CustomDropDownField<int>(
                      items: capacidad,
                      displayText: (c) => c.toString(),
                      valueText: (c) => c.toString(),
                      hintText: 'Capacidad',
                      labelText: 'Capacidad',
                      controller: _accountCapacityController,
                      validator: validatorCombo),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: CustomTextFormField(
                    labelText: 'Costo/Precio \$',
                    controller: _priceController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    validator: validateInt,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  /// Registrar cuenta
  void registerAccount(BuildContext context) async {
    var email = _emailController.text.trim();
    var password = _passwordController.text.trim();
    var fechaInicio = _fechaInicioController.text.trim();
    var horaInicio = _horaInicioController.text.trim();
    var fechaTermina = _fechaTerminaController.text.trim();
    var tiempoComprado = _tiempoCompradoController.text.trim();
    var capacidad = _accountCapacityController.text.trim();
    var precio = _priceController.text.trim();

    DateTime fechaInicio0 = Format.dateShortString(fechaInicio);
    TimeOfDay time0 = toTimeFromFormatTime(horaInicio);

    log('$email $password $fechaInicio');
    log('$horaInicio $fechaTermina $capacidad $tiempoComprado $precio');

    log(_platform.text);
    log(_typeAccount.text);
    log(mongo.ObjectId.fromHexString(_typeAccount.text).toString());
    Account account = Account(
        email: email,
        password: password,
        registerDate: DateTime(fechaInicio0.year, fechaInicio0.month,
                fechaInicio0.day, time0.hour, time0.minute)
            .toLocal(),
        expireDate: Format.dateShortString(fechaTermina),
        platform:
            Platform.uid(uid: mongo.ObjectId.fromHexString(_platform.text)),
        typeAccount: TypeAccount.id(
            uid: mongo.ObjectId.fromHexString(_typeAccount.text)),
        perfilQuantity: int.parse(capacidad),
        price: double.parse(precio),
        timeLimit: tiempoComprado,
        state: StateAccount.available.nombre);

    log(account.toString());

    try {
      var message = await AccountControllerMongo.addAccount(account);
      if (!message.toLowerCase().contains('error')) {
        limpiarTextField();
      }
      showToast(message);
    } catch (e) {
      log('Error al registrar cuenta: $e');
    }
  }

  /// Calcular el tiempo de comprando de la cuenta
  void calcularTiempoComprado() {
    // Obtener las fechas de inicio y término
    DateTime fechaInicio = Format.dateShortString(_fechaInicioController.text);
    DateTime fechaTermina =
        Format.dateShortString(_fechaTerminaController.text);
    log(fechaInicio.toIso8601String());
    log(fechaTermina.toIso8601String());
    // Calcular la diferencia entre las fechas en días
    //int diferenciaEnDias = fechaTermina.difference(fechaInicio).inDays;
    int meses = diferenciaEnMeses(fechaInicio, fechaTermina);
    log(meses.toString());
    // Establecer el tiempo comprado en el controlador
    _tiempoCompradoController.text = '$meses ${meses > 1 ? 'MESES' : 'MES'}';
  }

  int diferenciaEnMeses(DateTime fechaInicio, DateTime fechaTermina) {
    int diferenciaEnMeses = fechaTermina.year * 12 +
        fechaTermina.month -
        (fechaInicio.year * 12 + fechaInicio.month);

    if (fechaTermina.day < fechaInicio.day) {
      diferenciaEnMeses--;
    }

    return diferenciaEnMeses;
  }

  void limpiarTextField() {
    log('Limpiando texts fields ...');
    _emailController.clear();
    _passwordController.clear();
    _fechaInicioController.clear();
    _horaInicioController.clear();
    _fechaTerminaController.clear();
    _tiempoCompradoController.clear();
    _accountCapacityController.clear();
    _priceController.clear();
  }
}
