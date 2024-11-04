import "package:desapv3/controllers/navigation_link.dart";
import "package:flutter/material.dart";
import "controllers/route_generator.dart";


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "DeSAP",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      initialRoute: homeRoute,
      onGenerateRoute: generateRoute,
    );
  }
}
