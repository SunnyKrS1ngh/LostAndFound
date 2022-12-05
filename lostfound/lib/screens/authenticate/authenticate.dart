// // ignore_for_file: prefer_const_constructors
// import 'package:flutter/material.dart';
// import 'package:lostfound/screens/authenticate/register.dart';
// import 'package:lostfound/screens/authenticate/signIn.dart';

// class authenticate extends StatefulWidget {
//   const authenticate({super.key});

//   @override
//   State<authenticate> createState() => _authenticateState();
// }

// class _authenticateState extends State<authenticate> {
//   bool showsignin = true;
//   void toggleView() {
//     setState(() => showsignin = !showsignin);
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (showsignin) {
//       return signin(toggleView: toggleView);
//     } else {
//       return register(toggleView: toggleView);
//     }
//   }
// }
