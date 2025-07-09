import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desapv3/viewmodels/ovitrap_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:date_time_picker/date_time_picker.dart';

class AddOvitrapPage extends StatefulWidget {
  const AddOvitrapPage({super.key});

  @override
  State<AddOvitrapPage> createState() => _AddOvitrapPageState();
}

class _AddOvitrapPageState extends State<AddOvitrapPage> {
  final formKey = GlobalKey<FormState>();

  final logger = Logger();

  final _location = TextEditingController();
  final _member = TextEditingController();
  final _status = TextEditingController();
  final _epiWeekInstl = TextEditingController();
  final _epiWeekRmv = TextEditingController();

  late DateTime _instlDateTime;
  late DateTime _removeDateTime;

  late final Timestamp _instlTime = Timestamp.fromDate(_instlDateTime);
  late final Timestamp _removeTime = Timestamp.fromDate(_removeDateTime);

  @override
  Widget build(BuildContext context) {
    final ovitrapProvider =
        Provider.of<OvitrapViewModel>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Add An Ovitrap'),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Center(
                child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _location,
                    decoration: const InputDecoration(
                        hintText: "Location", labelText: "Location"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Location Field Is Required";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Row(children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _member,
                        decoration: const InputDecoration(
                            hintText: "Member Installed", labelText: "Member"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Member Name Is Required";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _status,
                        readOnly: true,
                        decoration: const InputDecoration(
                            hintText: "Status",
                            labelText: "Status",
                            suffixIcon: Icon(Icons.arrow_drop_down)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Status Is Required";
                          }
                          return null;
                        },
                        onTap: () async {
                          final option = await showMenu<String>(
                              initialValue: '- Select an Option -',
                              context: context,
                              position: const RelativeRect.fromLTRB(
                                  100, 100, 100, 100),
                              items: const [
                                PopupMenuItem(
                                  value: 'Standby',
                                  child: Text('Standby'),
                                ),
                                PopupMenuItem(
                                  value: 'In Use',
                                  child: Text('In Use'),
                                ),
                                PopupMenuItem(
                                  value: 'Collected',
                                  child: Text('Collected'),
                                ),
                                PopupMenuItem(
                                  value: 'Broken',
                                  child: Text('Broken'),
                                ),
                              ]);
                          if (option != null) {
                            _status.text = option.toString();
                          }
                        },
                      ),
                    ),
                  ),
                ]),
                const SizedBox(height: 10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _epiWeekInstl,
                            decoration: const InputDecoration(
                                hintText: "Epidemic Week Install",
                                labelText: "Epi Week Install"),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Epi Week Instl Is Required";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _epiWeekRmv,
                            decoration: const InputDecoration(
                                hintText: "Epidemic Week Remove",
                                labelText: "Epi Week Rmv"),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Epi Week Remove Is Required";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
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
                    dateLabelText: 'Install Date',
                    timeLabelText: "Install Hour",
                    onChanged: (val) => (setState(() {
                      _instlDateTime = DateTime.tryParse(val)!;

                      logger.d(_instlDateTime);
                    })),
                    validator: (val) {
                      logger.d(val);
                      return null;
                    },
                    onSaved: (val) => logger.d(val),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DateTimePicker(
                    type: DateTimePickerType.dateTimeSeparate,
                    timeHintText: 'Removal Time',
                    dateHintText: 'Removal Date',
                    dateMask: 'd MMM, yyyy',
                    initialValue: DateTime.now().toString(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2500),
                    dateLabelText: 'Remove Date',
                    timeLabelText: "Rmv Hour",
                    onChanged: (val) => (setState(() {
                      _removeDateTime = DateTime.tryParse(val)!;

                      logger.d(_removeDateTime);
                    })),
                    validator: (val) {
                      logger.d(val);
                      return null;
                    },
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        ovitrapProvider.addOviTrap(
                            _location.text,
                            _member.text,
                            _status.text,
                            int.parse(_epiWeekInstl.text),
                            int.parse(_epiWeekRmv.text),
                            _instlTime,
                            _removeTime);
                        logger.d(const Text("Adding to Firebase"));
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Add Ovitrap"))
              ],
            )),
          ),
        ));
  }
}
