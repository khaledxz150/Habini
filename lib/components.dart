import 'package:flutter/material.dart';
import 'package:habini/screens/comments_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habini/screens/profile_screen.dart';
import 'package:habini/screens/save_user_data.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:habini/screens/navigation_page.dart';
import 'package:habini/screens/profile_screen.dart';

final _auth = FirebaseAuth.instance;
final _firebase = FirebaseFirestore.instance;
String reportContent = null;
final reportTextController = TextEditingController();
final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

User logedInUser;
Color UniformColor = Color.fromRGBO(60, 174, 163, 1);

class KTextField extends StatelessWidget {
  KTextField(
      {this.labelText,
      this.keyBordType,
      this.inputFormatters,
      this.hidden,
      this.icon,
      this.onChange,
      this.validator,
      this.cursorColor,
      this.labelStyle});

  final labelText;
  final keyBordType;
  final inputFormatters;
  final hidden;
  final icon;
  final onChange;
  final validator;
  final labelStyle;
  final cursorColor;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: cursorColor,
      obscureText: hidden,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: UniformColor, width: 1.0),
          borderRadius: BorderRadius.all(
            Radius.circular(90.0),
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(90.0),
          ),
          borderSide: BorderSide(color: UniformColor, width: 0.5),
        ),
        prefixIcon: icon,
        labelText: labelText,
        labelStyle: labelStyle,
      ),
      keyboardType: keyBordType,
      inputFormatters: inputFormatters,
      onChanged: onChange,
      validator: validator,
    );
  }
}

String timeAgo(DateTime d) {
  Duration diff = DateTime.now().difference(d);
  if (diff.inDays > 365)
    return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} ago";
  if (diff.inDays > 30)
    return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} ago";
  if (diff.inDays > 7)
    return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
  if (diff.inDays > 0)
    return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago";
  if (diff.inHours > 0)
    return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago";
  if (diff.inMinutes > 0)
    return "${diff.inMinutes} ${diff.inMinutes == 1 ? "min" : "min"} ago";
  return "just now";
}

class KmaterialButton extends StatelessWidget {
  KmaterialButton({this.onPressed, this.label, this.color});

  final onPressed;
  final label;
  final color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(30.0),
      elevation: 5.0,
      child: MaterialButton(
        onPressed: onPressed,
        minWidth: 200.0,
        height: 42.0,
        child: Text(
          label,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class KPostContainer extends StatefulWidget {
  final String content;
  int votes = 0;
  final date;
  int numberOfComments = 0;
  int downCounter = 0;
  int upCounter = 0;
  final postId;
  final bool isMe;
  final poster;

  KPostContainer({
    this.isMe,
    this.postId,
    this.content,
    this.votes,
    this.date,
    this.numberOfComments,
    this.poster,
  });

  @override
  _KPostContainerState createState() => _KPostContainerState();
}

class _KPostContainerState extends State<KPostContainer> {
  @override
  bool downVote = false;
  bool upVote = false;
  String reportContent = null;
  bool isVoted;
  int userName = 0;

  bool showSpinner = false;
  final _firebase = FirebaseFirestore.instance;
  User logedInUser;

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  final reportTextController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    getData();
    checkIfLikedOrNot();
  }

  getData() async {
    DocumentSnapshot votes = await _firebase
        .collection('Posts')
        .doc(widget.postId)
        .collection('Voters')
        .doc(logedInUser.uid)
        .get();
    setState(() {
      downVote = votes['downVote'];
      upVote = votes['upVote'];
    });
  }

  checkIfLikedOrNot() async {
    DocumentSnapshot ds = await _firebase
        .collection("Posts")
        .doc(widget.postId)
        .collection('Voters')
        .doc(logedInUser.uid)
        .get();
    setState(() {
      isVoted = ds.exists;
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

  void updateVotesNumber() {
    setState(() {
      _firebase
          .collection('Posts')
          .doc(widget.postId)
          .update({'votesNumber': widget.votes});
    });
  }

  void saveVoter() {
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
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            width: 120,
          )
        ],
      ).show();
    } else {
      try {
        _firebase
            .collection('Posts')
            .doc(widget.postId)
            .collection('Voters')
            .doc(logedInUser.uid)
            .set({
          'downVote': downVote,
          'upVote': upVote,
          'sentOn': FieldValue.serverTimestamp(),
        });
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
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            ),
          ],
        ).show();
      }
    }
    if (upVote == false && downVote == false) {
      _firebase
          .collection('Posts')
          .doc(widget.postId)
          .collection('Voters')
          .doc(logedInUser.uid)
          .delete();
    }
  }

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
  Future<void> getUserName() async {
    DocumentSnapshot snapshot =
    await _firebase.collection('Users').doc(widget.poster).get();
    userName = await snapshot['userName'];
  }

  @override
  Widget build(BuildContext context) {
    getUserName();
    getData();
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
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0, left: 5.0),
                    child: getUserAvatar(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0, left: 10.0),
                    child: Container(
                      child: Text(
                        userName.toString(),
                        style: TextStyle(
                          fontSize: 19,),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12, top: 6),
                    child: Text(
                      'Me',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <
                  Widget>[
                Text(
                  timeAgo(widget.date.toDate()),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Container(
                    width: 40,
                    child: DropdownButton(
                      isExpanded: true,
                      items: [
                        'Delete',
                      ].map((String value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (_) {
                        Alert(
                          context: context,
                          type: AlertType.warning,
                          title: "Delete your post",
                          desc: "are you sure you want to delete your post ?",
                          buttons: [
                            DialogButton(
                              child: Text(
                                "Yes",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () async {
                                await _firebase
                                    .collection('Notifications')
                                    .where('postId', isEqualTo: widget.postId)
                                    .get()
                                    .then((snapshot) {
                                  for (DocumentSnapshot ds in snapshot.docs) {
                                    ds.reference.delete();
                                  }
                                });

                                try {
                                  await _firebase
                                      .collection('Posts')
                                      .doc(widget.postId)
                                      .collection('Voters')
                                      .get()
                                      .then(
                                    (snapshot) {
                                      for (DocumentSnapshot ds
                                          in snapshot.docs) {
                                        ds.reference.delete();
                                      }
                                    },
                                  );
                                  await _firebase
                                      .collection('Posts')
                                      .doc(widget.postId)
                                      .collection('Comments')
                                      .get()
                                      .then(
                                    (snapshot) {
                                      for (DocumentSnapshot ds
                                          in snapshot.docs) {
                                        ds.reference.delete();
                                      }
                                    },
                                  );
                                  await _firebase
                                      .collection('Posts')
                                      .doc(widget.postId)
                                      .delete();
                                } catch (e) {
                                  print(e);
                                }
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ProfilePage(),
                                  ),
                                  (route) => false,
                                );
                              },
                              color: Color.fromRGBO(0, 179, 134, 1.0),
                            ),
                          ],
                        ).show();
                      },
                    ),
                  ),
                ),
              ])
            ],
          ),
          SizedBox(
            height: 15,
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
                style: TextStyle(fontSize: 15.5),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Row(
                  children: [
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_drop_up,
                            color: upVote ? UniformColor : Colors.black,
                          ),
                          tooltip: 'Up vote',
                          iconSize: 30,
                          onPressed: () {
                            setState(() {
                              if (upVote == true) {
                                widget.votes--;
                                upVote = false;
                              } else {
                                if (downVote == true) {
                                  widget.votes++;
                                  downVote = false;
                                }
                                widget.votes++;
                                upVote = true;
                              }
                              updateVotesNumber();
                            });
                            saveVoter();
                          },
                        ),
                        Text(
                          widget.votes.toString(),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: downVote ? UniformColor : Colors.black,
                          ),
                          tooltip: 'Down vote',
                          iconSize: 30,
                          onPressed: () {
                            setState(() {
                              if (downVote == true) {
                                widget.votes++;
                                downVote = false;
                              } else {
                                if (upVote == true) {
                                  widget.votes--;
                                  upVote = false;
                                }
                                //downCounter = 1;
                                widget.votes--;
                                downVote = true;
                              }
                              updateVotesNumber();
                            });
                            saveVoter();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12.0, bottom: 3.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.comment),
                      tooltip: 'Comment',
                      iconSize: 28,
                      onPressed: () {
                        setState(() {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CommentsScreen(
                                postId: widget.postId,
                                postContent: widget.content,
                                postVotes: widget.votes,
                                numberOfComments: widget.numberOfComments,
                                date: widget.date,
                                poster: widget.poster,
                              ),
                            ),
                          );
                        });
                      },
                    ),
                    Text(
                      widget.numberOfComments.toString(),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class KComment extends StatefulWidget {
  final String content;
  int votes = 0;
  Timestamp date;
  int downCounter = 0;
  int upCounter = 0;
  int numberOfComments = 0;
  final postId;
  final commentId;
  final commenter;
  bool downVote = false;
  bool upVote = false;
  final poster;

  KComment({
    this.poster,
    this.upVote,
    this.downVote,
    this.commentId,
    this.postId,
    this.votes,
    this.date,
    this.content,
    this.commenter,
  });

  @override
  _KCommentState createState() => _KCommentState();
}

class _KCommentState extends State<KComment> {
  @override
  bool isVoted;
  int userName = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    getData();
    checkIfLikedOrNot();
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

  getData() async {
    DocumentSnapshot votes = await _firebase
        .collection('Posts')
        .doc(widget.postId)
        .collection('Comments')
        .doc(widget.commentId)
        .collection('Voters')
        .doc(logedInUser.uid)
        .get();
    setState(() {
      widget.downVote = votes['downVote'];
      widget.upVote = votes['upVote'];
    });
  }

  checkIfLikedOrNot() async {
    DocumentSnapshot ds = await _firebase
        .collection("Posts")
        .doc(widget.postId)
        .collection('Voters')
        .doc(logedInUser.uid)
        .get();
    setState(() {
      isVoted = ds.exists;
    });
  }

  void saveVoter() {
    try {
      _firebase
          .collection('Posts')
          .doc(widget.postId)
          .collection('Comments')
          .doc(widget.commentId)
          .collection('Voters')
          .doc(logedInUser.uid)
          .set({
        'downVote': widget.downVote,
        'upVote': widget.upVote,
        'sentOn': FieldValue.serverTimestamp(),
      });
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
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
          ),
        ],
      ).show();
    }

    if (widget.upVote == false && widget.downVote == false) {
      _firebase
          .collection('Posts')
          .doc(widget.postId)
          .collection('Comments')
          .doc(widget.commentId)
          .collection('Voters')
          .doc(logedInUser.uid)
          .delete();
    }
  }

  void updateVotesNumber() {
    setState(() {
      _firebase
          .collection('Posts')
          .doc(widget.postId)
          .collection('Comments')
          .doc(widget.commentId)
          .update({'votesNumber': widget.votes});
    });
  }

  getUserAvatar() {
    return StreamBuilder(
      stream: _firebase.collection('Users').doc(widget.commenter).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        var userDocument = snapshot.data;
        return CircleAvatar(
          radius: 16,
          backgroundImage: NetworkImage(
            userDocument["avatarUrl"],
          ),
        );
      },
    );
  }


  Widget build(BuildContext context) {

    Future<void> getUserName() async {
      DocumentSnapshot snapshot =
      await _firebase.collection('Users').doc(widget.commenter).get();
      userName = await snapshot['userName'];
    }

    var dropDownValue;
    setState(() {
      getData();
    });
    getUserName();

    if (logedInUser.uid == widget.poster && widget.poster == widget.commenter) {
      return Container(
        padding: EdgeInsets.all(10),
        color: Colors.grey[200],
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, left: 5.0),
                      child: getUserAvatar(),
                    ),Padding(
                      padding: const EdgeInsets.only(top: 5.0, left: 10.0),
                      child: Container(
                        child: Text(
                          userName.toString(),
                          style: TextStyle(
                            fontSize: 19,),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12, top: 6),
                      child: Text(
                        'Me',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Raleway',
                            color: Colors.red),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      timeAgo(
                        widget.date.toDate(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
                        width: 40,
                        child: DropdownButton(
                          value: dropDownValue,
                          isExpanded: true,
                          items: ['Delete', 'Report'].map((String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) async {
                            setState(() {
                              dropDownValue = newValue;
                            });
                            if (newValue == "Delete") {
                              await _firebase
                                  .collection('Notifications')
                                  .where('postId', isEqualTo: widget.postId)
                                  .get()
                                  .then((snapshot) {
                                for (DocumentSnapshot ds in snapshot.docs) {
                                  ds.reference.delete();
                                }
                              });
                              try {
                                await _firebase
                                    .collection('Posts')
                                    .doc(widget.postId)
                                    .collection('Comments')
                                    .doc(widget.commentId)
                                    .collection('Voters')
                                    .get()
                                    .then(
                                  (snapshot) {
                                    for (DocumentSnapshot ds in snapshot.docs) {
                                      ds.reference.delete();
                                    }
                                  },
                                );
                                await _firebase
                                    .collection('Posts')
                                    .doc(widget.postId)
                                    .collection('Comments')
                                    .doc(widget.commentId)
                                    .delete();
                              } catch (e) {
                                print(e);
                              }
                            } else if (newValue == "Report") {
                              Alert(
                                context: context,
                                title: "Report",
                                content: Column(
                                  children: <Widget>[
                                    TextField(
                                      decoration: InputDecoration(
                                        icon: Icon(
                                          Icons.warning,
                                          color: UniformColor,
                                        ),
                                        labelText: 'Describe the problem',
                                        labelStyle: TextStyle(
                                          color: UniformColor,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: UniformColor, width: 1.0),
                                        ),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          reportContent = value;
                                        });
                                      },
                                      controller: reportTextController,
                                    ),
                                  ],
                                ),
                                buttons: [
                                  DialogButton(
                                    child: Text(
                                      "Submit",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    onPressed: () {
                                      if (reportContent == null) {
                                        print("is null");
                                      } else {
                                        reportTextController.clear();
                                        try {
                                          _firebase
                                              .collection('CommentsReports')
                                              .doc()
                                              .set({
                                            'Report': reportContent,
                                            'Reporter': logedInUser.uid,
                                            'sentOn':
                                                FieldValue.serverTimestamp(),
                                            'commentId': widget.postId,
                                            'postId': widget.postId,
                                          });

                                          reportContent = null;
                                        } catch (e) {
                                          print(e);
                                        }
                                        FocusScope.of(context).unfocus();
                                        _scaffoldkey.currentState.showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Report Sent Successfully'),
                                          ),
                                        );
                                      }
                                    },
                                    width: 120,
                                    color: UniformColor,
                                  )
                                ],
                              ).show();
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        widget.content,
                        style: TextStyle(fontSize: 15),
                        softWrap: true,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_drop_up,
                    color: widget.upVote ? UniformColor : Colors.black,
                  ),
                  tooltip: 'Up vote',
                  iconSize: 30,
                  onPressed: () {
                    setState(() {
                      if (widget.upVote == true) {
                        widget.upCounter = 0;
                        widget.votes--;
                        widget.upVote = false;
                      } else {
                        if (widget.downCounter == 1) {
                          widget.votes++;
                          widget.downCounter = 0;
                        }
                        if (widget.downVote == true) {
                          widget.votes++;
                          widget.downVote = false;
                        }
                        widget.upCounter = 1;
                        widget.votes++;
                        widget.upVote = true;
                      }
                      updateVotesNumber();
                    });
                    saveVoter();
                  },
                ),
                Text(
                  widget.votes.toString(),
                ),
                IconButton(
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: widget.downVote ? UniformColor : Colors.black,
                  ),
                  tooltip: 'Down vote',
                  iconSize: 30,
                  onPressed: () {
                    setState(() {
                      if (widget.downVote == true) {
                        widget.downCounter = 0;
                        widget.votes++;
                        widget.downVote = false;
                      } else {
                        if (widget.upCounter == 1) {
                          widget.votes--;
                          widget.upCounter = 0;
                        }
                        if (widget.upVote == true) {
                          widget.votes--;
                          widget.upVote = false;
                        }
                        widget.downCounter = 1;
                        widget.votes--;
                        widget.downVote = true;
                      }
                      updateVotesNumber();
                    });
                    saveVoter();
                  },
                ),
              ],
            ),
            Opacity(
              opacity: 0.5,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 1,
                  height: 1,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      );
    } else if (logedInUser.uid == widget.commenter) {
      return Container(
        padding: EdgeInsets.all(10),
        color: Colors.grey[200],
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, left: 5.0),
                      child: getUserAvatar(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, left: 10.0),
                      child: Container(
                        child: Text(
                          userName.toString(),
                          style: TextStyle(
                            fontSize: 19,),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12, top: 6),
                      child: Text(
                        'Me',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Raleway',
                            color: Colors.red),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      timeAgo(
                        widget.date.toDate(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
                        width: 40,
                        child: DropdownButton(
                          value: dropDownValue,
                          isExpanded: true,
                          items: ['Delete', 'Report'].map((String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) async {
                            setState(() {
                              dropDownValue = newValue;
                            });
                            if (newValue == "Delete") {
                              try {
                                await _firebase
                                    .collection('Posts')
                                    .doc(widget.postId)
                                    .collection('Comments')
                                    .doc(widget.commentId)
                                    .collection('Voters')
                                    .get()
                                    .then(
                                  (snapshot) {
                                    for (DocumentSnapshot ds in snapshot.docs) {
                                      ds.reference.delete();
                                    }
                                  },
                                );
                                await _firebase
                                    .collection('Posts')
                                    .doc(widget.postId)
                                    .collection('Comments')
                                    .doc(widget.commentId)
                                    .delete();
                              } catch (e) {
                                print(e);
                              }
                            } else if (newValue == "Report") {
                              Alert(
                                context: context,
                                title: "Report",
                                content: Column(
                                  children: <Widget>[
                                    TextField(
                                      decoration: InputDecoration(
                                        icon: Icon(
                                          Icons.warning,
                                          color: UniformColor,
                                        ),
                                        labelText: 'Describe the problem',
                                        labelStyle: TextStyle(
                                          color: UniformColor,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: UniformColor, width: 1.0),
                                        ),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          reportContent = value;
                                        });
                                      },
                                      controller: reportTextController,
                                    ),
                                  ],
                                ),
                                buttons: [
                                  DialogButton(
                                    child: Text(
                                      "Submit",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    onPressed: () {
                                      if (reportContent == null) {
                                        print("is null");
                                      } else {
                                        reportTextController.clear();
                                        try {
                                          _firebase
                                              .collection('CommentsReports')
                                              .doc()
                                              .set({
                                            'Report': reportContent,
                                            'Reporter': logedInUser.uid,
                                            'sentOn':
                                                FieldValue.serverTimestamp(),
                                            'commentId': widget.postId,
                                            'postId': widget.postId,
                                          });

                                          reportContent = null;
                                        } catch (e) {
                                          print(e);
                                        }
                                        FocusScope.of(context).unfocus();
                                        _scaffoldkey.currentState.showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Report Sent Successfully'),
                                          ),
                                        );
                                      }
                                    },
                                    width: 120,
                                    color: UniformColor,
                                  )
                                ],
                              ).show();
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        widget.content,
                        style: TextStyle(fontSize: 15),
                        softWrap: true,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_drop_up,
                    color: widget.upVote ? UniformColor : Colors.black,
                  ),
                  tooltip: 'Up vote',
                  iconSize: 30,
                  onPressed: () {
                    setState(() {
                      if (widget.upVote == true) {
                        widget.upCounter = 0;
                        widget.votes--;
                        widget.upVote = false;
                      } else {
                        if (widget.downCounter == 1) {
                          widget.votes++;
                          widget.downCounter = 0;
                        }
                        if (widget.downVote == true) {
                          widget.votes++;
                          widget.downVote = false;
                        }
                        widget.upCounter = 1;
                        widget.votes++;
                        widget.upVote = true;
                      }
                      updateVotesNumber();
                    });
                    saveVoter();
                  },
                ),
                Text(
                  widget.votes.toString(),
                ),
                IconButton(
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: widget.downVote ? UniformColor : Colors.black,
                  ),
                  tooltip: 'Down vote',
                  iconSize: 30,
                  onPressed: () {
                    setState(() {
                      if (widget.downVote == true) {
                        widget.downCounter = 0;
                        widget.votes++;
                        widget.downVote = false;
                      } else {
                        if (widget.upCounter == 1) {
                          widget.votes--;
                          widget.upCounter = 0;
                        }
                        if (widget.upVote == true) {
                          widget.votes--;
                          widget.upVote = false;
                        }
                        widget.downCounter = 1;
                        widget.votes--;
                        widget.downVote = true;
                      }
                      updateVotesNumber();
                    });
                    saveVoter();
                  },
                ),
              ],
            ),
            Opacity(
              opacity: 0.5,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 1,
                  height: 1,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      );
    } else if (logedInUser.uid == widget.poster &&
        widget.poster != widget.commenter) {
      return Container(
        padding: EdgeInsets.all(10),
        color: Colors.grey[200],
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, left: 5.0),
                      child: getUserAvatar(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, left: 10.0),
                      child: Container(
                        child: Text(
                          userName.toString(),
                          style: TextStyle(
                            fontSize: 19,),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      timeAgo(
                        widget.date.toDate(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
                        width: 40,
                        child: DropdownButton(
                          value: dropDownValue,
                          isExpanded: true,
                          items: ['Delete', 'Report'].map((String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) async {
                            setState(() {
                              dropDownValue = newValue;
                            });
                            if (newValue == "Delete") {
                              try {
                                await _firebase
                                    .collection('Posts')
                                    .doc(widget.postId)
                                    .collection('Comments')
                                    .doc(widget.commentId)
                                    .collection('Voters')
                                    .get()
                                    .then(
                                  (snapshot) {
                                    for (DocumentSnapshot ds in snapshot.docs) {
                                      ds.reference.delete();
                                    }
                                  },
                                );
                                await _firebase
                                    .collection('Posts')
                                    .doc(widget.postId)
                                    .collection('Comments')
                                    .doc(widget.commentId)
                                    .delete();
                              } catch (e) {
                                print(e);
                              }
                            } else if (newValue == "Report") {
                              Alert(
                                context: context,
                                title: "Report",
                                content: Column(
                                  children: <Widget>[
                                    TextField(
                                      decoration: InputDecoration(
                                        icon: Icon(
                                          Icons.warning,
                                          color: UniformColor,
                                        ),
                                        labelText: 'Describe the problem',
                                        labelStyle: TextStyle(
                                          color: UniformColor,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: UniformColor, width: 1.0),
                                        ),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          reportContent = value;
                                        });
                                      },
                                      controller: reportTextController,
                                    ),
                                  ],
                                ),
                                buttons: [
                                  DialogButton(
                                    child: Text(
                                      "Submit",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    onPressed: () {
                                      if (reportContent == null) {
                                        print("is null");
                                      } else {
                                        reportTextController.clear();
                                        try {
                                          _firebase
                                              .collection('CommentsReports')
                                              .doc()
                                              .set({
                                            'Report': reportContent,
                                            'Reporter': logedInUser.uid,
                                            'sentOn':
                                                FieldValue.serverTimestamp(),
                                            'commentId': widget.postId,
                                            'postId': widget.postId,
                                          });

                                          reportContent = null;
                                        } catch (e) {
                                          print(e);
                                        }
                                        FocusScope.of(context).unfocus();
                                        _scaffoldkey.currentState.showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Report Sent Successfully'),
                                          ),
                                        );
                                      }
                                    },
                                    width: 120,
                                    color: UniformColor,
                                  )
                                ],
                              ).show();
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        widget.content,
                        style: TextStyle(fontSize: 15),
                        softWrap: true,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_drop_up,
                    color: widget.upVote ? UniformColor : Colors.black,
                  ),
                  tooltip: 'Up vote',
                  iconSize: 30,
                  onPressed: () {
                    setState(() {
                      if (widget.upVote == true) {
                        widget.upCounter = 0;
                        widget.votes--;
                        widget.upVote = false;
                      } else {
                        if (widget.downCounter == 1) {
                          widget.votes++;
                          widget.downCounter = 0;
                        }
                        if (widget.downVote == true) {
                          widget.votes++;
                          widget.downVote = false;
                        }
                        widget.upCounter = 1;
                        widget.votes++;
                        widget.upVote = true;
                      }
                      updateVotesNumber();
                    });
                    saveVoter();
                  },
                ),
                Text(
                  widget.votes.toString(),
                ),
                IconButton(
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: widget.downVote ? UniformColor : Colors.black,
                  ),
                  tooltip: 'Down vote',
                  iconSize: 30,
                  onPressed: () {
                    setState(() {
                      if (widget.downVote == true) {
                        widget.downCounter = 0;
                        widget.votes++;
                        widget.downVote = false;
                      } else {
                        if (widget.upCounter == 1) {
                          widget.votes--;
                          widget.upCounter = 0;
                        }
                        if (widget.upVote == true) {
                          widget.votes--;
                          widget.upVote = false;
                        }
                        widget.downCounter = 1;
                        widget.votes--;
                        widget.downVote = true;
                      }
                      updateVotesNumber();
                    });
                    saveVoter();
                  },
                ),
              ],
            ),
            Opacity(
              opacity: 0.5,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 1,
                  height: 1,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      );
    }
     else if (widget.poster == widget.commenter&&logedInUser.uid!=widget.poster) {
      return Container(
        padding: EdgeInsets.all(10),
        color: Colors.grey[200],
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, left: 5.0),
                      child: getUserAvatar(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, left: 10.0),
                      child: Container(
                        child: Text(
                          userName.toString(),
                          style: TextStyle(
                            fontSize: 19,),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12, top: 6),
                      child: Text(
                        'Owner',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Raleway',
                            color: Colors.black),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      timeAgo(
                        widget.date.toDate(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
                        width: 40,
                        child: DropdownButton(
                          value: dropDownValue,
                          isExpanded: true,
                          items: ['Delete', 'Report'].map((String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) async {
                            setState(() {
                              dropDownValue = newValue;
                            });
                            if (newValue == "Delete") {
                              await _firebase
                                  .collection('Notifications')
                                  .where('postId', isEqualTo: widget.postId)
                                  .get()
                                  .then((snapshot) {
                                for (DocumentSnapshot ds in snapshot.docs) {
                                  ds.reference.delete();
                                }
                              });
                              try {
                                await _firebase
                                    .collection('Posts')
                                    .doc(widget.postId)
                                    .collection('Comments')
                                    .doc(widget.commentId)
                                    .collection('Voters')
                                    .get()
                                    .then(
                                  (snapshot) {
                                    for (DocumentSnapshot ds in snapshot.docs) {
                                      ds.reference.delete();
                                    }
                                  },
                                );
                                await _firebase
                                    .collection('Posts')
                                    .doc(widget.postId)
                                    .collection('Comments')
                                    .doc(widget.commentId)
                                    .delete();
                              } catch (e) {
                                print(e);
                              }
                            } else if (newValue == "Report") {
                              Alert(
                                context: context,
                                title: "Report",
                                content: Column(
                                  children: <Widget>[
                                    TextField(
                                      decoration: InputDecoration(
                                        icon: Icon(
                                          Icons.warning,
                                          color: UniformColor,
                                        ),
                                        labelText: 'Describe the problem',
                                        labelStyle: TextStyle(
                                          color: UniformColor,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: UniformColor, width: 1.0),
                                        ),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          reportContent = value;
                                        });
                                      },
                                      controller: reportTextController,
                                    ),
                                  ],
                                ),
                                buttons: [
                                  DialogButton(
                                    child: Text(
                                      "Submit",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    onPressed: () {
                                      if (reportContent == null) {
                                        print("is null");
                                      } else {
                                        reportTextController.clear();
                                        try {
                                          _firebase
                                              .collection('CommentsReports')
                                              .doc()
                                              .set({
                                            'Report': reportContent,
                                            'Reporter': logedInUser.uid,
                                            'sentOn':
                                                FieldValue.serverTimestamp(),
                                            'commentId': widget.postId,
                                            'postId': widget.postId,
                                          });

                                          reportContent = null;
                                        } catch (e) {
                                          print(e);
                                        }
                                        FocusScope.of(context).unfocus();
                                        _scaffoldkey.currentState.showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Report Sent Successfully'),
                                          ),
                                        );
                                      }
                                    },
                                    width: 120,
                                    color: UniformColor,
                                  )
                                ],
                              ).show();
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        widget.content,
                        style: TextStyle(fontSize: 15),
                        softWrap: true,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_drop_up,
                    color: widget.upVote ? UniformColor : Colors.black,
                  ),
                  tooltip: 'Up vote',
                  iconSize: 30,
                  onPressed: () {
                    setState(() {
                      if (widget.upVote == true) {
                        widget.upCounter = 0;
                        widget.votes--;
                        widget.upVote = false;
                      } else {
                        if (widget.downCounter == 1) {
                          widget.votes++;
                          widget.downCounter = 0;
                        }
                        if (widget.downVote == true) {
                          widget.votes++;
                          widget.downVote = false;
                        }
                        widget.upCounter = 1;
                        widget.votes++;
                        widget.upVote = true;
                      }
                      updateVotesNumber();
                    });
                    saveVoter();
                  },
                ),
                Text(
                  widget.votes.toString(),
                ),
                IconButton(
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: widget.downVote ? UniformColor : Colors.black,
                  ),
                  tooltip: 'Down vote',
                  iconSize: 30,
                  onPressed: () {
                    setState(() {
                      if (widget.downVote == true) {
                        widget.downCounter = 0;
                        widget.votes++;
                        widget.downVote = false;
                      } else {
                        if (widget.upCounter == 1) {
                          widget.votes--;
                          widget.upCounter = 0;
                        }
                        if (widget.upVote == true) {
                          widget.votes--;
                          widget.upVote = false;
                        }
                        widget.downCounter = 1;
                        widget.votes--;
                        widget.downVote = true;
                      }
                      updateVotesNumber();
                    });
                    saveVoter();
                  },
                ),
              ],
            ),
            Opacity(
              opacity: 0.5,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 1,
                  height: 1,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(10),
        color: Colors.grey[200],
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, left: 5.0),
                      child: getUserAvatar(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, left: 10.0),
                      child: Container(
                        child: Text(
                          userName.toString(),
                          style: TextStyle(
                            fontSize: 19,),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      timeAgo(
                        widget.date.toDate(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
                        width: 40,
                        child: DropdownButton(
                          value: dropDownValue,
                          isExpanded: true,
                          items: ['Report'].map((String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) async {
                            setState(() {
                              dropDownValue = newValue;
                            });
                            if (newValue == "Report") {
                              Alert(
                                context: context,
                                title: "Report",
                                content: Column(
                                  children: <Widget>[
                                    TextField(
                                      decoration: InputDecoration(
                                        icon: Icon(
                                          Icons.warning,
                                          color: UniformColor,
                                        ),
                                        labelText: 'Describe the problem',
                                        labelStyle: TextStyle(
                                          color: UniformColor,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: UniformColor, width: 1.0),
                                        ),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          reportContent = value;
                                        });
                                      },
                                      controller: reportTextController,
                                    ),
                                  ],
                                ),
                                buttons: [
                                  DialogButton(
                                    child: Text(
                                      "Submit",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    onPressed: () {
                                      if (reportContent == null) {
                                        print("is null");
                                      } else {
                                        reportTextController.clear();
                                        try {
                                          _firebase
                                              .collection('CommentsReports')
                                              .doc()
                                              .set({
                                            'Report': reportContent,
                                            'Reporter': logedInUser.uid,
                                            'sentOn':
                                                FieldValue.serverTimestamp(),
                                            'commentId': widget.postId,
                                            'postId': widget.postId,
                                          });

                                          reportContent = null;
                                        } catch (e) {
                                          print(e);
                                        }
                                        FocusScope.of(context).unfocus();
                                        _scaffoldkey.currentState.showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Report Sent Successfully'),
                                          ),
                                        );
                                      }
                                    },
                                    width: 120,
                                    color: UniformColor,
                                  )
                                ],
                              ).show();
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        widget.content,
                        style: TextStyle(fontSize: 15),
                        softWrap: true,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_drop_up,
                    color: widget.upVote ? UniformColor : Colors.black,
                  ),
                  tooltip: 'Up vote',
                  iconSize: 30,
                  onPressed: () {
                    setState(() {
                      if (widget.upVote == true) {
                        widget.upCounter = 0;
                        widget.votes--;
                        widget.upVote = false;
                      } else {
                        if (widget.downCounter == 1) {
                          widget.votes++;
                          widget.downCounter = 0;
                        }
                        if (widget.downVote == true) {
                          widget.votes++;
                          widget.downVote = false;
                        }
                        widget.upCounter = 1;
                        widget.votes++;
                        widget.upVote = true;
                      }
                      updateVotesNumber();
                    });
                    saveVoter();
                  },
                ),
                Text(
                  widget.votes.toString(),
                ),
                IconButton(
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: widget.downVote ? UniformColor : Colors.black,
                  ),
                  tooltip: 'Down vote',
                  iconSize: 30,
                  onPressed: () {
                    setState(() {
                      if (widget.downVote == true) {
                        widget.downCounter = 0;
                        widget.votes++;
                        widget.downVote = false;
                      } else {
                        if (widget.upCounter == 1) {
                          widget.votes--;
                          widget.upCounter = 0;
                        }
                        if (widget.upVote == true) {
                          widget.votes--;
                          widget.upVote = false;
                        }
                        widget.downCounter = 1;
                        widget.votes--;
                        widget.downVote = true;
                      }
                      updateVotesNumber();
                    });
                    saveVoter();
                  },
                ),
              ],
            ),
            Opacity(
              opacity: 0.5,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 1,
                  height: 1,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
