import 'package:desapv3/controllers/dengue_case_controller.dart';
import 'package:desapv3/controllers/user_controller.dart';
import 'package:desapv3/models/dengue_case.dart';
import 'package:desapv3/reuseable_widget/dengue_case_card.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class DengueCaseDetail extends StatefulWidget {
  const DengueCaseDetail(this.dc, {super.key});
  final DengueCase dc;

  @override
  State<DengueCaseDetail> createState() => _DengueCaseDetailState();
}

class _DengueCaseDetailState extends State<DengueCaseDetail> {
  final logger = Logger();
  late DengueCase currentDengueCase;

  @override
  initState() {
    super.initState();
    currentDengueCase = widget.dc;
    logger.d(currentDengueCase);
  }

  @override
  Widget build(BuildContext context) {
    final dengueCaseProvider =
        Provider.of<DengueCaseController>(context, listen: false);
    final currentUser = Provider.of<UserController>(context, listen: false).user;
    logger.d(currentUser?.role);

    DateTime dateRPDate = DateTime.fromMillisecondsSinceEpoch(
        currentDengueCase.dateRPD!.millisecondsSinceEpoch);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Dengue Case Detail'),
        ),
        body: Column(
          children: [
            SingleChildScrollView(
              child: DengueCaseCard(
                  dCaseID: currentDengueCase.dCaseID!,
                  patientName: currentDengueCase.patientName!,
                  patientAge: currentDengueCase.patientAge!,
                  dateRPD: dateRPDate,
                  officerName: currentDengueCase.officerName!,
                  status: currentDengueCase.status!),
            ),
            const SizedBox(height: 10),
            
            if (currentDengueCase.status == 'Pending' && currentUser?.role == 1)
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, 
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // background color
                        foregroundColor: Colors.white, // text (and icon) color
                      ),
                      onPressed: () {
                        dengueCaseProvider.updateCaseStatus(
                            currentDengueCase, "Reject");
                            Navigator.pop(context, true);
                      },
                      child: const Text("Reject")),
                  const SizedBox(width: 20),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[800], // background color
                        foregroundColor: Colors.white, // text (and icon) color
                      ),
                      onPressed: () {
                        dengueCaseProvider.updateCaseStatus(
                            currentDengueCase, "Approved");
                            Navigator.pop(context, true);
                      },
                      child: const Text("Approve"))
                ],
              ),
          ],
        ));
  }
}
