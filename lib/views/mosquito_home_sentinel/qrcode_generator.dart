import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class QrcodeGenerator extends StatefulWidget {
  final String currentCupID;
  final int index;
  const QrcodeGenerator(this.currentCupID, this.index,{super.key});

  @override
  State<QrcodeGenerator> createState() => _QrcodeGeneratorState();
}

class _QrcodeGeneratorState extends State<QrcodeGenerator> {
  String? qrData;
  late String cupRef;

  @override
  void initState() {
    qrData = widget.currentCupID;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Generate QR Code')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // TextField(
                //   onSubmitted: (value) {
                //     setState(() {
                //       qrData = cupRef;
                //     });
                //   },
                // ),
                if (qrData != null) PrettyQrView.data(data: qrData!),
              ],
            ),
          ),
        ));
  }
}
