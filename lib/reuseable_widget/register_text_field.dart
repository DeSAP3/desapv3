import 'package:flutter/material.dart';

class RegisterTextField extends StatelessWidget {
  final TextInputType? textInputType;
  final String hintText;
  final String? labelText;
  final bool? obscureText;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final Icon? prefixIcon;
  final IconButton? suffixIcon;
  final dynamic value;

  const RegisterTextField(
      {super.key,
      this.textInputType,
      required this.hintText,
      this.labelText,
      this.obscureText,
      required this.controller,
      this.validator,
      this.prefixIcon,
      this.suffixIcon,
      this.value
      });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(),
      child: TextFormField(
        decoration: InputDecoration(
            filled: true,
            fillColor: const Color.fromARGB(255, 255, 255, 255),
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
            labelText: labelText,
            border: InputBorder.none,
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blue, width: 1.0),
                borderRadius: BorderRadius.circular(15)),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black, width: 1.0),
                borderRadius: BorderRadius.circular(15)),
                errorBorder:  const OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 1.0)),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon),
        obscureText: obscureText ?? false,
        controller: controller,
        keyboardType: textInputType,
      ),
    );
  }
}
