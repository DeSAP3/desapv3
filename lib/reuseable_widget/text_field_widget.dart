import 'package:flutter/material.dart';

class TextFieldWidget extends StatefulWidget {
  final TextInputType? textInputType;
  final String hintText;
  final bool? obscureText;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;

  const TextFieldWidget({
    super.key,
    this.textInputType,
    required this.hintText,
    this.obscureText,
    required this.controller,
    this.validator,
  });

  @override
  State<TextFieldWidget> createState() => _LoginFieldWidgetState();
}

class _LoginFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          hintText: widget.hintText,
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 1.0)),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 1.0))),
      obscureText: widget.obscureText ?? false,
      controller: widget.controller,
      keyboardType: widget.textInputType,
    );
  }
}
