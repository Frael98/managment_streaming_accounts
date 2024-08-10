import 'package:f_managment_stream_accounts/forms/cliente/client_form.dart';
import 'package:f_managment_stream_accounts/forms/cliente/client_list.dart';
import 'package:f_managment_stream_accounts/forms/cuentas/account_form.dart';
import 'package:f_managment_stream_accounts/forms/cuentas/account_list.dart';
import 'package:f_managment_stream_accounts/forms/home.dart';
import 'package:f_managment_stream_accounts/forms/log_in.dart';
import 'package:f_managment_stream_accounts/forms/plataforma/platform_form.dart';
import 'package:f_managment_stream_accounts/forms/plataforma/platform_list.dart';
import 'package:f_managment_stream_accounts/forms/sign_up.dart';
import 'package:f_managment_stream_accounts/forms/subscripcion/subscription_form.dart';
import 'package:f_managment_stream_accounts/forms/subscripcion/subscription_list.dart';
import 'package:f_managment_stream_accounts/router/rutas.dart';
import 'package:f_managment_stream_accounts/shared_preferences/preferences.dart';
import 'package:f_managment_stream_accounts/utils/helpful_functions.dart';
import 'package:go_router/go_router.dart';
import 'package:mongo_dart/mongo_dart.dart';

final routes = <RouteBase>[
  GoRoute(
      path: RutasNombres.login.path,
      name: RutasNombres.login.name,
      builder: (context, state) => const LogIn(),
      routes: [
        GoRoute(
            path: RutasNombres.signUp.path,
            name: RutasNombres.signUp.name,
            builder: (context, state) => const SignUpScreen())
      ]),
  GoRoute(
      path: RutasNombres.inicio.path,
      name: RutasNombres.inicio.name,
      builder: (context, state) {
        var user = MySharedPreferences.prefs.getString('usuario');
        var correo = MySharedPreferences.prefs.getString('correo');
        return Home(
          usuario: state.uri.queryParameters['usuario'] ?? user!,
          correo: state.uri.queryParameters['correo'] ?? correo!,
        );
      },
      routes: [
        GoRoute(
            path: RutasNombres.cuentas.path,
            name: RutasNombres.cuentas.name,
            builder: (context, state) {
              var returnAccount =
                  state.uri.queryParameters['returnAccount'] == 'true';
              return AccountListView(
                returnAccount: returnAccount,
              );
            },
            routes: [
              GoRoute(
                  path: 'form-cuentas',
                  builder: (context, state) => const AccountFormScreen())
            ]),
        GoRoute(
            path: RutasNombres.clientes.path,
            name: RutasNombres.clientes.name,
            builder: (context, state) {
              var returnClient =
                  state.uri.queryParameters['returnClient'] ?? 'false';
              return ClientListView(
                returnClient: bool.parse(returnClient),
              );
            },
            routes: [
              GoRoute(
                  path: 'form-clientes',
                  name: 'form-clientes',
                  builder: (context, state) => ClientFormScreen(0))
            ]),
        GoRoute(
            path: RutasNombres.platformas.path,
            name: RutasNombres.platformas.name,
            builder: (context, state) => const PlatformListView(),
            routes: [
              GoRoute(
                  path: 'form-plataformas',
                  name: 'form-plataformas',
                  builder: (context, state) {
                    final idPlatform =
                        state.uri.queryParameters['idPlatform'] ?? 'false';
                    return PlatformFormScreen(
                      idPlatform: idPlatform,
                    );
                  })
            ]),
        GoRoute(
            path: RutasNombres.susbscripcion.path,
            name: RutasNombres.susbscripcion.name,
            builder: (context, state) => const SubscriptionListView(),
            routes: [
              GoRoute(
                  path: 'form-subscripcion',
                  name: 'form-subscripcion',
                  builder: (context, state) {
                    final idSubscription =
                        isNotNull(state.uri.queryParameters['idSubscription'])
                            ? ObjectId.parse(
                                state.uri.queryParameters['idSubscription']!)
                            : null;
                    return SubscriptionFormScreen(
                      idSubscription: idSubscription,
                    );
                  })
            ]),
      ]),
];

/* if(MySharedPreferences.getIsLogged()){
  
} */

final enrutador = GoRouter(routes: routes, initialLocation: '/');
