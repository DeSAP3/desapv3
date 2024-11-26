import 'package:flutter/material.dart';

class QrcodeGenerator extends StatefulWidget {
  const QrcodeGenerator({super.key});

  @override
  State<QrcodeGenerator> createState() => _QrcodeGeneratorState();
}

class _QrcodeGeneratorState extends State<QrcodeGenerator> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Generate QR Code')),
    );
  }
}
