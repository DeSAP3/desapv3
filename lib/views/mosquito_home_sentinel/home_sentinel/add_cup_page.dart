import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desapv3/controllers/data_controller.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class AddCupPage extends StatefulWidget {
  final String localityCaseID;
  const AddCupPage(this.localityCaseID, {super.key});

  @override
  State<AddCupPage> createState() => _AddCupPageState();
}

class _AddCupPageState extends State<AddCupPage> {
  final formKey = GlobalKey<FormState>();

  final logger = Logger();

  final _eggCount = TextEditingController();
  final _larvaeCount = TextEditingController();
  final _status = TextEditingController();

  late String currentLCID;

  @override
  void initState() {
    super.initState();
    currentLCID = widget.localityCaseID;
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataController>(context, listen: false);

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
                    dataProvider.addCup(
                      int.parse(_eggCount.text),
                      0,
                      0,
                      int.parse(_larvaeCount.text),
                      _status.text,
                      currentLCID
                    );
                    logger.d(const Text("Adding to Firebase"));
                    Navigator.pop(context);
                  },
                  child: const Text("Add Cup"))
            ],
          )),
        ));
  }
}
