import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class QrcodeGenerator extends StatefulWidget {
  final String currOvitrapID;
  const QrcodeGenerator(this.currOvitrapID, {super.key});

  @override
  State<QrcodeGenerator> createState() => _QrcodeGeneratorState();
}

class _QrcodeGeneratorState extends State<QrcodeGenerator> {
  String? qrData;
  late String cupRef;

  @override
  void initState() {
    qrData = widget.currOvitrapID;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('QR Code for $qrData')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (qrData != null) PrettyQrView.data(data: qrData!),
              ],
            )
          ),
        ));
  }
}
