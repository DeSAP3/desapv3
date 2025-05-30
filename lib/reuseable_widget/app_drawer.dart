import 'package:desapv3/controllers/navigation_link.dart';
import 'package:desapv3/controllers/user_controller.dart';
import 'package:desapv3/views/historical_map/mosquito_home_map_page.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // Logger logger = Logger();
    final loggedInUser = Provider.of<UserController>(context).user;
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          const DrawerHeader(
              child: Text('Menu', style: TextStyle(color: Colors.black))),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushReplacementNamed(context, homeRoute);
            },
          ),
          formattedDivider(),
          ListTile(
            leading: const Icon(Icons.list_alt),
            title: const Text('Dengue Case Report'),
            onTap: () {
              Navigator.pushReplacementNamed(context, dengueReportRoute);
            },
          ),
          formattedDivider(),
          ListTile(
            leading: const Icon(Icons.info_rounded),
            title: const Text('Mosquito Home Sentinel'),
            onTap: () {
              Navigator.pushReplacementNamed(context, homeSentinelRoute);
            },
          ),
          formattedDivider(),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Historical Map'),
            onTap: () {
              Navigator.pushReplacementNamed(context, mosquitoMapRoute);
            },
          ),
          formattedDivider(),
          ListTile(
            leading: const Icon(Icons.qr_code_scanner),
            title: const Text('QR Scanner'),
            onTap: () {
              Navigator.pushNamed(context, qrCodeScannerRoute);
            },
          ),
        ],
      ),
    );
  }

  Widget formattedDivider() {
    return Divider(
      thickness: 1,
      color: Colors.grey[500],
      indent: 8, // Starts 16 px from the left
      endIndent: 8, // Ends 16 px before the right edge
    );
  }
}
