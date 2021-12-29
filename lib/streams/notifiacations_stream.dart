import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habini/components.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:google_fonts/google_fonts.dart';

class NotificationStream extends StatelessWidget {
  final _firebase = FirebaseFirestore.instance;

  NotificationStream({
    this.logedInUser,
  });

  final User logedInUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _firebase
            .collection('Notifications')
            .where('to', isEqualTo: logedInUser.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final notifications = snapshot.data.docs.reversed;
            List<Container> notificationContainer = [];
            for (var notification in notifications) {
              final notificationData = notification.data();
              final currentUser = logedInUser.uid;
              final content = notificationData['content'];
              final sentOn = notificationData['sentOn'];
              final from = notificationData['from'];

              getUserAvatar() {
                try {
                  return StreamBuilder(
                    stream: _firebase.collection('Users').doc(from).snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      }
                      var userDocument = snapshot.data;
                      return CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                          userDocument["avatarUrl"],
                        ),
                      );
                    },
                  );
                } catch (e) {
                  print(e);
                }
              }

              final kNotification = Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    getUserAvatar(),
                    FlatButton(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Text(
                                content,
                                style: GoogleFonts.koHo(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              timeAgo(sentOn.toDate()),
                              style: GoogleFonts.koHo(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
              notificationContainer.add(kNotification);
            }
            return Column(
              children: notificationContainer,
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: UniformColor,
            ),
          );
        });
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
}
