import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:the_serve_new/auth/login_page.dart.dart';
import 'package:the_serve_new/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'The Serve',
      home: LoginPage(),
    );
  }
}
