// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:lostfound/models/user.dart';
import 'package:lostfound/screens/authenticate/authenticate.dart';
import 'package:lostfound/screens/authenticate/register.dart';
import 'package:lostfound/screens/authenticate/signIn.dart';
import 'package:lostfound/screens/home/home.dart';
import 'package:provider/provider.dart';

class wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);

    //return either home or authenticate

    if (user == null) {
      return register();
    } else {
      return signin();
    }
  }
}
