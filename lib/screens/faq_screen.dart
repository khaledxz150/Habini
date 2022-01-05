import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: NavigationDrawer(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Frequently Asked Questions'),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
           Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            end: Alignment.topRight,
            begin: Alignment.bottomLeft,
            colors: [
              Color(0xFF0e233f),
              //kDarkBlue,

              Colors.tealAccent,
            ],
          ),
        ),

        child: SafeArea(
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    CreateListTile(Question: 'What is 5abini ?',Answer: '5abini is an app that was built while focusing on privacy and intention to gather people with no social fear or anxiety.',),

                    SizedBox(height: 30),
                    CreateListTile(Question: 'Why is 5abini different ?',Answer: 'Most social media platform are geared toward talking to people you already, or at least know they have something in common with you. There isn’t a platform that allows you to share something that’s not common between people and still get reactions and have some interactive experiences, as most there is a program as far as we can tell that links the posts you see geographically, there’s features in some apps, but at that point the time line is so bloated that there’s isn’t roam for your niches.',),

                    SizedBox(height: 30),
                    CreateListTile(Question: 'what can 5abini offer ?',Answer: 'an environment that allows you to share what you love, care about, ask questions and help people who do so. 5abini is geared into anonymous interactions, that will remove fear of social criticism and anxiety, as who you are will never be unknown. Make friends, get knowledge and share yours!',),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CreateListTile extends StatelessWidget {
  final String Question;
  final String Answer;
  CreateListTile({this.Question , this.Answer});


  @override
  Widget build(BuildContext context) {
    return ListTile(


      //trailing: Icon(Icons.more_vert),
      isThreeLine: true,
      contentPadding: EdgeInsets.all(8),
      title: Text(Question, style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
      subtitle: Text(Answer,style: TextStyle(color: Colors.white70,fontSize:14)),
    );
  }
}