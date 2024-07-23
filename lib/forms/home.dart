import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:f_managment_stream_accounts/controllers/mongo/client_controller_mongo.dart';
import 'package:f_managment_stream_accounts/controllers/mongo/platforms_controller_mongo.dart';
import 'package:f_managment_stream_accounts/forms/cliente/client_form.dart';
import 'package:f_managment_stream_accounts/forms/cliente/client_list.dart';
import 'package:f_managment_stream_accounts/forms/components/custom_card.dart';
import 'package:f_managment_stream_accounts/forms/components/custom_expansion_tile.dart';
import 'package:f_managment_stream_accounts/forms/cuentas/account_list.dart';
import 'package:f_managment_stream_accounts/forms/log_in.dart';
import 'package:f_managment_stream_accounts/forms/plataforma/platform_list.dart';
import 'package:f_managment_stream_accounts/forms/subscripcion/subscription_list.dart';
import 'package:f_managment_stream_accounts/models/client.dart';
import 'package:f_managment_stream_accounts/models/platform.dart';
import 'package:f_managment_stream_accounts/utils/constantes.dart';
import 'package:f_managment_stream_accounts/utils/helpful_functions.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toast/toast.dart';

class Home extends StatefulWidget {
  final String usuario;
  final String correo;

  const Home({super.key, required this.usuario, required this.correo});

  @override
  State<Home> createState() => HomeScreen();
}

class HomeScreen extends State<Home> {
  Future<List<Client>>? _clientsStream;
  Future<List<Platform>>? _platformsStream;
  final Connectivity _connectivity = Connectivity();

  @override
  void initState() {
    super.initState();
    log('Iniciando datos');
    initData();
    checkConnection(context);
  }

  void initData() {
    initClientsData();
    initPlatformsData();
  }

  void initClientsData()async {
    /* log('Iniciando datos clientes');
     try {
        var tmp = await ClientControllerMongo.getClients();
       log(tmp.toString());
      setState(() {
        _clientsStream = Stream.value(tmp);
      });
    } catch (e) {
      log('Error cargando datos clientes: $e');

      Future.delayed(const Duration(seconds: 5), () {
        log('Reintentando...');
        initClientsData();
      });
    } */
    ClientControllerMongo.getClients().then((data) {
      setState(() {
        _clientsStream = Future.value(data);
      });
    }).catchError((error) {
      log('Error cargando datos clientes: $error');
      Future.delayed(const Duration(seconds: 5), initClientsData);
    });
  }

  void initPlatformsData() {
    /*  log('Iniciando datos plataformas');
    try {
      setState(() {
        _platformsStream = PlatformControllerMongo.getPlatforms().asStream();
      });
    } catch (e) {
      log('Error cargando datos plataformas: $e');
      //reintento despues de 5 sgundos
      await Future.delayed(const Duration(seconds: 5), () {
        log('Reintentando...');
        initPlatformsData();
      });
    } */
    log('Iniciando datos plataformas');
    PlatformControllerMongo.getPlatforms().then((data) {
      setState(() {
        _platformsStream = Future.value(data);
      });
    }).catchError((error) {
      log('Error cargando datos plataformas: $error');
      Future.delayed(const Duration(seconds: 5), initPlatformsData);
    });
  }

  checkConnection(BuildContext context) {
    _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> result) {
        log(result.first.toString());
        if (result.first == ConnectivityResult.none) {
          setState(() {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('You\'re not connected to a Internet 😞',
                  style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.red,
            ));
          });
        } else if (result.first == ConnectivityResult.mobile) {
          setState(() {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('You\'re connected to a Internet 😃',
                  style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.green,
            ));
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (ToastContext().context == null) {
      ToastContext().init(context);
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Inicio'),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(widget.usuario),
                accountEmail: Text(widget.correo),
                currentAccountPicture: const CircleAvatar(
                  backgroundImage: AssetImage('assets/ichi.jpg'), // Imagen
                ),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 17, 27, 54),
                ),
              ),
              ...menus(context)
            ],
          ),
        ),
        body: areaHome(context));
  }

  ///Area Home
  Widget areaHome(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, //
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              recents(context),
              const SizedBox(
                height: 15,
              ),
              _clientSection(context),
              _platformsSection(context)
            ],
          ),
        ),
      ),
    );
  }

  /// Sección Recientes
  Widget recents(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            'Recientes',
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 150,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: Colors.grey.withOpacity(0.2),
                    width: 2.0,
                  ),
                ),
                elevation: 8,
                //color: Colors.red,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [
                          const Color.fromARGB(255, 6, 14, 20).withOpacity(0.8),
                          const Color.fromARGB(255, 5, 32, 54).withOpacity(0.8),
                          const Color.fromARGB(255, 201, 52, 52)
                              .withOpacity(0.8)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        //stops: [0.0, 1.0],
                        //tileMode: TileMode.clamp,
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("Hola como estas"),
                    ),
                  ),
                ),
              ),
              Card(
                elevation: 8,
                color: Colors.red,
                child: InkWell(
                  child: const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("Hola como estas"),
                  ),
                  onTap: () {},
                ),
              ),
              Card(
                elevation: 8,
                color: Colors.grey.withOpacity(0.2),
                child: InkWell(
                  child: const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("Hola como estas"),
                  ),
                  onTap: () {},
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: Colors.grey.withOpacity(0.2),
                    width: 2.0,
                  ),
                ),
                elevation: 8,
                //color: Colors.transparent, // Hacemos el color del Card transparente
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {},
                  child: Container(
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(colors: [
                        Colors.white.withOpacity(0.3),
                        Colors.black.withOpacity(0.2),
                        Colors.grey.withOpacity(0.3)
                      ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(
                        child: Icon(
                          Icons.add,
                          size: 50,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  /// Seccion de clientes
  Widget _clientSection(BuildContext context) {
    //log(_clientsStream!.first.toString()); esta escuchando, y no puede ser escuchado por varios
    return FutureBuilder(
        //stream: ClientControllerMongo.getClients().asStream(),
        future: _clientsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.all(100),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            if (snapshot.hasError) {
              log('Error en stream clientSection ${snapshot.error}');
              return Center(
                child: Text('${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Padding(
                  padding: EdgeInsets.all(50),
                  child: Center(
                    child: Text('No hay datos disponibles'),
                  ));
            }
            if (snapshot.hasData) {
              List<Client>? clients = snapshot.data;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Text(
                      'Clientes',
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 150,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: clients!.length,
                        itemBuilder: (context, index) {
                          Client client = clients[index];

                          return Padding(
                            padding: const EdgeInsets.all(5),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ClientFormScreen(client.uid),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    //border: Border.all(),
                                    color: Colors.white30,
                                    borderRadius: BorderRadius.circular(20)),
                                //margin: EdgeInsets.all(5),
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      child: Text(
                                        client.nameClient!.substring(0, 1),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      client.nameClient!,
                                      style: const TextStyle(fontSize: 12),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  )
                ],
              );
            }

            return const Center();
          }
        });
  }

  /// Seccion de plataformas
  Widget _platformsSection(BuildContext conetext) {
    return FutureBuilder(
        //stream: PlatformControllerMongo.getPlatforms().asStream(),
        future: _platformsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.all(100),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            log('Error en stream clientSection ${snapshot.error}');
            return Center(
              child: Text('${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Padding(
                padding: EdgeInsets.all(50),
                child: Center(
                  child: Text('No hay datos disponibles'),
                ));
          } else {
            List<Platform>? platforms = snapshot.data;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Text(
                    'Plataformas',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: platforms!.length,
                      itemBuilder: (context, index) {
                        Platform platform = platforms[index];

                        return CustomCard(
                          cardName: platform.namePlatform!,
                          //function: () =>onPlatformForm(idPlatform: platform.uid, context),
                          color: colorsLinear[
                              math.Random().nextInt(colorsLinear.length)],
                        );
                      }),
                )
              ],
            );
          }
        });
  }

  ///Menus del home
  List<Widget> menus(BuildContext context) {
    return [
      CustomExpansionTile(title: 'Acciones', tiles: submenus(context)),
      ListTile(
        leading: const Icon(Icons.logout),
        title: const Text('Cerrar sesión'),
        onTap: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const LogIn(title: ''),
            ),
            (route) =>
                false, // Elimina todas las rutas anteriores del historial de navegación
          );
        },
      ),
    ];
  }

  /// Submenus
  List<Widget> submenus(BuildContext context) {
    return [
      ListTile(
        leading: const Icon(Icons.contact_mail),
        title: const Text('Clientes'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ClientListView(),
            ),
          );
        },
      ),
      ListTile(
        leading: const Icon(Icons.account_box_rounded),
        title: const Text('Cuentas'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AccountListView(),
            ),
          );
        },
      ),
      ListTile(
        leading: const Icon(Icons.shop_rounded),
        title: const Text('Suscripciones'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SubscriptionListView(),
            ),
          );
        },
      ),
      ListTile(
        leading: const Icon(Icons.dvr),
        title: const Text('Plataformas'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PlatformListView(),
            ),
          );
        },
      ),
    ];
  }
}
