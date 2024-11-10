import "package:desapv3/controllers/navigation_link.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "controllers/route_generator.dart";
import "package:firebase_core/firebase_core.dart";

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb){
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBseqBHMowYT0RnkH72fEkFITAmF26XtdI",
            authDomain: "desap-96a0a.firebaseapp.com",
            projectId: "desap-96a0a",
            storageBucket: "desap-96a0a.firebasestorage.app",
            messagingSenderId: "119449793685",
            appId: "1:119449793685:web:6d3d0db40191a8f193179c",
            measurementId: "G-W3WJJM5GDS"
            // Web Firebase Config
            ));
  } else {
    await Firebase.initializeApp();
  }
  
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
