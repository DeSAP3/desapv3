import 'package:desapv3/routing/router_path.dart';
import 'package:desapv3/viewmodels/navigation_link.dart';
import 'package:desapv3/viewmodels/user_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  Logger logger = Logger();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          Consumer<UserViewModel>(
            builder: (context, userProvider, child) {
              final user = userProvider.user;
              logger.d("App Drawer");

              if (user == null) {
                return const DrawerHeader(
                  child: Text(
                    'Loading...',
                    style: TextStyle(color: Colors.black),
                  ),
                );
              }

              return DrawerHeader(
                child: Text(
                  'Hello ${userProvider.getRole(user.role ?? 0)} ${user.fName ?? "User"}',
                  style: const TextStyle(color: Colors.black),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Dashboard'),
            onTap: () {
              context.go('/home');
            },
          ),
          formattedDivider(),
          ListTile(
            leading: const Icon(Icons.list_alt),
            title: const Text('Dengue Case Report'),
            onTap: () {
              context.go('/dengueReport');
            },
          ),
          formattedDivider(),
          ListTile(
            leading: const Icon(Icons.info_rounded),
            title: const Text('Mosquito Home Sentinel'),
            onTap: () {
              context.go('/homeSentinel');
            },
          ),
          formattedDivider(),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Historical Map'),
            onTap: () {
              context.go('/mosquitoMap');
            },
          ),
          formattedDivider(),
          ListTile(
            leading: const Icon(Icons.qr_code_scanner),
            title: const Text('QR Scanner'),
            onTap: () {
              context.go('/qrScanner');
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
