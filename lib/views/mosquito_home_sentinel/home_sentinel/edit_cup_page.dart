import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desapv3/controllers/data_controller.dart';
import 'package:desapv3/models/cup.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class EditCupPage extends StatefulWidget {
  final Cup currentCup;
  const EditCupPage(this.currentCup, {super.key});

  @override
  State<EditCupPage> createState() => _EditCupPageState();
}

class _EditCupPageState extends State<EditCupPage> {
  final formKey = GlobalKey<FormState>();

  final logger = Logger();

  late final _eggCount =
      TextEditingController(text: currentCupInEdit.eggCount.toString());
  late final _larvaeCount =
      TextEditingController(text: currentCupInEdit.larvaeCount.toString());
  late final _status =
      TextEditingController(text: currentCupInEdit.status.toString());

  late Cup currentCupInEdit;
  late int currentCupIndex;

  @override
  void initState() {
    super.initState();
    currentCupInEdit = widget.currentCup;
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataController>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
          title: Text('Update Cup ${currentCupInEdit.cupID} Information'),
        ),
        body: Form(
          key: formKey,
          child: Center(
              child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _eggCount,
                  decoration:
                      const InputDecoration(hintText: "Mosquito Egg Count"),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(height: 10),
              Row(children: [
                Flexible(
                  child: TextFormField(
                    controller: _larvaeCount,
                    decoration: const InputDecoration(hintText: "Larvae Count"),
                    keyboardType: TextInputType.number,
                  ),
                ),
                Flexible(
                    child: TextFormField(
                  controller: _status,
                  decoration: const InputDecoration(hintText: "Status"),
                )),
              ]),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () {
                    dataProvider.updateCup(
                        Cup(
                            currentCupInEdit.cupID,
                            int.parse(_eggCount.text),
                            0,
                            0,
                            int.parse(_larvaeCount.text),
                            _status.text,
                            currentCupInEdit.localityCaseID));
                    logger.d(const Text("Updating Cup in Firebase"));
                    Navigator.pop(context);
                  },
                  child: const Text("Update Cup"))
            ],
          )),
        ));
  }
}
