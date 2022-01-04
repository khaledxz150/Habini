import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habini/components.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:habini/screens/navigation_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

final _auth = FirebaseAuth.instance;
final _firebase = FirebaseFirestore.instance;

Color UniformColor = Color.fromRGBO(60, 174, 163, 1);
User logedInUser;
bool showSpinner = false;

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  @override
  int _defaultPostTime = 1;
  String _postContent = null;
  int numberOfComments = 0;
  int numberOfVotes = 0;
  int userFacility;

  final postTextController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    getUserFacility();
  }

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
  getUserFacility()async {
    await _firebase.collection('Users').doc(logedInUser.uid).get().then((value) {
      userFacility =  value.data()['facility'];
    });
  }

  Widget build(BuildContext context) {
    getUserAvatar() {
      return StreamBuilder(
        stream: _firebase.collection('Users').doc(logedInUser.uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          var userDocument = snapshot.data;
          return CircleAvatar(
            backgroundImage: NetworkImage(
              userDocument["avatarUrl"],
            ),
          );
        },
      );
    }



    return Scaffold(
      backgroundColor: Colors.white60,
      appBar: AppBar(
        backgroundColor: UniformColor,
        title: Row(
          children: [
            Icon(
              Icons.add,
            ),
            SizedBox(
              width: 20.0,
            ),
            Text(
              'Create Post',
              style: GoogleFonts.koHo(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.35,
            ),
          ],
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: ListView(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, left: 5.0),
                        child: getUserAvatar(),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextFormField(
                        controller: postTextController,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          hintText: 'whats on your mind?',
                          border: InputBorder.none,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        maxLines: null,
                        style: TextStyle(color: Colors.black),
                        cursorColor: Colors.black,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'[/\\]')),
                          LengthLimitingTextInputFormatter(170),
                        ],
                        onChanged: (value) {
                          _postContent = value;
                        }),
                  ),
                  Opacity(
                    opacity: 0.5,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 1,
                        height: 0.5,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text("Set post duration",
                  style: GoogleFonts.koHo(
                    fontSize: 25,
                    color: UniformColor,
                  )),
            ),
            NumberPicker(
                selectedTextStyle: TextStyle(
                  color: UniformColor,
                  fontSize: 30,
                ),
                value: _defaultPostTime,
                minValue: 1,
                maxValue: 24,
                itemHeight: 120,
                itemWidth: 120,
                onChanged: (value) => setState(() => _defaultPostTime = value),
                axis: Axis.horizontal,
                textStyle: GoogleFonts.koHo()),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Post duration: is $_defaultPostTime hours',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            Material(
              color: UniformColor,
              borderRadius: BorderRadius.circular(10.0),
              elevation: 5.0,
              child: MaterialButton(
                onPressed: () async {
                  getUserFacility();
                  setState(() {
                    showSpinner = true;
                  });
                  if (logedInUser == null) {
                    setState(() {
                      showSpinner = false;
                    });
                    Alert(
                      context: context,
                      type: AlertType.error,
                      title: "Login Alert",
                      desc: "Please Login First",
                      buttons: [
                        DialogButton(
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () => Navigator.pop(context),
                          width: 120,
                        )
                      ],
                    ).show();
                  }
                  if (_postContent == null || _postContent.trim() == "") {
                    setState(() {
                      showSpinner = false;
                    });
                    Alert(
                      context: context,
                      type: AlertType.warning,
                      title: "Post Alert",
                      desc: "Why so empty... ",
                      buttons: [
                        DialogButton(
                          child: Text(
                            "Back",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () => Navigator.pop(context),
                          width: 120,
                        ),
                      ],
                    ).show();
                  } else {
                    setState(() {
                      showSpinner = true;
                    });
                    postTextController.clear();

                    String id = _firebase.collection('Posts').doc().id;

                    try {
                      await _firebase.collection('Posts').doc(id).set({
                        'content': _postContent.toString(),
                        'poster': logedInUser.uid,
                        'sentOn': FieldValue.serverTimestamp(),
                        'numOfComments': numberOfComments,
                        'votesNumber': numberOfVotes,
                        'duration': _defaultPostTime,
                        'phoneNumber': logedInUser.phoneNumber,
                        'postId': id,
                        'PosterFacility':userFacility,
                      });
                      setState(() {
                        showSpinner = false;
                      });
                    } catch (ex) {
                      showSpinner = false;
                      Alert(
                        context: context,
                        type: AlertType.error,
                        title: "Connection error",
                        desc: "Please check your internet connection",
                        buttons: [
                          DialogButton(
                            child: Text(
                              "Back",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () => Navigator.pop(context),
                            width: 120,
                          ),
                        ],
                      ).show();
                    }
                  }
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      'navigation_page', (Route<dynamic> route) => false);
                },
                minWidth: 100,
                height: 42.0,
                child: Text('Post',
                    style: GoogleFonts.koHo(
                      fontSize: 20,
                      color: Colors.white,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
