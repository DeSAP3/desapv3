import 'package:desapv3/controllers/navigation_link.dart';
import 'package:desapv3/controllers/route_generator.dart';
import 'package:desapv3/reuseable_widget/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:desapv3/controllers/data_controller.dart';
import 'package:provider/provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class HomeSentinelPage extends StatefulWidget {
  const HomeSentinelPage({super.key});

  @override
  State<HomeSentinelPage> createState() => _HomeSentinelPageState();
}

class _HomeSentinelPageState extends State<HomeSentinelPage> {
  String active = "none";

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataController>(context, listen: false);
    return Scaffold(
      drawer: const AppDrawer(),
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
                  labelWidget: const Text("Add Ovitrap"),
                  backgroundColor: Colors.white70,
                  onTap: () {
                    Navigator.pushNamed(context, addOvitrapRoute);
                  }),
              SpeedDialChild(
                  elevation: 0,
                  child: const Icon(
                    Icons.edit,
                    color: Colors.blue,
                  ),
                  labelWidget: const Text("Edit Ovitrap"),
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
                  labelWidget: const Text("Delete Ovitrap"),
                  backgroundColor: Colors.white70,
                  onTap: () {
                    setState(() {
                      active = active == "delete" ? "none" : "delete";
                    });
                  }),
              SpeedDialChild(
                  elevation: 0,
                  child: const Icon(
                    Icons.qr_code,
                    color: Colors.blue,
                  ),
                  labelWidget: const Text("Generate Ovitrap QRCode"),
                  backgroundColor: Colors.white70,
                  onTap: () {
                    setState(() {
                      active = active == "generateQR" ? "none" : "generateQR";
                    });
                  }),
            ],
            child: const Icon(Icons.more, color: Colors.white)), //Button Menu
        appBar: AppBar(title: const Text("Mosquito Home Sentinel")),
        body: Center(
          child: Column(
            children: [
              Flexible(
                child: FutureBuilder(
                  future: dataProvider.fetchOviTrap(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('${snapshot.error}'));
                    }

                    final oviTraps = dataProvider.oviTrapList;

                    return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: oviTraps.length,
                        itemBuilder: (context, index) {
                          DateTime instlTimeDisplay =
                              DateTime.fromMillisecondsSinceEpoch(
                                  oviTraps[index]
                                      .instlTime!
                                      .millisecondsSinceEpoch);
                          DateTime removeTimeDisplay =
                              DateTime.fromMillisecondsSinceEpoch(
                                  oviTraps[index]
                                      .removeTime!
                                      .millisecondsSinceEpoch);
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, sentinelInfoRoute,
                                  arguments: oviTraps[index].oviTrapID);
                            },
                            child: ListTile(
                              leading: active != 'none'
                                  ? IconButton(
                                      onPressed: () {
                                        if (active == 'edit') {
                                          Navigator.pushNamed(
                                            context,
                                            editOvitrapRoute,
                                            arguments: EditOvitrapArguments(
                                                oviTraps[index], index),
                                          );
                                        } else if (active == 'delete') {
                                          dataProvider
                                              .deleteOviTrap(oviTraps[index]);
                                        } else if (active == 'generateQR') {
                                          Navigator.pushNamed(
                                            context,
                                          qrCodeGeneratorRoute,
                                            arguments: QrCodeGenArguments(
                                                oviTraps[index].oviTrapID),
                                          );
                                        }
                                      },
                                      icon: Icon(functionIcon(active)))
                                  : null,
                              title: Text(oviTraps[index].location!),
                              subtitle: Text(
                                "Member: ${oviTraps[index].member}\t\t\t\t\tStatus: ${oviTraps[index].status}\nEpid Week Inst: ${oviTraps[index].epiWeekInstl}\t\t\t\t\tEpid Week Rmv: ${oviTraps[index].epiWeekRmv}\nInst Time: $instlTimeDisplay\nRmv Time: $removeTimeDisplay",
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios),
                            ),
                          );
                        });
                  },
                ),
              )
            ],
          ),
        ));
  }

  IconData functionIcon(String active) {
    if (active == 'add') {
      return Icons.add;
    } else if (active == 'edit') {
      return Icons.edit;
    } else if (active == 'delete') {
      return Icons.delete;
    } else if (active == 'generateQR') {
      return Icons.qr_code;
    }

    return Icons.question_mark;
  }
}
