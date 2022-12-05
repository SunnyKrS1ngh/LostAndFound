// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:lostfound/screens/home/home.dart';
import 'package:lostfound/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:file_picker/file_picker.dart';
import 'package:lostfound/storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class postFound extends StatefulWidget {
  const postFound({super.key});

  @override
  State<postFound> createState() => _postFoundState();
}

class _postFoundState extends State<postFound> {
  final Stream<QuerySnapshot> found =
      FirebaseFirestore.instance.collection('found').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        title: Text('Post found items'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Fill Details :',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              customForm()
            ],
          ),
        ),
      ),
    );
  }
}

class customForm extends StatefulWidget {
  const customForm({super.key});

  @override
  State<customForm> createState() => _customFormState();
}

class _customFormState extends State<customForm> {
  final _formKey = GlobalKey<FormState>();
  final Storage storage = Storage();

  String name = "";
  String phone = "";
  String whereFound = "";
  String message = "";
  String email = "";
  String fileName = "";
  @override
  Widget build(BuildContext context) {
    CollectionReference found = FirebaseFirestore.instance.collection('found');

    return Form(
      key: _formKey,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                hintText: 'Name',
                labelText: 'Name',
              ),
              onChanged: (val) {
                name = val;
              },
              validator: (value) {
                if (value == null) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.phone),
                hintText: 'phone',
                labelText: 'phone',
              ),
              onChanged: (val) {
                phone = val;
              },
              validator: (value) {
                if (value == null) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.shopping_bag),
                hintText: 'Where found',
                labelText: 'Where found',
              ),
              onChanged: (val) {
                whereFound = val;
              },
              validator: (value) {
                if (value == null) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.message),
                hintText: 'Message',
                labelText: 'Message',
              ),
              onChanged: (val) {
                message = val;
              },
              validator: (value) {
                if (value == null) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.message),
                hintText: 'Email',
                labelText: 'Email',
              ),
              onChanged: (val) {
                email = val;
              },
              validator: (value) {
                if (value == null) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final results = await FilePicker.platform.pickFiles(
                    allowMultiple: false,
                    type: FileType.custom,
                    allowedExtensions: ['png', 'jpg'],
                  );
                  if (results == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No files Selected')),
                    );
                    return null;
                  }
                  final path = results.files.single.path!;
                  fileName = results.files.single.name;
                  print(path);
                  print(fileName);

                  storage
                      .uploadFile(path, fileName)
                      .then((value) => print('Done'));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Image uploaded successfully')),
                  );
                },
                child: Text('Upload files'),
              ),
            ),
            SizedBox(height: 20.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Details saved successfully')),
                    );
                    Navigator.push(context,
                        MaterialPageRoute(builder: ((context) => home())));
                    found.add({
                      'name': name,
                      'phone': phone,
                      'whereFound': whereFound,
                      'message': message,
                      'email': email,
                      'image': fileName
                    }).catchError(
                        (error) => print('Failed to add object : $error'));
                  }
                },
                child: Text('Submit'),
              ),
            )
          ]),
    );
  }
}
