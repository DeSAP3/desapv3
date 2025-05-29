import "package:desapv3/controllers/data_controller.dart";
import "package:desapv3/controllers/dengue_case_controller.dart";
import "package:desapv3/controllers/navigation_link.dart";
import "package:desapv3/controllers/user_controller.dart";
import "package:desapv3/firebase_options.dart";
import "package:desapv3/reuseable_widget/app_input_theme.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "controllers/route_generator.dart";
import "package:firebase_core/firebase_core.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataController()),
        ChangeNotifierProvider(create: (_) => DengueCaseController()),
        ChangeNotifierProvider(create: (_) => UserController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "DeSAP",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        inputDecorationTheme: AppInputTheme().theme()
      ),
      initialRoute: authRoute,
      onGenerateRoute: generateRoute,
    );
  }
}
