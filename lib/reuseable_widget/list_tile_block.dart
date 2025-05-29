import 'package:flutter/material.dart';

class ListTileBlock extends StatelessWidget {
  final Widget child;
  final EdgeInsets? margin;

  const ListTileBlock({super.key, required this.child, this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          // BoxShadow(
          //   color: Colors.black12,
          //   blurRadius: 6,
          //   offset: Offset(0, 3),
          // ),
        ],
      ),
      child: child,
    );
  }
}