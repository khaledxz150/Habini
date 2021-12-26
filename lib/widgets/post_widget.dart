import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habini/models/posts.dart';
import 'package:habini/screens/comments_screen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

User logedInUser;
Color UniformColor = Color.fromRGBO(60, 174, 163, 1);
final _auth = FirebaseAuth.instance;
final _firebase = FirebaseFirestore.instance;
var postId;

class KPostContainerV2 extends StatefulWidget {
  final DocumentSnapshot document;
  final isMe ;

  KPostContainerV2({
    this.document,
    this.isMe,
  });

  @override
  _KPostContainerV2State createState() => _KPostContainerV2State();
}

class _KPostContainerV2State extends State<KPostContainerV2> {
  int downCounter = 0;
  int upCounter = 0;
  bool downVote = false;
  bool upVote = false;
  int votes = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    getCurrentUser();

  }

  getData() async {
    DocumentSnapshot votes = await _firebase
        .collection('Posts')
        .doc(widget.document['postId'])
        .collection('Voters')
        .doc(logedInUser.uid)
        .get();
    setState(() {
      downVote = votes['downVote'];
      upVote = votes['upVote'];
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
          .doc(widget.document['postId'])
          .update({'votesNumber': votes});
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
            .doc(widget.document['postId'])
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
          .doc(widget.document['postId'])
          .collection('Voters')
          .doc(logedInUser.uid)
          .delete();
    }
  }

  Widget build(BuildContext context) {
    final posts = Posts.fromSnapshot(widget.document);
    getVotes() {
      return new StreamBuilder(
          stream: _firebase.collection('Posts').doc(posts.postId).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return new Text("Loading");
            }
            var userDocument = snapshot.data;
            return new Text(userDocument["votesNumber"].toString());
          });
    }

    getCommentsNumber() {
      return new StreamBuilder(
          stream: _firebase.collection('Posts').doc(posts.postId).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return new Text("Loading");
            }
            var userDocument = snapshot.data;
            return new Text(userDocument["numOfComments"].toString());
          });
    }
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
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, left: 5.0),
                      child: CircleAvatar(
                        backgroundColor: UniformColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12,top: 6),
                      child: Text(
                        'Me',
                        style: TextStyle(

                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Raleway',
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        timeAgo(posts.date.toDate()),
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
                  posts.content,
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
                                  upCounter = 0;
                                  votes--;
                                  upVote = false;
                                } else {
                                  if (downCounter == 1) {
                                    votes++;
                                    downCounter = 0;
                                  }
                                  upCounter = 1;
                                  votes++;
                                  upVote = true;
                                }
                                updateVotesNumber();
                              });
                              saveVoter();
                            },
                          ),
                          getVotes(),
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
                                  downCounter = 0;
                                  votes++;
                                  downVote = false;
                                } else {
                                  if (upCounter == 1) {
                                    votes--;
                                    upCounter = 0;
                                  }
                                  downCounter = 1;
                                  votes--;
                                  downVote = true;
                                }
                                updateVotesNumber();
                              });
                              saveVoter();
                            },
                          ),
                        ],
                      ),
                      //Text(posts.votesNumber.toString()),
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
                                  postId: posts.postId,
                                  postContent: posts.content,
                                  postVotes: votes,
                                  numberOfComments: posts.numberOfComments,
                                  date: posts.date,
                                  poster: 'Owner',
                                ),
                              ),
                            );
                          });
                        },
                      ),
                      getCommentsNumber(),
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
                  children: <Widget>[
                    Container(
                      child: Text(
                        timeAgo(
                          posts.date.toDate(),
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
                  posts.content,
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
                                  upCounter = 0;
                                  votes--;
                                  upVote = false;
                                } else {
                                  if (downCounter == 1) {
                                    votes++;
                                    downCounter = 0;
                                  }
                                  upCounter = 1;
                                  votes++;
                                  upVote = true;
                                }
                                updateVotesNumber();
                              });
                              saveVoter();
                            },
                          ),
                          getVotes(),
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
                                  downCounter = 0;
                                  votes++;
                                  downVote = false;
                                } else {
                                  if (upCounter == 1) {
                                    votes--;
                                    upCounter = 0;
                                  }
                                  downCounter = 1;
                                  votes--;
                                  downVote = true;
                                }
                                updateVotesNumber();
                              });
                              saveVoter();
                            },
                          ),
                        ],
                      ),
                      //Text(posts.votesNumber.toString()),
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
                                  postId: posts.postId,
                                  postContent: posts.content,
                                  postVotes: votes,
                                  numberOfComments: posts.numberOfComments,
                                  date: posts.date,
                                  poster: '',
                                ),
                              ),
                            );
                          });
                        },
                      ),
                      getCommentsNumber(),
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
