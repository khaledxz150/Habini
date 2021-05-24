import 'package:flutter/material.dart';
import 'package:habini/screens/comments_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habini/screens/save_user_data.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

final _auth = FirebaseAuth.instance;
final _firebase = FirebaseFirestore.instance;

// User logedInUser;
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
    return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago";
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

  KPostContainer({
    this.isMe,
    this.postId,
    this.content,
    this.votes,
    this.date,
    this.numberOfComments,
  });

  @override
  _KPostContainerState createState() => _KPostContainerState();
}

class _KPostContainerState extends State<KPostContainer> {
  @override
  bool downVote = false;
  bool upVote = false;

  void updateVotesNumber() {
    setState(() {
      _firebase
          .collection('Posts')
          .doc(widget.postId)
          .update({'votesNumber': widget.votes});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isMe) {
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
                  child: CircleAvatar(
                    backgroundColor: UniformColor,
                    child: Text(
                      'Owner',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        timeAgo(widget.date.toDate()),
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
                                downVote = false;
                                if (upVote == true) {
                                  widget.upCounter = 0;
                                  widget.votes--;
                                  upVote = false;
                                } else {
                                  if (widget.downCounter == 1) {
                                    widget.votes++;
                                    widget.downCounter = 0;
                                  }
                                  widget.upCounter = 1;
                                  widget.votes++;
                                  upVote = true;
                                }
                                updateVotesNumber();
                              });
                            },
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
                                upVote = false;
                                if (downVote == true) {
                                  widget.downCounter = 0;
                                  widget.votes++;
                                  downVote = false;
                                } else {
                                  if (widget.upCounter == 1) {
                                    widget.votes--;
                                    widget.upCounter = 0;
                                  }
                                  widget.downCounter = 1;
                                  widget.votes--;
                                  downVote = true;
                                }
                                updateVotesNumber();
                              });
                            },
                          ),
                        ],
                      ),
                      Text(
                        widget.votes.toString(),
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
                                  poster: 'Owner',
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
    } else {
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
                  child: CircleAvatar(
                    backgroundColor: UniformColor,
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        timeAgo(widget.date.toDate()),
                      ),
                      FlatButton(
                        minWidth: 20,
                        onPressed: () {
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
                                    ))
                              ],
                            ),
                            buttons: [
                              DialogButton(
                                child: Text(
                                  "Submit",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () {},
                                width: 120,
                                color: UniformColor,
                              )
                            ],
                          ).show();
                        },
                        child: Icon(
                          Icons.warning,
                        ),
                      ),
                    ]),
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
                                downVote = false;
                                if (upVote == true) {
                                  widget.upCounter = 0;
                                  widget.votes--;
                                  upVote = false;
                                } else {
                                  if (widget.downCounter == 1) {
                                    widget.votes++;
                                    widget.downCounter = 0;
                                  }
                                  widget.upCounter = 1;
                                  widget.votes++;
                                  upVote = true;
                                }
                                updateVotesNumber();
                              });
                            },
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
                                upVote = false;
                                if (downVote == true) {
                                  widget.downCounter = 0;
                                  widget.votes++;
                                  downVote = false;
                                } else {
                                  if (widget.upCounter == 1) {
                                    widget.votes--;
                                    widget.upCounter = 0;
                                  }
                                  widget.downCounter = 1;
                                  widget.votes--;
                                  downVote = true;
                                }
                                updateVotesNumber();
                              });
                            },
                          ),
                        ],
                      ),
                      Text(
                        widget.votes.toString(),
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
                                  poster: '',
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
}

class KComment extends StatefulWidget {
  final String content;
  int votes = 0;
  Timestamp date;
  int downCounter = 0;
  int upCounter = 0;

  KComment({
    this.votes,
    this.date,
    this.content,
  });

  @override
  _KCommentState createState() => _KCommentState();
}

class _KCommentState extends State<KComment> {
  @override
  bool downVote = false;
  bool upVote = false;

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      color: Colors.grey[200],
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 5.0, left: 5.0),
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: UniformColor,
                ),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      timeAgo(
                        widget.date.toDate(),
                      ),
                    ),
                    DropdownButton<FlatButton>()
                  ]),
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
                  color: upVote ? UniformColor : Colors.black,
                ),
                tooltip: 'Up vote',
                iconSize: 30,
                onPressed: () {
                  setState(() {
                    downVote = false;
                    if (upVote == true) {
                      widget.upCounter = 0;
                      widget.votes--;
                      upVote = false;
                    } else {
                      if (widget.downCounter == 1) {
                        widget.votes++;
                        widget.downCounter = 0;
                      }
                      widget.upCounter = 1;
                      widget.votes++;
                      upVote = true;
                    }
                  });
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
                    upVote = false;
                    if (downVote == true) {
                      widget.downCounter = 0;
                      widget.votes++;
                      downVote = false;
                    } else {
                      if (widget.upCounter == 1) {
                        widget.votes--;
                        widget.upCounter = 0;
                      }
                      widget.downCounter = 1;
                      widget.votes--;
                      downVote = true;
                    }
                  });
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
