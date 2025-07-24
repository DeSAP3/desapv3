import 'package:desapv3/routing/router_path.dart';
import 'package:desapv3/viewmodels/dengue_case_viewmodel.dart';
import 'package:desapv3/reuseable_widget/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';
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
      Provider.of<DengueCaseViewModel>(context, listen: false)
          .fetchDengueCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dengueCaseProvider = Provider.of<DengueCaseViewModel>(context);
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
                  context.go('/addDengueCase');
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
        title: const Text('Dengue Case Report List'),
      ),
      body: dengueCaseProvider.isFetchingDengueCase
          ? const Center(child: CircularProgressIndicator())
          : dengueCaseProvider.dengueCaseList.isEmpty
              ? const Center(child: Text('No Dengue Case Entry Found'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: dengueCaseProvider.dengueCaseList.length,
                  itemBuilder: (context, index) {
                    final dengueC = dengueCaseProvider.dengueCaseList[index];
                    final date = DateTime.fromMillisecondsSinceEpoch(
                        dengueC.dateRPD!.millisecondsSinceEpoch);

                    return GestureDetector(
                      onTap: () {
                        context.push('/dengueCaseDetail', extra: DengueCaseDetailArguments(dengueC));
                      },
                      child: Card(
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
                                      context.push('/editDengueCase',
                                          extra: EditDengueCaseArguments(
                                              dengueC, index));
                                    } else if (active == 'delete') {
                                      dengueCaseProvider
                                          .deleteDengueCase(dengueC);
                                    }
                                  },
                                  icon: Icon(functionIcon(active)))
                              : null,
                          title: Text(dengueC.patientName!),
                          subtitle: Text(
                            "Status: ${dengueC.status}\nReport Time: $date",
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios),
                        ),
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
