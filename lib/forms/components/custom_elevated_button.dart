import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomElevatedButton extends StatefulWidget {
  final String title;
  final Future Function()? function;
  final MaterialColor? color;

  const CustomElevatedButton({
    super.key,
    required this.title,
    this.color,
    this.function,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CustomElevatedButtonState createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
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
        backgroundColor: WidgetStateProperty.all<Color>(widget.color ?? Colors.deepPurple),
        shape: WidgetStateProperty.all(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.only(left: 150, right: 150, top: 12, bottom: 12),
        ),
        elevation: WidgetStateProperty.all(1),
      ),
      child: loading
          ? const SpinKitWave(
              color: Colors.white,
              size: 25.0,
            )
          : FittedBox(
              child: Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
    );
  }
}
