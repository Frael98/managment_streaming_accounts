// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomElevatedButton extends StatefulWidget {
  final String? title;
  final Future Function()? function;
  final MaterialColor? color;
  final bool isIcon;

  const CustomElevatedButton({
    super.key,
    this.title,
    this.color,
    this.function,
    this.isIcon = false,
  });

  @override
  _CustomElevatedButtonState createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: () async {
          setState(() {
            loading = true;
          });
          if (widget.function != null) {
            await widget.function!();
          }
          setState(() {
            loading = false;
          });
        },
        style: ButtonStyle(
          backgroundColor:
              WidgetStateProperty.all<Color>(widget.color ?? Colors.deepPurple),
          shape: WidgetStateProperty.all(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
          elevation: WidgetStateProperty.all(1),
        ),
        child: loading
            ? const SpinKitWave(
                color: Colors.white,
                size: 25.0,
              )
            : SizedBox(
                //width: double.infinity, // Ajusta el ancho al máximo disponible
                child: Center(
                  child: widget.isIcon
                      ? const Icon(
                           Icons.delete
                          
                        )
                      : Text(
                          widget.title ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
      ),
    );
  }
}