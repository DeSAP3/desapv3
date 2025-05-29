import 'package:desapv3/reuseable_widget/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class DengueApproval extends StatefulWidget {
  const DengueApproval({super.key});

  @override
  State<DengueApproval> createState() => _DengueApprovalState();
}

class _DengueApprovalState extends State<DengueApproval> {
  String active = "none";
  @override
  Widget build(BuildContext context) {
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
                  //Navigator.pushNamed(context, addOvitrapRoute);
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
          child: const Icon(Icons.more, color: Colors.white)),
      appBar: AppBar(
        title: const Text('Dengue Case List'),
      ),
      body: Center(

      ),
    );
  }
}
