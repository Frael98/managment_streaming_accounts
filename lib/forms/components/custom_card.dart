import 'package:f_managment_stream_accounts/utils/constantes.dart';
import 'package:flutter/material.dart';

///
class CustomCard extends StatelessWidget {
  const CustomCard({super.key, required this.cardName, this.function, this.color});
  final String cardName;
  final Function()? function;
  final LinearGradient? color;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.all(10.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          //padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            gradient: color ?? colorsLinear.first,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Center(
            child: Text(
              cardName,
              style: const TextStyle(
                color: Colors.white, // Color del texto
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
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
