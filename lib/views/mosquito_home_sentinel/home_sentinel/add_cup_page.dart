import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desapv3/viewmodels/cup_viewmodel.dart';
import 'package:desapv3/viewmodels/ovitrap_viewmodel.dart';
import 'package:desapv3/services/location_map_service.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class AddCupPage extends StatefulWidget {
  final String ovitrapID;
  const AddCupPage(this.ovitrapID, {super.key});

  @override
  State<AddCupPage> createState() => _AddCupPageState();
}

class _AddCupPageState extends State<AddCupPage> {
  final formKey = GlobalKey<FormState>();
  final logger = Logger();

  final _eggCount = TextEditingController(text: '0');
  final _larvaeCount = TextEditingController(text: '0');
  final _status = TextEditingController();

  late String currentOvitrapID;



  @override
  void initState() {
    super.initState();
    currentOvitrapID = widget.ovitrapID;
  }

  @override
  Widget build(BuildContext context) {
    final cupProvider = Provider.of<CupViewModel>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Add a Cup'),
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.my_location_outlined),
            onPressed: () async {
              cupProvider.getCurrentCupLocation();
            }),
        body: Form(
          key: formKey,
          child: Center(
              child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _eggCount,
                  decoration: const InputDecoration(
                      hintText: "Mosquito Egg Count",
                      labelText: "Mosquito Egg Count"),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(height: 10),
              Row(children: [
                Flexible(
                  child: TextFormField(
                    controller: _larvaeCount,
                    decoration: const InputDecoration(
                        hintText: "Larvae Count", labelText: "Larvae Count"),
                    keyboardType: TextInputType.number,
                  ),
                ),
                Flexible(
                    child: TextFormField(
                  controller: _status,
                  readOnly: true,
                  decoration: const InputDecoration(
                      hintText: "Status",
                      labelText: "Status",
                      suffixIcon: Icon(Icons.arrow_drop_down)),
                  onTap: () async {
                    final option = await showMenu<String>(
                        initialValue: '- Select an Option -',
                        context: context,
                        position:
                            const RelativeRect.fromLTRB(100, 100, 100, 100),
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
                )),
              ]),
              const SizedBox(height: 10),
              Consumer<CupViewModel>(
                builder: (context, cupProvider, _) {
                  final loc = cupProvider.newLocation;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          "Coordinate X: ${loc?.latitude.toStringAsFixed(6) ?? 'N/A'}",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Flexible(
                        child: Text(
                          "Coordinate Y: ${loc?.longitude.toStringAsFixed(6) ?? 'N/A'}",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      cupProvider.addCup(
                          int.parse(_eggCount.text),
                          cupProvider.newLocation!.latitude,
                          cupProvider.newLocation!.longitude,
                          int.parse(_larvaeCount.text),
                          _status.text,
                          false,
                          currentOvitrapID);
                      cupProvider.newLocation = null;
                      logger.d(const Text("Adding to Firebase"));
                      context.pop();
                    }
                  },
                  child: const Text("Add Cup"))
            ],
          )),
        ));
  }
}
