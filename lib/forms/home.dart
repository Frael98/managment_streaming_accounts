import 'dart:developer';
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:f_managment_stream_accounts/controllers/mongo/client_controller_mongo.dart';
import 'package:f_managment_stream_accounts/controllers/mongo/platforms_controller_mongo.dart';
import 'package:f_managment_stream_accounts/forms/components/custom_expansion_tile.dart';
import 'package:f_managment_stream_accounts/models/client.dart';
import 'package:f_managment_stream_accounts/models/platform.dart';
import 'package:f_managment_stream_accounts/router/rutas.dart';
import 'package:f_managment_stream_accounts/shared_preferences/preferences.dart';
import 'package:f_managment_stream_accounts/utils/constantes.dart';
import 'package:f_managment_stream_accounts/utils/helpful_functions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;
import 'package:mongo_dart/mongo_dart.dart' as mongo;

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
  mongo.ObjectId? _userImagenId;
  Uint8List? _userImagen;
  Future<List<Client>>? _clients;
  Future<List<Platform>>? _platformsStream;
  final Connectivity _connectivity = Connectivity();

  List<Menu> recientes = [];

  @override
  void initState() {
    super.initState();
    log('Iniciando datos');
    _initData();
    _checkConnection(context);
  }

  void _initData() {
    _getUserImagen();
    _initClientsData();
    _initPlatformsData();
  }

  void _initClientsData() async {
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
        _clients = Future.value(data);
      });
    }).catchError((error) {
      log('Error cargando datos clientes: $error');
      Future.delayed(const Duration(seconds: 5), _initClientsData);
    });
  }

  void _initPlatformsData() {
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
      Future.delayed(const Duration(seconds: 5), _initPlatformsData);
    });
  }

  void _getUserImagen() async {
    var imagenIdString = MySharedPreferences.getSharedData('imagen');
    if (imagenIdString.isEmpty) {
      log('No hay imagen');
    } else {
      setState(() {
        _userImagenId = mongo.ObjectId.fromHexString(imagenIdString);
      });
      _userImagen = await _getImageClient(_userImagenId);
    }
  }

  ///Chequeo de conexion a internet
  _checkConnection(BuildContext context) {
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
          title: const Text('Home'),
          centerTitle: true,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(widget.usuario),
                accountEmail: Text(widget.correo),
                currentAccountPicture: isNotNull(_userImagen)
                    ? CircleAvatar(
                        backgroundImage: MemoryImage(_userImagen!), // Imagen
                      )
                    : const CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/ichi.jpg'), // Imagen
                      ),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 17, 27, 54),
                ),
              ),
              ..._menus(context)
            ],
          ),
        ),
        body: _areaHome(context));
  }

  ///Area Home
  Widget _areaHome(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, //
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _recents(context),
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
  Widget _recents(BuildContext context) {
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
        (recientes.isEmpty)
            ? SizedBox(
                height: 100,
                width: 100,
                child: Card(
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
                        gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.3),
                              Colors.black.withOpacity(0.2),
                              Colors.grey.withOpacity(0.3)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight),
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
              )
            : SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: recientes.length,
                  itemBuilder: (context, index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: Colors.grey.withOpacity(0.2),
                          width: 2.0,
                        ),
                      ),
                      color: Colors.grey.withOpacity(0.2),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Center(
                            child: Text(recientes[index].nombre),
                          ),
                        ),
                        onTap: () {
                          context.goNamed(recientes[index].ruta);
                        },
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }

  /// Seccion de clientes
  Widget _clientSection(BuildContext context) {
    //log(_clientsStream!.first.toString()); esta escuchando, y no puede ser escuchado por varios
    return FutureBuilder(
        //stream: ClientControllerMongo.getClients().asStream(),
        future: _clients,
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
                                context.pushNamed('form-clientes',
                                    queryParameters: {
                                      'uid': client.uid!.oid
                                    }).then((n) {
                                  setState(() {
                                    _initData();
                                  });
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  //border: Border.all(),
                                  //color: Colors.white30.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: Colors.grey.withOpacity(0.2)),
                                ),
                                //margin: EdgeInsets.all(5),
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    isNotNull(client.imagen)
                                        ? FutureBuilder(
                                            future:
                                                _getImageClient(client.imagen),
                                            builder: _builderImage)
                                        : CircleAvatar(
                                            radius: 30,
                                            child: Text(
                                              client.nameClient!
                                                  .substring(0, 1),
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
          log('Error en stream _platformsSection ${snapshot.error}');
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
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Text(
                  'Plataformas',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 80,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: platforms!.length,
                    itemBuilder: (context, index) {
                      Platform platform = platforms[index];

                      return Container(
                        padding: const EdgeInsets.all(4),
                        width: 80,
                        //height: 60, // Define un ancho para el contenedor
                        margin: const EdgeInsets.symmetric(
                            horizontal: 4), // Espaciado horizontal
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10),
                          gradient: colorsLinear[math.Random().nextInt(colorsLinear.length)]
                        ),
                        child: Center(
                          child: Text(platform.namePlatform!, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700),),
                        ),
                      );
                    }),
              )
            ],
          );
        }
      },
    );
  }

  ///Menus del home
  List<Widget> _menus(BuildContext context) {
    return [
      CustomExpansionTile(title: 'Acciones', tiles: _submenus(context)),
      ListTile(
        leading: const Icon(Icons.logout),
        title: const Text(Menu.LOG_OUT),
        onTap: () {
          if (MySharedPreferences.getIsLogged()) {
            MySharedPreferences.setIsLogged(false);
            MySharedPreferences.prefs.remove('usuario');
            MySharedPreferences.prefs.remove('correo');
          }
          context.goNamed(RutasNombres.login.name);
        },
      ),
    ];
  }

  /// Submenus
  List<Widget> _submenus(BuildContext context) {
    return [
      ListTile(
        leading: const Icon(Icons.contact_mail),
        title: const Text(Menu.CLIENTS),
        onTap: () {
          //context.goNamed(RutasNombres.clientes.name);
          //Direcciona a lista de clientes y recargamos los datos
          context.pushNamed(RutasNombres.clientes.name).then((n) {
            setState(() {
              _initData();
            });
            recientes.add(Menu(Menu.CLIENTS, RutasNombres.clientes.name));
          });
        },
      ),
      ListTile(
        leading: const Icon(Icons.account_box_rounded),
        title: const Text(Menu.ACCOUNTS),
        onTap: () {
          context.goNamed(RutasNombres.cuentas.name);
          recientes.add(Menu(Menu.ACCOUNTS, RutasNombres.cuentas.name));
        },
      ),
      ListTile(
        leading: const Icon(Icons.shop_rounded),
        title: const Text(Menu.SUBSCRIPTIONS),
        onTap: () {
          context.goNamed(RutasNombres.susbscripcion.name);
          recientes
              .add(Menu(Menu.SUBSCRIPTIONS, RutasNombres.susbscripcion.name));
        },
      ),
      ListTile(
        leading: const Icon(Icons.dvr),
        title: const Text(Menu.PLATFORMS),
        onTap: () {
          context.goNamed(RutasNombres.platformas.name);
          recientes.add(Menu(Menu.PLATFORMS, RutasNombres.platformas.name));
        },
      ),
    ];
  }

  /// Obtener imagen de cliente
  Future<Uint8List> _getImageClient(mongo.ObjectId? idImage) async {
    Uint8List? imgList = await ClientControllerMongo.getClientImage(idImage!);
    return imgList!;
  }

  /// Construir imagen de cliente
  Widget _builderImage(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const CircularProgressIndicator();
    } else {
      Uint8List imageData = snapshot.data as Uint8List;
      // Convert Uint8List to MemoryImage
      ImageProvider<Object> imageProvider = MemoryImage(imageData);

      return CircleAvatar(
        radius: 30,
        backgroundImage: imageProvider,
      );
    }
  }
}
