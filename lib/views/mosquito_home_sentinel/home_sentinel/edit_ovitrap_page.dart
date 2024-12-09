import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desapv3/controllers/data_controller.dart';
import 'package:desapv3/models/ovitrap.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:date_time_picker/date_time_picker.dart';

class EditOvitrapPage extends StatefulWidget {
  final Ovitrap data;
  final int index;
  const EditOvitrapPage(this.data, this.index, {super.key});

  @override
  State<EditOvitrapPage> createState() => _EditOvitrapPageState();
}

class _EditOvitrapPageState extends State<EditOvitrapPage> {
  final formKey = GlobalKey<FormState>();

  final logger = Logger();

  late final _location = TextEditingController(text: currentOvitrap.location);
  late final _member = TextEditingController(text: currentOvitrap.member);
  late final _status = TextEditingController(text: currentOvitrap.status);
  late final _epiWeekInstl =
      TextEditingController(text: currentOvitrap.epiWeekInstl.toString());
  late final _epiWeekRmv =
      TextEditingController(text: currentOvitrap.epiWeekRmv.toString());

  late DateTime _instlDateTime;
  late DateTime _removeDateTime;

  late final Timestamp _instlTime = Timestamp.fromDate(_instlDateTime);
  late final Timestamp _removeTime = Timestamp.fromDate(_removeDateTime);

  late Ovitrap currentOvitrap;

  @override
  void initState() {
    super.initState();
    currentOvitrap = widget.data;
    logger.d(currentOvitrap);
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataController>(context, listen: false);

    DateTime oldInstlTime = DateTime.fromMillisecondsSinceEpoch(
        currentOvitrap.instlTime.millisecondsSinceEpoch);
    DateTime oldRemoveTime = DateTime.fromMillisecondsSinceEpoch(
        currentOvitrap.instlTime.millisecondsSinceEpoch);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit An Ovitrap'),
        ),
        body: Form(
          key: formKey,
          child: Center(
              child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    controller: _location,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        logger.d("No Location");
                      }
                      return null;
                    }),
              ),
              const SizedBox(height: 10),
              Row(children: [
                Flexible(
                  child: TextFormField(
                      controller: _member,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          logger.d("No Member");
                        }
                        return null;
                      }),
                ),
                Flexible(
                    child: TextFormField(
                        controller: _status,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            logger.d("No Status");
                          }
                          return null;
                        })),
              ]),
              const SizedBox(height: 10),
              Row(children: [
                Flexible(
                  child: TextFormField(
                      controller: _epiWeekInstl,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          logger.d("No Epid Week Instl");
                        }
                        return null;
                      }),
                ),
                Flexible(
                  child: TextFormField(
                      controller: _epiWeekRmv,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          logger.d("No Epid Week Remove");
                        }
                        return null;
                      }),
                ),
              ]),
              const SizedBox(height: 10),
              Flexible(
                child: DateTimePicker(
                  type: DateTimePickerType.dateTimeSeparate,
                  dateMask: 'd MMM, yyyy',
                  initialValue: oldInstlTime.toString(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2500),
                  dateLabelText: 'Date',
                  timeLabelText: "Hour",
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
              Flexible(
                child: DateTimePicker(
                  type: DateTimePickerType.dateTimeSeparate,
                  dateMask: 'd MMM, yyyy',
                  initialValue: oldRemoveTime.toString(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2500),
                  dateLabelText: 'Date',
                  timeLabelText: "Hour",
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
                    dataProvider.updateOvitrap(
                        Ovitrap(
                            currentOvitrap.oviTrapID,
                            _location.text,
                            _member.text,
                            _status.text,
                            int.parse(_epiWeekInstl.text),
                            int.parse(_epiWeekRmv.text),
                            _instlTime,
                            _removeTime,
                            currentOvitrap.cupID),
                        widget.index);
                    logger.d(const Text("Edited"));
                    Navigator.pop(context);
                  },
                  child: const Text("Update Ovitrap"))
            ],
          )),
        ));
  }
}
