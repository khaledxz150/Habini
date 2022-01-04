import 'package:habini/components.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habini/screens/navigation_page.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Color UniformColor = Color.fromRGBO(60, 174, 163, 1);

final _auth = FirebaseAuth.instance;

User logedIn;
var uid;
String exists = '';

final _firebase = FirebaseFirestore.instance;



class SaveUserData extends StatefulWidget {
  final userData;

  SaveUserData({
    this.userData,
  });

  @override
  _SaveUserDataState createState() => _SaveUserDataState();
}

class _SaveUserDataState extends State<SaveUserData> {


  void storeUserData() async {
    try {
      _firebase.collection('Users').doc(uid).set({
      'phoneNumber': logedIn.phoneNumber,
      'facility' :widget.userData.facilityId,
      'UID': logedIn.uid,
      'avatarUrl':
      'https://firebasestorage.googleapis.com/v0/b/abini-199cc.appspot.com/o/Avatars%2Fweb_hi_res_512.png?alt=media&token=07cfcead-28a4-400e-81c6-6c879139d26b',
      });
    } catch (e) {
      print(e);
    }
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        logedIn = user;
        uid = logedIn.uid;
      }
    } catch (e) {
      print(e);
    }
  }
  void initState() {
    super.initState();
    getCurrentUser();
    checkExist();
    print(exists);
  }

  Future<String> checkExist() async {
    try {
      await _firebase.doc("Users/$uid").get().then((doc) {
        if (doc.exists) {
          exists = 'Welcome Back';
          Future.delayed(const Duration(milliseconds: 3200), () {
            setState(() {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => MyBottomNavigationBar(),
                ),
                (route) => false,
              );
            });
          });
        } else {
          storeUserData();
          exists = 'Welcome to 5abini';
          Future.delayed(const Duration(milliseconds: 3200), () {
            setState(() {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => MyBottomNavigationBar(),
                ),
                (route) => false,
              );
            });
          });
        }
      });
      return exists;
    } catch (e) {
      return 'Welcome Back';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniformColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SpinKitWave(
              color: Colors.white,
              size: 50.0,
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 32.0,
                  fontFamily: 'Pacifico',
                ),
                child: AnimatedTextKit(
                  animatedTexts: [
                    FadeAnimatedText(
                      exists,
                      duration: Duration(milliseconds: 1500),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
