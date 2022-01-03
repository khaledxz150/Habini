import 'package:cloud_firestore/cloud_firestore.dart';

class Posts {
  String content;
  int numberOfComments;
  int votesNumber;
  final date;
  String id;
  final postId;
  final poster;
  final duration;

  Posts({
    this.postId,
    this.content,
    this.id,
    this.numberOfComments,
    this.poster,
    this.date,
    this.votesNumber,
    this.duration,
  });

  Posts.fromSnapshot(DocumentSnapshot snapshot)
      : content = snapshot['content'],
        numberOfComments = snapshot['numOfComments'],
        votesNumber = snapshot['votesNumber'],
        date = snapshot['sentOn'],
        postId = snapshot['postId'],
        duration = snapshot['duration'],
        poster = snapshot['poster'];
}
