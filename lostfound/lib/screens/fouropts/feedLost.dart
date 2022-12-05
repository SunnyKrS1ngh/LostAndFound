// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:lostfound/screens/fouropts/foundit.dart';
import 'package:lostfound/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:lostfound/storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:lostfound/screens/fouropts/postLost.dart';

class feedLost extends StatefulWidget {
  const feedLost({super.key});

  @override
  State<feedLost> createState() => _feedLostState();
}

class _feedLostState extends State<feedLost> {
  final Storage storage = Storage();
  String receiver = "";

  final Stream<QuerySnapshot> objects =
      FirebaseFirestore.instance.collection('objects').snapshots();
  final Stream<QuerySnapshot> users =
      FirebaseFirestore.instance.collection('users').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        title: Text('Feed of lost items'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 1000,
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: StreamBuilder<QuerySnapshot>(
                    stream: objects,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('some error has occured');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text('Loading');
                      }
                      final data = snapshot.requireData;
                      return ListView.builder(
                          itemCount: data.size,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8),
                              child: Card(
                                child: ListTile(
                                  onTap: () {
                                    print(data.docs[index]);
                                  },
                                  title: Text(
                                    "Name : " +
                                        data.docs[index]['name'] +
                                        "\n" +
                                        "Phone : " +
                                        data.docs[index]['phone'] +
                                        "\n" +
                                        "Where Lost : " +
                                        data.docs[index]['whereLost'] +
                                        "\n" +
                                        "Message : " +
                                        data.docs[index]['message'],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    children: <Widget>[
                                      FutureBuilder(
                                          future: storage.downloadURL(
                                              data.docs[index]['image']),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<String> snapshot) {
                                            if (snapshot.connectionState ==
                                                    ConnectionState.done &&
                                                snapshot.hasData) {
                                              return Container(
                                                  width: 100,
                                                  height: 100,
                                                  child: Image.network(
                                                    snapshot.data!,
                                                    fit: BoxFit.cover,
                                                  ));
                                            }

                                            return Container();
                                          }),
                                      TextButton(
                                          child: Text('I found it'),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: ((context) =>
                                                        foundit(
                                                            data.docs[index]
                                                                ['name'],
                                                            data.docs[index]
                                                                ['email']))));
                                          })
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
