import 'package:flutter/material.dart';

class AppInputTheme {
  // final Color? color;
  // final double? size;

  // const InputThemes({super.key, this.color, this.size});

  TextStyle _buildTextStyle(Color color, {double size = 16.0}) {
    return TextStyle(
      color: color,
      fontSize: size,
    );
  }

  OutlineInputBorder _buildOutlineBorder(Color color) {
    return OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        borderSide: BorderSide(color: color, width: 1.0));
  }

  InputDecorationTheme theme() => InputDecorationTheme(
      contentPadding: const EdgeInsets.all(16),
      isDense: true, //only works if you don't have padding
      floatingLabelBehavior: FloatingLabelBehavior.always,
      // constraints: const BoxConstraints(maxWidth: 150), //Better wrap the text with flexible instead of this
      enabledBorder: _buildOutlineBorder(Colors.grey[600]!),
      errorBorder: _buildOutlineBorder(Colors.red),
      focusedErrorBorder: _buildOutlineBorder(Colors.redAccent),
      border:
          _buildOutlineBorder(Colors.yellow), //default value if border are null
      focusedBorder: _buildOutlineBorder(Colors.blue),
      disabledBorder: _buildOutlineBorder(Colors.grey[400]!),
      suffixStyle: _buildTextStyle(Colors.black),
      counterStyle: _buildTextStyle(Colors.grey, size: 12.0),
      floatingLabelStyle: _buildTextStyle(Colors.black),
      //Make error and helper the same size, so the field doesn't grow in height
      //when there is an error text
      errorStyle: _buildTextStyle(Colors.red, size: 12.0),
      helperStyle: _buildTextStyle(Colors.black, size: 12.0),
      hintStyle: _buildTextStyle(Colors.grey),
      labelStyle: _buildTextStyle(Colors.black),
      prefixStyle: _buildTextStyle(Colors.black));
}
