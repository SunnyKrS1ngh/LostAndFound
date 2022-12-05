// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:lostfound/screens/authenticate/signIn.dart';
import 'package:lostfound/screens/home/home.dart';
import 'package:lostfound/services/auth.dart';
import 'package:lostfound/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class register extends StatefulWidget {
  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final authService _auth = authService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String email = "";
  String pass = "";
  String error = "";
  String name = "";
  String roll = "";
  String phone = "";
  String confPass = "";

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.grey,
            appBar: AppBar(
              backgroundColor: Colors.blue[600],
              elevation: 0.0,
              title: Text('Sign Up'),
              actions: <Widget>[
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: ((context) => signin())));
                  },
                  icon: Icon(Icons.person),
                  label: Text('SignIn'),
                  style: TextButton.styleFrom(foregroundColor: Colors.green),
                ),
              ],
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
                            hintText: 'Email',
                            fillColor: Colors.white,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black, width: 2.0))),
                        validator: (val) =>
                            val!.isEmpty ? 'Enter an email' : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration: InputDecoration(
                            hintText: 'Password',
                            fillColor: Colors.white,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black, width: 2.0))),
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
                      TextFormField(
                        decoration: InputDecoration(
                            hintText: 'Name',
                            fillColor: Colors.white,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black, width: 2.0))),
                        onChanged: (val) {
                          setState(() => name = val);
                        },
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        decoration: InputDecoration(
                            hintText: 'Roll',
                            fillColor: Colors.white,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black, width: 2.0))),
                        onChanged: (val) {
                          setState(() => roll = val);
                        },
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        decoration: InputDecoration(
                            hintText: 'phone',
                            fillColor: Colors.white,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black, width: 2.0))),
                        onChanged: (val) {
                          setState(() => phone = val);
                        },
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        decoration: InputDecoration(
                            hintText: 'Confirm Pass',
                            fillColor: Colors.white,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black, width: 2.0))),
                        onChanged: (val) {
                          setState(() => confPass = val);
                        },
                      ),
                      SizedBox(height: 10.0),
                      ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate() &&
                                pass == confPass) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => signin())));
                              DocumentReference docRef = await FirebaseFirestore
                                  .instance
                                  .collection('users')
                                  .add({
                                'name': name,
                                'email': email,
                                'pass': pass,
                                'phone': phone,
                                'roll': roll
                              }).catchError((error) =>
                                      print('Failed to add object : $error'));
                              String id = docRef.id;
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(id)
                                  .update({'id': id});
                              setState(() => loading = true);
                              dynamic result = await _auth.regWithEmailPass(
                                  email, pass, name, roll, phone, confPass);
                              if (result == null) {
                                setState(() {
                                  error = 'wrong email or password';
                                  loading = false;
                                });
                              }
                            } else if (pass != confPass) {
                              setState(() {
                                error =
                                    'Password and Confirm Password dont match';
                                loading = false;
                              });
                            }
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll<Color>(
                                  Colors.redAccent)),
                          child: Text(
                            'Register',
                            style: TextStyle(color: Colors.white),
                          )),
                      SizedBox(height: 20.0),
                      Text(error,
                          style: TextStyle(color: Colors.red, fontSize: 18.0)),
                    ]),
                  ),
                )),
          );
  }
}
