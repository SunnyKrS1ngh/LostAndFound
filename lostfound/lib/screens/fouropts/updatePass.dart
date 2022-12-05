import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lostfound/storage.dart';

class updatePass extends StatefulWidget {
  const updatePass({super.key});

  @override
  State<updatePass> createState() => _updatePassState();
}

class _updatePassState extends State<updatePass> {
  final fireStore = FirebaseFirestore.instance.collection('users').snapshots();
  CollectionReference ref = FirebaseFirestore.instance.collection('users');
  String CurrPass = "";
  String NewPass = "";
  final _formKey = GlobalKey<FormState>();
  List searchResult = [];
  bool handle = false;
  void searchQuery(String query) async {
    final result = await FirebaseFirestore.instance
        .collection('users')
        .where('pass', isEqualTo: query)
        .get();
    setState(() {
      searchResult = result.docs.map((e) => e.data()).toList();
    });
  }

  final currentUser = FirebaseAuth.instance.currentUser;
  changePass(newPass) {
    try {
      currentUser!.updatePassword(newPass);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('your password changed Successfully')),
      );
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[600],
        elevation: 0.0,
        title: Text('Update Password'),
      ),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(children: <Widget>[
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: InputDecoration(
                      hintText: 'Current Pass',
                      fillColor: Colors.white,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0))),
                  validator: (val) => val!.isEmpty ? 'Enter password' : null,
                  onChanged: (val) {
                    setState(() => CurrPass = val);
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: InputDecoration(
                      hintText: 'Enter new Password',
                      fillColor: Colors.white,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0))),
                  validator: (val) => val!.length < 6
                      ? 'Enter a password 6+ character long'
                      : null,
                  obscureText: true,
                  onChanged: (val) {
                    setState(() => NewPass = val);
                  },
                ),
                ElevatedButton(
                    onPressed: () {
                      searchQuery(CurrPass);
                      print(searchResult[0]['name']);
                      changePass(NewPass);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('your password changed Successfully')),
                      );
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(searchResult[0]['id'])
                          .update({'pass': NewPass})
                          .then((value) => print("User Updated"))
                          .catchError((error) =>
                              print("Failed to update user: $error"));
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(Colors.redAccent)),
                    child: Text(
                      'Confirm New Pass',
                      style: TextStyle(color: Colors.white),
                    )),
              ]),
            ),
          )),
    );
  }
}
