import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habini/models/posts.dart';
import 'package:habini/screens/welcome_screen.dart';
import 'package:habini/components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habini/screens/comments_screen.dart';
import 'package:habini/streams/post_stream.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habini/widgets/post_widget.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

final _firebase = FirebaseFirestore.instance;
User logedInUser;
FirebaseFirestore _fireStore = FirebaseFirestore.instance;
Color UniformColor = Color.fromRGBO(60, 174, 163, 1);

class HomeIndex extends StatefulWidget {
  @override
  HomeIndexState createState() => HomeIndexState();
}

class HomeIndexState extends State<HomeIndex> {
  @override
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  List _allResults = [];
  List _resultsList = [];
  Future resultsLoaded;
  bool isLoad = true;
  bool meIs = false;
  var userFacility;


  TextEditingController _searchController = TextEditingController();

  getUserFacility() async {
    await _firebase
        .collection('Users')
        .doc(logedInUser.uid)
        .get()
        .then((value) {
      userFacility = value.data()['facility'];
    });
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getPosts();
  }

  _onSearchChanged() {
    searchResultsList();
    print(_searchController.text);
  }

  getPosts() async {
    await getUserFacility();
    var data = await _fireStore
        .collection('Posts')
        .where('PosterFacility', isEqualTo: userFacility)
        .orderBy('sentOn', descending: true)
        .get();
    setState(() {
      _allResults = data.docs;
      isLoad = false;
    });
    searchResultsList();
    return "Completed";
  }

  searchResultsList() {
    var showResults = [];
    if (_searchController.text != "") {
      for (var postsSnapsot in _allResults) {
        var postContent = Posts.fromSnapshot(postsSnapsot).content;
        if (postContent.contains(_searchController.text)) {
          showResults.add(postsSnapsot);
        }
      }
    } else {
      showResults = List.from(_allResults);
    }
    setState(() {
      _resultsList = showResults;
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getUserFacility();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
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

  @override
  Widget build(BuildContext context) {
    checkPostDuration(index) {
      final posts = Posts.fromSnapshot(_resultsList[index]);
      Timestamp sentOn = posts.date;
      DateTime sentOnTo = sentOn.toDate();
      int sentOnHours = sentOnTo.hour;
      var duration = posts.duration;
      var currentTime = new DateTime.now().hour;
      // print(posts.content);
      // print(sentOnHours);
      // print("sentOn");
      // print(duration);
      // print("duration");
      // print(currentTime - sentOnHours);
      // print("deleteTime");
      // print(currentTime);
      // print("current");
      if (currentTime - sentOnHours >= duration) {
        _resultsList.removeAt(index);

        _firebase.collection('Posts').doc(posts.postId).delete();
      }
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: UniformColor,
          title: Row(
            children: [
              Icon(
                Icons.home,
              ),
              SizedBox(
                width: 20.0,
              ),
              Text(
                'Home',
                style: GoogleFonts.koHo(
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Color.fromRGBO(60, 174, 163, 0.1),
        body: ModalProgressHUD(
          inAsyncCall: isLoad,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextField(
                          controller: _searchController,
                          textAlign: TextAlign.end,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                              fontSize: 15,
                            ),
                            hintText: 'Search',
                            suffixIcon: Icon(Icons.search),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                flex: 1,
                child: RefreshIndicator(
                  onRefresh: refresh,
                  child: ListView.builder(
                    itemCount: _resultsList.length,
                    itemBuilder: (BuildContext context, index) {
                      final posts = Posts.fromSnapshot(_resultsList[index]);
                      if (logedInUser.uid == posts.poster) {
                        meIs = true;
                      }
                      if (_resultsList.isEmpty) {
                        print("emp");
                        return Center(
                          child: Container(
                            child: Text(
                              'There is no posts yet :(',
                              style: TextStyle(fontSize: 50),
                            ),
                          ),
                        );
                      }
                      try {
                        checkPostDuration(index);
                        return KPostContainerV2(
                          isMe: meIs,
                          document: _resultsList[index],
                        );
                      } catch (e) {
                        return Container(
                          child: Text('No Posts In this facility'),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> refresh() {
    return getPosts();
  }
}
