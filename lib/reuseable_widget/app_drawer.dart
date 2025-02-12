import 'package:desapv3/controllers/navigation_link.dart';
import 'package:desapv3/views/historical_map/mosquito_home_map_page.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
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
          ListTile(
            leading: const Icon(Icons.info_rounded),
            title: const Text('Mosquito Home Sentinel'),
            onTap: () {
              Navigator.pushReplacementNamed(context, homeSentinelRoute);
            },
          ),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Historical Map'),
            onTap: () {
              Navigator.pushReplacementNamed(context, mosquitoMapRoute);
            },
          ),
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
}
