import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:desapv3/viewmodels/dengue_case_viewmodel.dart';
import 'package:desapv3/models/dengue_case.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class EditDengueCase extends StatefulWidget {
  final DengueCase data;
  final int index;
  const EditDengueCase(this.data, this.index, {super.key});

  @override
  State<EditDengueCase> createState() => _EditDengueCaseState();
}

class _EditDengueCaseState extends State<EditDengueCase> {
  final formKey = GlobalKey<FormState>();

  final logger = Logger();

  late final _patientName =
      TextEditingController(text: currentDengueCase.patientName);
  late final _patientAge =
      TextEditingController(text: currentDengueCase.patientAge.toString());
  late final _address = TextEditingController(text: currentDengueCase.address);
  late final _infectedCoordsX =
      TextEditingController(text: currentDengueCase.infectedCoordsX.toString());
  late final _infectedCoordsY =
      TextEditingController(text: currentDengueCase.infectedCoordsY.toString());
  late final _officerName =
      TextEditingController(text: currentDengueCase.officerName);

  late DateTime _dateRPDate;

  late final Timestamp _dateRPD = Timestamp.fromDate(_dateRPDate);

  late String? selectedStatus = currentDengueCase.status;
  final List<String> statusOptions = ['Pending', 'Accepted', 'Declined'];

  late DengueCase currentDengueCase;

  @override
  void initState() {
    super.initState();
    currentDengueCase = widget.data;
    logger.d(currentDengueCase);
  }

  @override
  Widget build(BuildContext context) {
    final dengueCaseProvider =
        Provider.of<DengueCaseViewModel>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Add An Ovitrap'),
        ),
        body: Form(
          key: formKey,
          child: Center(
              child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _patientName,
                  decoration: const InputDecoration(hintText: "Patient Name"),
                ),
              ),
              const SizedBox(height: 10),
              Row(children: [
                Flexible(
                  child: TextFormField(
                    controller: _patientAge,
                    decoration: const InputDecoration(hintText: "Patient Age"),
                  ),
                ),
                Flexible(
                    child: DropdownButtonFormField<String>(
                        value: selectedStatus,
                        decoration: const InputDecoration(hintText: "Status"),
                        items: statusOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedStatus = newValue;
                          });
                        })),
              ]),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DateTimePicker(
                  type: DateTimePickerType.dateTimeSeparate,
                  timeHintText: 'Install Time',
                  dateHintText: 'Install Date',
                  dateMask: 'd MMM, yyyy',
                  initialValue: DateTime.now().toString(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2500),
                  dateLabelText: 'Date',
                  timeLabelText: "Hour",
                  onChanged: (val) => (setState(() {
                    _dateRPDate = DateTime.tryParse(val)!;

                    logger.d(_dateRPDate);
                  })),
                  validator: (val) {
                    logger.d(val);
                    return null;
                  },
                  onSaved: (val) => logger.d(val),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () {
                    dengueCaseProvider.addDengueCase(
                        _patientName.text,
                        int.parse(_patientAge.text),
                        _dateRPD,
                        _address.text,
                        double.parse(_infectedCoordsX.text),
                        double.parse(_infectedCoordsY.text),
                        _officerName.text,
                        selectedStatus!,
                        '',
                        '',
                        '');
                    logger.d(const Text("Adding to Firebase"));
                    Navigator.pop(context);
                  },
                  child: const Text("Add Dengue Case"))
            ],
          )),
        ));
  }
}
