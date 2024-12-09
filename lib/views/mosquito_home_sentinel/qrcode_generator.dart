import 'package:desapv3/models/ovitrap.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class QrcodeGenerator extends StatefulWidget {
  final String currentOvitrapID;
  const QrcodeGenerator(this.currentOvitrapID, {super.key});

  @override
  State<QrcodeGenerator> createState() => _QrcodeGeneratorState();
}

class _QrcodeGeneratorState extends State<QrcodeGenerator> {
  String? qrData;
  late String ovitrapRef;

  @override
  void initState() {
    ovitrapRef = widget.currentOvitrapID;
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
                TextField(
                  onSubmitted: (value) {
                    setState(() {
                      qrData = ovitrapRef;
                    });
                  },
                ),
                if (qrData != null) PrettyQrView.data(data: qrData!),
              ],
            ),
          ),
        ));
  }
}
