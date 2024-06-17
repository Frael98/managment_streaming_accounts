import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final bool obscureText;
  final TextEditingController? controller;
  final Widget? preIcon;
  final Widget? sufIcon;
  final String? Function(String?)? validator;
  final bool autofocus;
  final int minLine;
  final int maxLine;
  final bool enabled;
  final TextInputType? keyboardType;

  const CustomTextFormField(
      {super.key,
      required this.labelText,
      this.hintText,
      required this.controller,
      this.obscureText = false,
      this.preIcon,
      this.sufIcon,
      this.validator,
      this.maxLine = 1,
      this.minLine = 1,
      this.autofocus = false,
      this.enabled = true,
      this.keyboardType });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        enabled: enabled,
        keyboardType: keyboardType,
        minLines: minLine,
        maxLines: maxLine,
        controller: controller,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(16.0), // R
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          labelText: labelText,
          hintText: hintText,
          prefixIcon: preIcon,
          suffixIcon: sufIcon,
        ),
        autofocus: autofocus,
        obscureText: obscureText,
        validator: validator);
  }
}
