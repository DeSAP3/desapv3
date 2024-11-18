import 'package:flutter/material.dart';

class InputThemes extends StatelessWidget {
  // final Color? color;
  // final double? size;

  // const InputThemes({super.key, this.color, this.size});

  TextStyle _textStyle(Color color, double size) {
    return TextStyle(
      color: color,
      fontSize: size,
    );
  }

  OutlineInputBorder _outlineBorder(Color color) {
    return OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        borderSide: BorderSide(color: color, width: 1.0));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
