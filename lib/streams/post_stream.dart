import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habini/components.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostStreamer extends StatelessWidget {
  final _firebase = FirebaseFirestore.instance;

  PostStreamer({
    this.logedInUser,
  });

  final User logedInUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _firebase
            .collection('Posts').orderBy('votesNumber')
            .where('poster', isEqualTo: logedInUser.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final posts = snapshot.data.docs.reversed;
            List<KPostContainer> postsContainer = [];
            for (var post in posts) {
              final postData = post.data();
              final content = postData['content'];
              final numberOfComments = postData['numOfComments'];
              final votes = postData['votesNumber'];
              final date = postData['sentOn'];
              final postId = postData['postId'];
              final poster = postData['poster'];

              final currentUser = logedInUser.uid;
              bool meIs = false;
              if (currentUser == poster) {
                meIs = true;
              }

              final kPost = KPostContainer(
                isMe: meIs,
                content: content,
                numberOfComments: numberOfComments,
                votes: votes,
                date: date,
                postId: postId,
              );
              postsContainer.add(kPost);
            }
            return Expanded(
              flex: 1,
              child: ListView(
                children: postsContainer,
              ),
            );
          } else if (!snapshot.hasData){
            return Center(
              child: Text('No Data'),
            );
          }
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: UniformColor,
            ),
          );
        });
  }
}
