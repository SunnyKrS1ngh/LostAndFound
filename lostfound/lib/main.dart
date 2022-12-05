// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:lostfound/models/user.dart';
import 'package:lostfound/screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lostfound/services/auth.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<MyUser?>.value(
      catchError: ((context, error) {}),
      initialData: null,
      value: authService().user,
      child: MaterialApp(
        home: wrapper(),
      ),
    );
  }
}
