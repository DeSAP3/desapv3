import 'package:desapv3/controllers/navigation_link.dart';
import 'package:desapv3/controllers/route_generator.dart';
import 'package:desapv3/models/ovitrap.dart';
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
                  Icons.delete,
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
          child: const Icon(Icons.more, color: Colors.white),
        ),
        appBar: AppBar(),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 25, child: Text("Mosquito Home Sentinel")),
              Flexible(
                child: FutureBuilder(
                  future: dataProvider.fetchOviTraps(),
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
                                      .instlTime
                                      .millisecondsSinceEpoch);
                          DateTime removeTimeDisplay =
                              DateTime.fromMillisecondsSinceEpoch(
                                  oviTraps[index]
                                      .removeTime
                                      .millisecondsSinceEpoch);
                          return ListTile(
                            leading: active != 'none'
                                ? 
                                IconButton(
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
                                            .deleteOvitrap(oviTraps[index]);
                                      } else if (active == 'qrcode') {
                                        Navigator.pushNamed(
                                            context, qrCodeGeneratorRoute,
                                            arguments:
                                                oviTraps[index].oviTrapID);
                                      }
                                    },
                                    icon: Icon(active == 'edit'
                                        ? Icons.edit
                                        : Icons.delete)
                                        )
                                : null,
                            title: Text(oviTraps[index].location),
                            subtitle: Text(
                              "Member: ${oviTraps[index].member}\t\t\t\t\tStatus: ${oviTraps[index].status}\nEpid Week Inst: ${oviTraps[index].epiWeekInstl}\t\t\t\t\tEpid Week Rmv: ${oviTraps[index].epiWeekRmv}\nInst Time: $instlTimeDisplay\nRmv Time: $removeTimeDisplay",
                            ),
                          );
                          // Center(
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: [
                          //       Flexible(
                          //           child: enableEditing
                          //               ? ElevatedButton(
                          //                   onPressed: () {},
                          //                   child: const Icon(Icons.edit))
                          //               : const SizedBox(
                          //                   height: 5,
                          //                   width: 5,
                          //                   child: Text("Yes"),
                          //                 )),
                          //       Flexible(
                          //           child: Center(
                          //         child: Column(
                          //           children: [
                          //             Text(oviTraps[index].location),
                          //             Row(
                          //               children: [
                          //                 Text(
                          //                     "Member: ${oviTraps[index].member}"),
                          //                     const SizedBox(width: 5),
                          //                 Text(
                          //                     "Status: ${oviTraps[index].status}")
                          //               ],
                          //             ),
                          //             const SizedBox(height: 10),
                          //             Row(
                          //               children: [
                          //                 Text(
                          //                   "EpiWeek Inst: ${oviTraps[index].epiWeekInstl}",
                          //                   maxLines: 1,
                          //                   overflow: TextOverflow.ellipsis,
                          //                 ),
                          //                 Text(
                          //                     "EpiWeek Rmv: ${oviTraps[index].epiWeekRmv}")
                          //               ],
                          //             ),
                          //             const SizedBox(height: 10),
                          //             Row(
                          //               children: [
                          //                 Text(
                          //                     "Inst Time: ${oviTraps[index].instlTime}"),
                          //                 Text(
                          //                     "Rmv Time: ${oviTraps[index].removeTime}")
                          //               ],
                          //             ),
                          //           ],
                          //         ),
                          //       ))
                          //     ],
                          //   ),
                          // );
                        });
                  },
                ),
              )
            ],
          ),
        ));
  }
}
