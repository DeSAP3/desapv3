import "package:desapv3/controllers/navigation_link.dart";
import "package:desapv3/firebase_options.dart";
import "package:flutter/material.dart";
import "controllers/route_generator.dart";
import "package:firebase_core/firebase_core.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
      initialRoute: authRoute,
      onGenerateRoute: generateRoute,
    );
  }
}
