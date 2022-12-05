// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:lostfound/screens/authenticate/register.dart';
import 'package:lostfound/screens/home/home.dart';
import 'package:lostfound/services/auth.dart';
import 'package:lostfound/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lostfound/storage.dart';

class signin extends StatefulWidget {
  @override
  State<signin> createState() => _signinState();
}

class _signinState extends State<signin> {
  List searchResult = [];
  String email = "";
  String pass = "";
  String error = "";
  //bool handle = false;
  void searchQuery(String query) async {
    final result = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: query)
        .get();
    setState(() {
      searchResult = result.docs.map((e) => e.data()).toList();
    });
  }

  final authService _auth = authService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false; //to show loading widget

  //text field state

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.grey,
            appBar: AppBar(
              backgroundColor: Colors.red,
              elevation: 0.0,
              title: Text('Sign in to LostFound'),
              actions: <Widget>[
                TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => register())));
                    },
                    icon: Icon(Icons.person),
                    label: Text('Register')),
              ],
            ),
            //resizeToAvoidBottomPadding: false,
            body: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: Form(
                  key: _formKey,
                  child: Column(children: <Widget>[
                    SizedBox(height: 10.0),
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: 'Email',
                          fillColor: Colors.white,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2.0))),
                      validator: (val) =>
                          val!.isEmpty ? 'Enter an email' : null,
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: 'Password',
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
                        setState(() => pass = val);
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => loading = true);

                            dynamic result =
                                await _auth.signinWithEmailPass(email, pass);
                            if (result != null) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => home())));
                            }
                            if (result == null) {
                              setState(() {
                                error = 'wrong email or password';
                                loading = false;
                              });
                            }
                          }
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll<Color>(Colors.blue)),
                        child: Text(
                          'Sign In',
                          style: TextStyle(color: Colors.black),
                        )),
                    //SizedBox(height: 10.0),
                    Text(error,
                        style: TextStyle(color: Colors.red, fontSize: 18.0)),
                  ]),
                )),
          );
  }
}
