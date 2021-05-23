import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habini/components.dart';

class CommentsStreamer extends StatelessWidget {
  final _firebase = FirebaseFirestore.instance;

  CommentsStreamer({
    this.logedInUser,
    this.currentPostId,
  });
  final User logedInUser;
  final currentPostId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _firebase
            .collection('Posts')
            .doc(currentPostId)
            .collection('Comments')
            .orderBy('sentOn')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final comments = snapshot.data.docs.reversed;
            List<KComment> commentsContainer = [];
            for (var comment in comments) {
              final commentData = comment.data();
              final content = commentData['content'];
              final votes = commentData['votesNumber'];
              final date = commentData['sentOn'];

              final kPost = KComment(
                content: content,
                votes: votes,
                date: date,
              );
              commentsContainer.add(kPost);
            }
            return Expanded(
              flex: 1,
              child: Column(
                children: commentsContainer,
              ),
            );
          } else {}
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: UniformColor,
            ),
          );
        });
  }
}
