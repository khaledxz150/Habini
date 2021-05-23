import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habini/screens/welcome_screen.dart';
import 'package:habini/components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habini/screens/comments_screen.dart';
import 'package:habini/streams/post_stream.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeIndex extends StatefulWidget {
  @override
  _HomeIndexState createState() => _HomeIndexState();
}

class _HomeIndexState extends State<HomeIndex> {
  @override
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: UniformColor,
          title: Row(
            children: [
              Icon(
                Icons.home,
              ),
              SizedBox(
                width: 20.0,
              ),
              Text(
                'Home',
                style: GoogleFonts.koHo(
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Color.fromRGBO(60, 174, 163, 0.1),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              PostStreamer(),
            ],
          ),
        ),
      ),
    );
  }
}
