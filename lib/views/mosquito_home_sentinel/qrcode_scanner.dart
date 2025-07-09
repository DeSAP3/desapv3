import 'package:desapv3/viewmodels/cup_viewmodel.dart';
import 'package:desapv3/viewmodels/ovitrap_viewmodel.dart';
import 'package:desapv3/viewmodels/navigation_link.dart';
import 'package:desapv3/viewmodels/route_generator.dart';
import 'package:desapv3/models/cup.dart';
import 'package:desapv3/reuseable_widget/app_drawer.dart';
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
    PermissionsHandler phandler; //Fix this to ensure the camera is enabled
  }

  final logger = Logger();
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final cupProvider = Provider.of<CupViewModel>(context, listen: false);

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text("QR Scanner"),
      ),
      body: Center(
        child: FutureBuilder<List<Cup>>(
          future: cupProvider.fetchCups(),
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

            final List<Cup> cupList = snapshot.data!;

            return MobileScanner(
              controller: MobileScannerController(
                  detectionSpeed: DetectionSpeed.noDuplicates,
                  returnImage: true),
              onDetect: (capture) async {
                if (_isProcessing) return;
                _isProcessing = true; //Prevent page looping

                final List<Barcode> barcodes = capture.barcodes;
                String? oviTrapIDScanned;

                for (final barcode in barcodes) {
                  oviTrapIDScanned = barcode.rawValue;
                  logger.d(oviTrapIDScanned);
                }

                if (oviTrapIDScanned != null) {
                  try {
                    Cup? cupToEdit = cupList.firstWhere(
                        (cup) =>
                            (cup.ovitrapID == oviTrapIDScanned) &&
                            cup.isActive,
                        orElse: () => Cup(
                            null, null, null, null, null, null, false, null));
                    //Trying to fiter out the cupList associated to Ovitrap, then Navigator.pushReplacementNamed(context, sentinelInfoRoute, arguments: oviTrapIDScanned)

                    if (cupToEdit.cupID != null) {
                      await Navigator.pushNamed(context, editCupRoute,
                          arguments: EditCupArguments(cupToEdit));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                              "Current active Cup not found, edit now?"),
                          action: SnackBarAction(
                              label: 'Edit',
                              onPressed: () {
                                Navigator.pushNamed(context, sentinelInfoRoute,
                                    arguments: oviTrapIDScanned!);
                              }),
                        ),
                      );
                    }

                    _isProcessing = false;
                  } catch (e) {
                    logger.w(
                        "Ovitrap with ID $oviTrapIDScanned not found: ${e.toString()}");
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "Ovitrap not found for scanned ID: $oviTrapIDScanned"),
                        ),
                      );
                    }
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
