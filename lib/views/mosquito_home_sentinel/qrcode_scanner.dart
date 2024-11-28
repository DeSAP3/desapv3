import 'dart:typed_data';

import 'package:desapv3/services/permissions_handling.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class QrcodeScanner extends StatefulWidget {
  const QrcodeScanner({super.key});

  @override
  State<QrcodeScanner> createState() => _QrcodeScannerState();
}

class _QrcodeScannerState extends State<QrcodeScanner> {
  @override
  void initState() {
    super.initState();
    requestPermission(permission: Permission.camera);
  }

  final logger = Logger();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Why"),
      ),
      body: Center(
        child: MobileScanner(
          controller: MobileScannerController(
              detectionSpeed: DetectionSpeed.noDuplicates, returnImage: true),
          onDetect: (capture) {
            final List<Barcode> barcodes = capture.barcodes;
            final Uint8List? image = capture.image;

            for (final barcode in barcodes) {
              logger.d("Barcode found! ${barcode.rawValue}");
            }

            if (image != null) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(barcodes.first.rawValue ?? ""),
                      content: Image(image: MemoryImage(image)),
                    );
                  });
            }
            logger.d(capture);
          },
        ),
      ),
    );
  }
}
