import 'package:desapv3/controllers/dengue_case_controller.dart';
import 'package:desapv3/controllers/navigation_link.dart';
import 'package:desapv3/controllers/route_generator.dart';
import 'package:desapv3/reuseable_widget/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

class DengueReport extends StatefulWidget {
  const DengueReport({super.key});

  @override
  State<DengueReport> createState() => _DengueReportState();
}

class _DengueReportState extends State<DengueReport> {
  String active = "none";

  @override
  void initState() {
    super.initState();
        WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DengueCaseController>(context, listen: false)
          .fetchDengueCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<DengueCaseController>(context);
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
                  labelWidget: const Text("Add Dengue Case"),
                  backgroundColor: Colors.white70,
                  onTap: () {
                    Navigator.pushNamed(context, addDengueCaseRoute);
                  }),
              SpeedDialChild(
                  elevation: 0,
                  child: const Icon(
                    Icons.edit,
                    color: Colors.blue,
                  ),
                  labelWidget: const Text("Edit Dengue Case"),
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
                  labelWidget: const Text("Delete Dengue Case"),
                  backgroundColor: Colors.white70,
                  onTap: () {
                    setState(() {
                      active = active == "delete" ? "none" : "delete";
                    });
                  }),
            ],
            child: const Icon(Icons.more, color: Colors.white)),
        appBar: AppBar(
          title: const Text('Dengue Case List'),
        ),
   body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : controller.dengueCaseList.isEmpty
              ? const Center(child: Text('No dengue cases found.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.dengueCaseList.length,
                  itemBuilder: (context, index) {
                    final caseItem = controller.dengueCaseList[index];
                    final date = DateTime.fromMillisecondsSinceEpoch(
                        caseItem.dateRPD!.millisecondsSinceEpoch);

                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, dengueCaseDetailRoute,
                            arguments: DengueCaseDetailArguments(caseItem));
                      },
                      child: ListTile(
                        leading: active != 'none'
                            ? IconButton(
                                onPressed: () {
                                  if (active == 'edit') {
                                    Navigator.pushNamed(
                                      context,
                                      editDengueCaseRoute,
                                      arguments: EditDengueCaseArguments(
                                          caseItem, index),
                                    );
                                  } else if (active == 'delete') {
                                    controller.deleteDengueCase(caseItem);
                                  }
                                },
                                icon: Icon(functionIcon(active)))
                            : null,
                        title: Text(caseItem.patientName!),
                        subtitle: Text(
                          "Status: ${caseItem.status}\nReport Time: $date",
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                      ),
                    );
                  },
                ),
    );
  }

  IconData functionIcon(String active) {
    if (active == 'add') {
      return Icons.add;
    } else if (active == 'edit') {
      return Icons.edit;
    } else if (active == 'delete') {
      return Icons.delete;
    } else if (active == 'assign') {
      return Icons.assignment_add;
    }

    return Icons.question_mark;
  }
}
