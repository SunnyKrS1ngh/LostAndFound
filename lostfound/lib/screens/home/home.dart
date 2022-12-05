import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:lostfound/screens/authenticate/signIn.dart';
import 'package:lostfound/screens/fouropts/feedFound.dart';
import 'package:lostfound/screens/fouropts/feedLost.dart';
import 'package:lostfound/screens/fouropts/myposts.dart';
import 'package:lostfound/screens/fouropts/postFound.dart';
import 'package:lostfound/screens/fouropts/postLost.dart';
import 'package:lostfound/screens/fouropts/updatePass.dart';
import 'package:lostfound/services/auth.dart';

class home extends StatefulWidget {
  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  final authService _auth = authService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('LostFound'),
        backgroundColor: Colors.blue[300],
        elevation: 0.0,
        actions: <Widget>[
          ElevatedButton.icon(
            onPressed: () async {
              Navigator.push(
                  context, MaterialPageRoute(builder: ((context) => signin())));
              await _auth.signOut();
            },
            icon: Icon(Icons.person),
            label: Text('logout'),
            style: ButtonStyle(
                backgroundColor:
                    MaterialStatePropertyAll<Color>(Colors.redAccent)),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 80.0),
        child: Column(
          children: <Widget>[
            Text(
              'Welcome!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 20),
            OutlinedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll<Color>(Colors.redAccent)),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: ((context) => postLost())));
              },
              child: Text(
                'Post for lost items',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 10.0),
            OutlinedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll<Color>(Colors.redAccent)),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: ((context) => postFound())));
              },
              child: Text(
                'Post for found items',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 10.0),
            OutlinedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStatePropertyAll<Color>(Colors.redAccent),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: ((context) => feedLost())));
              },
              child: Text(
                'Feed for lost items',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 10.0),
            OutlinedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll<Color>(Colors.redAccent)),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: ((context) => feedFound())));
              },
              child: Text(
                'Feed for found items',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 10.0),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: ((context) => post())));
              },
              icon: Icon(Icons.person),
              label: Text('My Posts'),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll<Color>(Colors.redAccent)),
            ),
            SizedBox(height: 10.0),
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.push(context,
                    MaterialPageRoute(builder: ((context) => updatePass())));
              },
              icon: Icon(Icons.password),
              label: Text('Update Password'),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll<Color>(Colors.redAccent)),
            ),
          ],
        ),
      ),
    );
    ;
  }
}
