import 'dart:developer';

import 'package:f_managment_stream_accounts/controllers/mongo/platforms_controller_mongo.dart';
import 'package:f_managment_stream_accounts/forms/plataforma/platform_form.dart';
import 'package:f_managment_stream_accounts/models/platform.dart';
import 'package:flutter/material.dart';

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
            child: const Icon(Icons.add)));
  }

  ///
  Widget getBuildTilePlatform(BuildContext context, List<Platform> platforms) {
    return GridView.count(
      crossAxisCount: 2,
      children: List.generate(
        platforms.length,
        (index) {
          final platform = platforms[index];

          return _SampleCard(cardName: platform.namePlatform!, function: () => onPlatformForm(idPlatform: platform.uid, context));
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

/// probando SizeBox como Card
class _SampleCard extends StatelessWidget {
  const _SampleCard({required this.cardName, this.function});
  final String cardName;
  final Function()? function;

  @override
  Widget build(BuildContext context) {
    /* return SizedBox(
      width: 300,
      height: 100,
      child: Center(child: Text(cardName)),
    ); */

    return Card(
      child: InkWell(
        child: Center(
          child: Text(cardName),
        ),
        onTap: () {
          if (function != null) {
            function!();
          }
        },
      ),
    );
  }
}
