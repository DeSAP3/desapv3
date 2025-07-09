import 'package:desapv3/viewmodels/cup_viewmodel.dart';
import 'package:desapv3/viewmodels/navigation_link.dart';
import 'package:desapv3/viewmodels/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class SentinelInfoPage extends StatefulWidget {
  final String ovitrapID;
  const SentinelInfoPage(this.ovitrapID, {super.key});

  @override
  State<SentinelInfoPage> createState() => _SentinelInfoPageState();
}

class _SentinelInfoPageState extends State<SentinelInfoPage> {
  final logger = Logger();
  late String currentOvitrapID;

  @override
  initState() {
    super.initState();
    currentOvitrapID = widget.ovitrapID;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CupViewModel>(context, listen: false).fetchCups();
    });
    logger.d(currentOvitrapID);
  }

  String active = "none";

  @override
  Widget build(BuildContext context) {
    final cupProvider = Provider.of<CupViewModel>(context);
    final cups = cupProvider.cupList
        .where((cup) => cup.ovitrapID == currentOvitrapID)
        .toList();
    return Scaffold(
        floatingActionButton: SpeedDial(
          activeIcon: Icons.close,
          iconTheme: const IconThemeData(color: Colors.white),
          buttonSize: const Size(50, 50),
          curve: Curves.bounceIn,
          children: [
            SpeedDialChild(
                elevation: 0,
                child: const Icon(
                  Icons.add,
                  color: Colors.blue,
                ),
                labelWidget: const Text("Add Cup"),
                backgroundColor: Colors.white70,
                onTap: () {
                  Navigator.pushNamed(context, addCupRoute,
                      arguments: currentOvitrapID);
                }),
            SpeedDialChild(
                elevation: 0,
                child: const Icon(
                  Icons.edit,
                  color: Colors.blue,
                ),
                labelWidget: const Text("Edit Cup"),
                backgroundColor: Colors.white70,
                onTap: () {
                  setState(() {
                    active = active == "edit" ? "none" : "edit";
                  });
                }),
            SpeedDialChild(
                elevation: 0,
                child: const Icon(
                  Icons.delete,
                  color: Colors.blue,
                ),
                labelWidget: const Text("Delete Cup"),
                backgroundColor: Colors.white70,
                onTap: () {
                  setState(() {
                    active = active == "delete" ? "none" : "delete";
                  });
                }),
            SpeedDialChild(
                elevation: 0,
                child: const Icon(
                  Icons.local_activity,
                  color: Colors.blue,
                ),
                labelWidget: const Text("Activate Cup"),
                backgroundColor: Colors.white70,
                onTap: () {
                  setState(() {
                    active = active == "activate" ? "none" : "activate";
                  });
                })
          ],
          child: const Icon(Icons.more, color: Colors.white),
        ),
        appBar: AppBar(title: const Text("Sentinel Information")),
        body: cupProvider.isFetchingCups
            ? const Center(child: CircularProgressIndicator())
            : cupProvider.cupList.isEmpty
                ? const Center(child: Text('No Cup Entry Found'))
                : Center(
                    child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: cups.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              leading: active != 'none'
                                  ? IconButton(
                                      onPressed: () {
                                        if (active == 'edit') {
                                          Navigator.pushNamed(
                                            context,
                                            editCupRoute,
                                            arguments:
                                                EditCupArguments(cups[index]),
                                          );
                                        } else if (active == 'delete') {
                                          cupProvider.deleteCup(cups[index]);
                                        } else if (active == 'activate') {
                                          logger.d("In Activation");
                                          cupProvider.updateCupActivity(
                                              currentOvitrapID, cups[index]);
                                        }
                                      },
                                      icon: Icon(functionIcon(active)),
                                      tooltip: "Edit",
                                    )
                                  : null,
                              title: Text(cups[index].cupID!),
                              subtitle: Text(
                                "Mosquito Egg Count: ${cups[index].eggCount}\nCoordinate X: ${cups[index].gpsX}\t\t\t\t\tCoordinate Y: ${cups[index].gpsY}\nLarvae Count: ${cups[index].larvaeCount}\t\t\tIn Use: ${cups[index].isActive ? 'Yes' : 'No'}\nCup Status: ${cups[index].status}",
                              ),
                            ),
                          );
                        })));
  }

  IconData functionIcon(String active) {
    if (active == 'add') {
      return Icons.add;
    } else if (active == 'edit') {
      return Icons.edit;
    } else if (active == 'delete') {
      return Icons.delete;
    } else if (active == 'activate') {
      return Icons.local_activity;
    }

    return Icons.question_mark;
  }
}
