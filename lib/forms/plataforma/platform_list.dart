import 'dart:developer';

import 'package:f_managment_stream_accounts/controllers/mongo/platforms_controller_mongo.dart';
import 'package:f_managment_stream_accounts/forms/components/custom_card.dart';
import 'package:f_managment_stream_accounts/forms/plataforma/platform_form.dart';
import 'package:f_managment_stream_accounts/models/platform.dart';
import 'package:f_managment_stream_accounts/utils/constantes.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class PlatformListView extends StatefulWidget {
  const PlatformListView({super.key});

  @override
  State<StatefulWidget> createState() => _PlatformListViewState();
}

class _PlatformListViewState extends State<PlatformListView> {
  List<Platform>? platforms = [];

  @override
  void initState() {
    initializePlatforms();
    super.initState();
  }

  Future initializePlatforms() async {
    try {
      var plataformasCargadas = await PlatformControllerMongo.getPlatforms();
      setState(() {
        platforms = plataformasCargadas;
      });
      log("plataformas cargadas");
    } catch (e) {
      log("Error inicializando plataformas $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Plataformas"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          )
        ],
      ),
      body: /* GridView.count(
          crossAxisCount: 2,
        ) */
          platforms!.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : getBuildTilePlatform(context, platforms!),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlatformFormScreen(),
              ),
            );
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.add)),
    );
  }

  ///
  Widget getBuildTilePlatform(BuildContext context, List<Platform> platforms) {
    return GridView.count(
      padding: const EdgeInsets.only(bottom: 80),
      crossAxisCount: 2,
      children: List.generate(
        platforms.length,
        (index) {
          final platform = platforms[index];

          return CustomCard(
            cardName: platform.namePlatform!,
            function: () => onPlatformForm(idPlatform: platform.uid, context),
            color: colorsLinear[math.Random().nextInt(colorsLinear.length)],
          );
        },
      ),
    );
  }

  /// Abrir el formulario para actualizar o agregar cliente
  static void onPlatformForm(BuildContext context, {dynamic idPlatform}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlatformFormScreen(
          idPlatform: idPlatform,
        ),
      ),
    );
  }
} // End class
