import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:habini/components.dart';
import 'package:habini/streams/comments_stream.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habini/screens/add_post_screen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:google_fonts/google_fonts.dart';
import 'save_user_data.dart';

final _auth = FirebaseAuth.instance;
final _firebase = FirebaseFirestore.instance;
Color UniformColor = Color.fromRGBO(60, 174, 163, 1);
User logedInUser;

int NumberOfComments = 0;

class CommentsScreen extends StatefulWidget {
  final postContent;
  final numberOfComments;
  final postVotes;
  final postId;
  final date;
  String poster;

  CommentsScreen({
    this.poster,
    this.date,
    this.postId,
    this.postContent,
    this.postVotes,
    this.numberOfComments,
  });

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  String commentContent = null;
  int commentVotes = 0;
  @override
  TextEditingController inputcontroller = new TextEditingController();
  List<Widget> Comments = [];

  final commentTextController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    getCommentsNumber();
    countComments();
  }

  Future<int> countComments() async {
    QuerySnapshot _myDoc = await _firebase
        .collection('Posts')
        .doc(widget.postId)
        .collection('Comments')
        .get();
    List<DocumentSnapshot> _myCommentsCount = _myDoc.docs;
    return _myCommentsCount.length;
  }

  void getCommentsNumber() {
    countComments().then((value) {
      setState(() {
        _firebase
            .collection('Posts')
            .doc(widget.postId)
            .update({'numOfComments': value});
      });
      setState(() {
        NumberOfComments = value;
      });
    });
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

  Widget build(BuildContext context) {
    storeNotificationComments(){
      _firebase.collection('Notifications').doc().set({
        'to': widget.poster,
        'from': logedInUser.uid,
        'postId':widget.postId,
        'sentOn': FieldValue.serverTimestamp(),
        'content':'Someone Commented on your post',
      });
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // backgroundColor: Color.fromRGBO(60, 174, 163, 0),
      appBar: AppBar(
        backgroundColor: UniformColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            Icon(
              Icons.comment,
            ),
            SizedBox(
              width: 20.0,
            ),
            Text(
              'Comments',
              style: GoogleFonts.koHo(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        children: <Widget>[
          CurrentPost(
            poster: widget.poster,
            date: widget.date,
            content: widget.postContent.toString(),
            numberOfComments: widget.numberOfComments,
            votes: widget.postVotes,
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              cursorColor: Colors.black,
              controller: commentTextController,
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: UniformColor, width: 1.0),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      if (logedInUser == null) {
                        Alert(
                          context: context,
                          type: AlertType.error,
                          title: "Login Alert",
                          desc: "Please Login First",
                          buttons: [
                            DialogButton(
                              child: Text(
                                "close",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              width: 120,
                            )
                          ],
                        ).show();
                      }
                      if (commentContent == null ||
                          commentContent.trim() == "") {
                      } else {
                        storeNotificationComments();
                        commentTextController.clear();
                        String id = _firebase
                            .collection('Posts')
                            .doc(widget.postId)
                            .collection('Comments')
                            .doc()
                            .id;
                        try {
                          _firebase
                              .collection('Posts')
                              .doc(widget.postId)
                              .collection('Comments')
                              .doc(id)
                              .set({
                            'content': commentContent.toString(),
                            'commenter': logedInUser.uid,
                            'sentOn': FieldValue.serverTimestamp(),
                            'votesNumber': commentVotes,
                            'commentId': id,
                            'postId': widget.postId,
                            'poster':widget.poster,
                          });
                          commentContent = null;
                        } catch (ex) {
                          Alert(
                            context: context,
                            type: AlertType.error,
                            title: "Connection error",
                            desc: "Please check your internet connection",
                            buttons: [
                              DialogButton(
                                child: Text(
                                  "Back",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () => Navigator.pop(context),
                                width: 120,
                              ),
                            ],
                          ).show();
                        }
                      }
                      sleep(Duration(milliseconds: 1000));
                      setState(() {
                        getCommentsNumber();
                      });
                    },
                    icon: Icon(
                      Icons.send,
                      color: UniformColor,
                    ),
                  ),
                  labelText: "add comment",
                  labelStyle: TextStyle(
                    color: UniformColor,
                  )),
              keyboardType: TextInputType.text,
              inputFormatters: null,
              onChanged: (value) {
                commentContent = value;
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Opacity(
            opacity: 0.5,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 0.5,
                color: Colors.black,
              ),
            ),
          ),
          CommentsStreamer(
            currentPostId: widget.postId,
          ),
        ],
      ),
    );
  }
}

class CurrentPost extends StatefulWidget {
  final poster;

  final String content;
  int votes = 0;
  final date;
  dynamic numberOfComments = NumberOfComments;
  int downCounter = 0;
  int upCounter = 0;

  CurrentPost({
    this.poster,
    this.content,
    this.votes,
    this.date,
    this.numberOfComments,
  });

  @override
  _CurrentPostState createState() => _CurrentPostState();
}

class _CurrentPostState extends State<CurrentPost> {
  @override
  bool downVote = false;
  bool upVote = false;

  getUserAvatar() {
    return StreamBuilder(
      stream: _firebase.collection('Users').doc(widget.poster).snapshots(),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 4), // changes position of shadow
          ),
        ],
      ),
      padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
      margin: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 5.0, left: 5.0),
                child: getUserAvatar(),
              ),
              Text(timeAgo(widget.date.toDate())),
            ],
          ),
          SizedBox(
            height: 9,
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
          SizedBox(
            height: 15,
          ),
          Container(
            padding: EdgeInsets.all(5.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.content,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
