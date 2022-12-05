import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lostfound/screens/fouropts/feedFound.dart';
import 'package:lostfound/screens/fouropts/feedLost.dart';

import 'package:lostfound/services/auth.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class claim extends StatefulWidget {
  final String lostname;
  final String email;

  claim(this.lostname, this.email);

  @override
  State<claim> createState() => _claimState();
}

class _claimState extends State<claim> {
  Future MailFeedback(namelost, namefound, phone, message, toemail) async {
    final service_id = 'service_3xeoz18';
    final template_id = 'template_mlq40qh';
    final user_id = 'cLDlGzXV7KUYB0tuc';
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

    final response = await http.post(url,
        headers: {
          'origin': 'http://localhost',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'service_id': service_id,
          'template_id': template_id,
          'user_id': user_id,
          'template_params': {
            'to_name': namelost,
            'user_name': namefound,
            'user_phone': phone,
            'user_message': message,
            'to_email': toemail,
          }
        }));
  }

  String name = "";
  String phone = "";
  String message = "";
  final _formKey = GlobalKey<FormState>();
  final Stream<QuerySnapshot> objects =
      FirebaseFirestore.instance.collection('found').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        title: Text('Enter your details'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              Form(
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
                      SizedBox(height: 20.0),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => feedFound())));
                            MailFeedback(widget.lostname, name, phone, message,
                                widget.email);
                          },
                          child: Text('Submit'),
                        ),
                      )
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
