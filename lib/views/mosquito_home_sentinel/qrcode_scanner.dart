import 'dart:typed_data';

import 'package:desapv3/controllers/data_controller.dart';
import 'package:desapv3/controllers/navigation_link.dart';
import 'package:desapv3/controllers/route_generator.dart';
import 'package:desapv3/models/cup.dart';
import 'package:desapv3/services/permissions_handling.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

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
  var _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataController>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Code Scanner"),
      ),
      body: Center(
        child: FutureBuilder<List<Cup>>(
          future: dataProvider.fetchCups(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error loading cups: ${snapshot.error}"),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text("No cups available."),
              );
            }

            final List<Cup> currentCupList = snapshot.data!;

            return MobileScanner(
              controller: MobileScannerController(
                  detectionSpeed: DetectionSpeed.noDuplicates,
                  returnImage: true),
              onDetect: (capture) async {
                if (_isProcessing) return;
                _isProcessing = true;

                final List<Barcode> barcodes = capture.barcodes;
                String? cupIDScanned;

                for (final barcode in barcodes) {
                  cupIDScanned = barcode.rawValue;
                  logger.d("Barcode found! ${barcode.rawValue}");
                  logger.d(cupIDScanned);
                }

                if (cupIDScanned != null) {
                  try {
                    // Locate the corresponding Cup object
                    final Cup cupToEdit = currentCupList
                        .firstWhere((cup) => cup.cupID == cupIDScanned);

                    await Navigator.pushNamed(context, editCupRoute,
                        arguments: EditCupArguments(cupToEdit));

                    _isProcessing = false;
                  } catch (e) {
                    logger.w(
                        "Cup with ID $cupIDScanned not found: ${e.toString()}");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text("Cup not found for scanned ID: $cupIDScanned"),
                      ),
                    );
                  }
                } else {
                  logger.w("No valid barcode found.");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("No barcode detected.")),
                  );
                }
                logger.d(capture);
              },
            );
          },
        ),
      ),
    );
  }
}
