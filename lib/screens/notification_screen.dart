import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habini/streams/notifiacations_stream.dart';
import '../components.dart';

final _auth = FirebaseAuth.instance;
final _firebase = FirebaseFirestore.instance;
User logedInUser;

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        logedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }


  @override
  Widget build(BuildContext context) {
    final date = DateTime(2021, 5, 22, 20, 28);
    final date2 = DateTime.now();
    final difference = date2.difference(date).inDays;
    return Scaffold(
      backgroundColor: Color.fromRGBO(60, 174, 163, 0.1),
      appBar: AppBar(
        backgroundColor: UniformColor,
        title: Row(
          children: [
            Icon(
              Icons.notifications,
            ),
            SizedBox(
              width: 20.0,
            ),
            Text(
              'Notifications ',
              style: GoogleFonts.koHo(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          NotificationStream(
            logedInUser:logedInUser ,
          ),
        ],
      )
    );
  }
}
