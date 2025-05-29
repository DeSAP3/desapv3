import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:desapv3/controllers/dengue_case_controller.dart';
import 'package:desapv3/services/location_map_service.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class AddDengueCase extends StatefulWidget {
  const AddDengueCase({super.key});

  @override
  State<AddDengueCase> createState() => _AddDengueCaseState();
}

class _AddDengueCaseState extends State<AddDengueCase> {
  final formKey = GlobalKey<FormState>();
  LocationServices locationService = LocationServices();
  final logger = Logger();

  final _patientName = TextEditingController();
  final _patientAge = TextEditingController();
  final _address = TextEditingController();
  final _officerName = TextEditingController();

  late DateTime _dateRPDate;

  Position? currentDCLocation;
  Placemark? currentPreciseCupLocation;

  late double coordX = 0.0;
  late double coordY = 0.0;

  late final Timestamp _dateRPD = Timestamp.fromDate(_dateRPDate);

  String? selectedStatus = 'Pending';
  // final List<String> statusOptions = ['Pending', 'Accepted', 'Declined'];

  @override
  Widget build(BuildContext context) {
    final dengueCaseProvider =
        Provider.of<DengueCaseController>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Report Dengue Case'),
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.my_location_outlined),
            onPressed: () {
              setCupLocation();
            }),
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
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _patientAge,
                  decoration: const InputDecoration(hintText: "Patient Age"),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _address,
                  decoration: const InputDecoration(hintText: "Address"),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _officerName,
                  decoration: const InputDecoration(hintText: "Officer Name"),
                ),
              ),
              // Flexible(
              //     child: DropdownButtonFormField<String>(
              //         value: selectedStatus,
              //         decoration: const InputDecoration(hintText: "Status"),
              //         items: statusOptions.map((String value) {
              //           return DropdownMenuItem<String>(
              //             value: value,
              //             child: Text(value),
              //           );
              //         }).toList(),
              //         onChanged: (String? newValue) {
              //           setState(() {
              //             selectedStatus = newValue;
              //           });
              //         })),

              const SizedBox(height: 5),
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
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Centers the children in the row
                children: [
                  Flexible(
                    child: Text(
                      "Coordinate X: ${currentDCLocation?.latitude?.toStringAsFixed(6) ?? 'N/A'}",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 20), // spacing between X and Y
                  Flexible(
                    child: Text(
                      "Coordinate Y: ${currentDCLocation?.longitude?.toStringAsFixed(6) ?? 'N/A'}",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              ElevatedButton(
                  onPressed: () {
                    dengueCaseProvider.addDengueCase(
                        _patientName.text,
                        int.parse(_patientAge.text),
                        _dateRPD,
                        _address.text,
                        currentDCLocation!.latitude,
                        currentDCLocation!.longitude,
                        _officerName.text,
                        selectedStatus!,
                        '',
                        '',
                        '');
                    logger.d(const Text("Adding to Firebase"));
                    Navigator.pop(context, true);
                  },
                  child: const Text("Add Dengue Case"))
            ],
          )),
        ));
  }

  Future<void> setCupLocation() async {
    logger.d("InSetCup");

    Position? newLocation = await locationService.getCurrentLocation();

    setState(() {
      currentDCLocation = newLocation;
      logger.d(currentDCLocation?.latitude);
    });

    await setPreciseCupLocation();
  }

  Future<void> setPreciseCupLocation() async {
    logger.d("InSetCoordinate");

    Placemark? newCoordinates =
        await locationService.getAddress(currentDCLocation!);

    setState(() {
      currentPreciseCupLocation = newCoordinates;
      logger.d(currentPreciseCupLocation?.locality);
    });
  }
}
