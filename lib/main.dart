import "package:desapv3/routing/router_path.dart";
import "package:desapv3/viewmodels/auth_notifier.dart";
import "package:desapv3/viewmodels/cup_viewmodel.dart";
import "package:desapv3/viewmodels/ovitrap_viewmodel.dart";
import "package:desapv3/viewmodels/dengue_case_viewmodel.dart";
import "package:desapv3/viewmodels/navigation_link.dart";
import "package:desapv3/viewmodels/user_viewmodel.dart";
import "package:desapv3/firebase_options.dart";
import "package:desapv3/reuseable_widget/app_input_theme.dart";
import "package:firebase_app_check/firebase_app_check.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "viewmodels/route_generator.dart";
import "package:firebase_core/firebase_core.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // await FirebaseAppCheck.instance.activate(
  //   androidProvider: AndroidProvider.debug, // or AndroidProvider.debug for dev
  //   appleProvider: AppleProvider.debug,
  // );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OvitrapViewModel()),
        ChangeNotifierProvider(create: (_) => CupViewModel()),
        ChangeNotifierProvider(create: (_) => DengueCaseViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => AuthNotifier(firebaseAuth: FirebaseAuth.instance)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authNotifier = context.watch<AuthNotifier>();
    return MaterialApp.router(
      title: "DeSAP",
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromARGB(255, 0, 93, 136),
            foregroundColor: Colors.white, // text and icon color
            centerTitle: true,
            titleTextStyle: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          primarySwatch: Colors.blue,
          inputDecorationTheme: AppInputTheme().theme()),
      routerConfig: createRoute(authNotifier)
    );
  }
}
