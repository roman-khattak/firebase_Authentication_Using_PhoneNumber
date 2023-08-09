// library imported for Firebase in Firebase.initializeApp();
// firebase_core dependency in Pubspec.yaml is also added so that this library can be imported
import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_urraan/screen_email_sign_up.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();              // In future await so that first, Firebase should be initialized then the app should run

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ScreenEmailSignUp()
    );
  }
}
