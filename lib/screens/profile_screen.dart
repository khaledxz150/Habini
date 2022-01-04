import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habini/components.dart';
import 'package:habini/streams/post_stream.dart';

final _auth = FirebaseAuth.instance;
final _firebase = FirebaseFirestore.instance;
User logedInUser;

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isVisible = false;
  String newAvatar;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
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

  void updateUserAvatar(String newAvatar) {
    setState(() {
      _firebase
          .collection('Users')
          .doc(logedInUser.uid)
          .update({'avatarUrl': newAvatar});
    });
  }

  @override
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
            radius: 90,
            backgroundImage: NetworkImage(
              userDocument["avatarUrl"],
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: UniformColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
                'navigation_page', (Route<dynamic> route) => false);
          },
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            painter: HeaderCurvedContainer(),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Profile",
                  style: TextStyle(
                    fontSize: 35,
                    letterSpacing: 1.5,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              getUserAvatar(),


              PostStreamer(
                logedInUser: logedInUser,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 270, left: 184),
            child: CircleAvatar(
              backgroundColor: Colors.black54,
              child: IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _isVisible = true;
                  });
                },
              ),
            ),
          ),
          Visibility(
            visible: _isVisible,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 300, bottom: 160, right: 20, left: 20),
              child: Container(
                color: Colors.teal,
                child: GridView.count(
                  primary: true,
                  padding: const EdgeInsets.all(10),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 3,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        setState(() {
                          updateUserAvatar(
                              'https://firebasestorage.googleapis.com/v0/b/abini-199cc.appspot.com/o/Avatars%2F1bdc9a33850498.56ba69ac2ba5b.png?alt=media&token=e400938f-f383-4e61-a5db-0c8ed409f6e1');
                          _isVisible = false;
                        });
                      },
                      icon: Image.network(
                          'https://firebasestorage.googleapis.com/v0/b/abini-199cc.appspot.com/o/Avatars%2F1bdc9a33850498.56ba69ac2ba5b.png?alt=media&token=e400938f-f383-4e61-a5db-0c8ed409f6e1'),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          updateUserAvatar(
                              'https://firebasestorage.googleapis.com/v0/b/abini-199cc.appspot.com/o/Avatars%2Ff9fa8a33850498.56ba69ac2cc3a.png?alt=media&token=2e74444d-d8d8-4f33-80d2-b053438167fd');
                          _isVisible = false;
                        });
                      },
                      icon: Image.network(
                          'https://firebasestorage.googleapis.com/v0/b/abini-199cc.appspot.com/o/Avatars%2Ff9fa8a33850498.56ba69ac2cc3a.png?alt=media&token=2e74444d-d8d8-4f33-80d2-b053438167fd'),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          updateUserAvatar(
                              'https://firebasestorage.googleapis.com/v0/b/abini-199cc.appspot.com/o/Avatars%2F2c659933850498.56ba69ac2e080.png?alt=media&token=9bd450b6-27d1-4284-bafc-21e0c0221f2a');

                          _isVisible = false;
                        });
                      },
                      icon: Image.network(
                          'https://firebasestorage.googleapis.com/v0/b/abini-199cc.appspot.com/o/Avatars%2F2c659933850498.56ba69ac2e080.png?alt=media&token=9bd450b6-27d1-4284-bafc-21e0c0221f2a'),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          updateUserAvatar(
                              'https://firebasestorage.googleapis.com/v0/b/abini-199cc.appspot.com/o/Avatars%2F64623a33850498.56ba69ac2a6f7.png?alt=media&token=83c8154a-7e63-4c86-9dc9-2d7ec862654a');
                          _isVisible = false;
                        });
                      },
                      icon: Image.network(
                          'https://firebasestorage.googleapis.com/v0/b/abini-199cc.appspot.com/o/Avatars%2F64623a33850498.56ba69ac2a6f7.png?alt=media&token=83c8154a-7e63-4c86-9dc9-2d7ec862654a'),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          updateUserAvatar(
                              'https://firebasestorage.googleapis.com/v0/b/abini-199cc.appspot.com/o/Avatars%2F84c20033850498.56ba69ac290ea.png?alt=media&token=e0c8e9ce-0259-41b1-8341-851ae52961db');

                          _isVisible = false;
                        });
                      },
                      icon: Image.network(
                          'https://firebasestorage.googleapis.com/v0/b/abini-199cc.appspot.com/o/Avatars%2F84c20033850498.56ba69ac290ea.png?alt=media&token=e0c8e9ce-0259-41b1-8341-851ae52961db'),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          updateUserAvatar(
                              'https://firebasestorage.googleapis.com/v0/b/abini-199cc.appspot.com/o/Avatars%2FNetflix-avatar.png?alt=media&token=092a24a9-6c56-4dce-86e2-5910610f017a');

                          _isVisible = false;
                        });
                      },
                      icon: Image.network(
                          'https://firebasestorage.googleapis.com/v0/b/abini-199cc.appspot.com/o/Avatars%2FNetflix-avatar.png?alt=media&token=092a24a9-6c56-4dce-86e2-5910610f017a'),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          updateUserAvatar(
                              'https://firebasestorage.googleapis.com/v0/b/abini-199cc.appspot.com/o/Avatars%2Fflat%2C1000x1000%2C075%2Cf.u2.jpg?alt=media&token=55f42e1c-3ecc-4840-b8a4-5d2f6c50f1f9');
                          _isVisible = false;
                        });
                      },
                      icon: Image.network(
                          'https://firebasestorage.googleapis.com/v0/b/abini-199cc.appspot.com/o/Avatars%2Fflat%2C1000x1000%2C075%2Cf.u2.jpg?alt=media&token=55f42e1c-3ecc-4840-b8a4-5d2f6c50f1f9'),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          updateUserAvatar(
                              'https://firebasestorage.googleapis.com/v0/b/abini-199cc.appspot.com/o/Avatars%2Fe70b1333850498.56ba69ac32ae3.png?alt=media&token=dbe1ea6a-59da-4917-ba8a-c053bbe877ed');

                          _isVisible = false;
                        });
                      },
                      icon: Image.network(
                          'https://firebasestorage.googleapis.com/v0/b/abini-199cc.appspot.com/o/Avatars%2Fe70b1333850498.56ba69ac32ae3.png?alt=media&token=dbe1ea6a-59da-4917-ba8a-c053bbe877ed'),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          updateUserAvatar(
                              'https://firebasestorage.googleapis.com/v0/b/abini-199cc.appspot.com/o/Avatars%2Fweb_hi_res_512.png?alt=media&token=07cfcead-28a4-400e-81c6-6c879139d26b');
                          _isVisible = false;
                        });
                      },
                      icon: Image.network(
                          'https://firebasestorage.googleapis.com/v0/b/abini-199cc.appspot.com/o/Avatars%2Fweb_hi_res_512.png?alt=media&token=07cfcead-28a4-400e-81c6-6c879139d26b'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = UniformColor;
    Path path = Path()
      ..relativeLineTo(0, 150)
      ..quadraticBezierTo(size.width / 2, 225, size.width, 150)
      ..relativeLineTo(0, -150)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class TopRated extends StatefulWidget {
  final poster;

  final String content;
  int votes = 0;
  final date;
  dynamic numberOfComments;

  int downCounter = 0;
  int upCounter = 0;

  TopRated({
    this.poster,
    this.content,
    this.votes,
    this.date,
    this.numberOfComments,
  });

  @override
  _TopRatedState createState() => _TopRatedState();
}

class _TopRatedState extends State<TopRated> {
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
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 25,
                ),
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
