import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    final date = DateTime(2021, 5, 22, 20, 28);
    final date2 = DateTime.now();
    final difference = date2.difference(date).inMinutes;
    return Scaffold(
      backgroundColor: Color.fromRGBO(60, 174, 163, 0.1),
      appBar: AppBar(
        backgroundColor: UniformColor,
        title: Row(
          children: [
            Icon(
              Icons.notifications,
            ),
            SizedBox(
              width: 20.0,
            ),
            Text(
              'Notifications ',
              style: GoogleFonts.koHo(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        children: <Widget>[
          Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                        "https://www.nj.com/resizer/zovGSasCaR41h_yUGYHXbVTQW2A=/1280x0/smart/cloudfront-us-east-1.images.arcpublishing.com/advancelocal/SJGKVE5UNVESVCW7BBOHKQCZVE.jpg"),
                    backgroundColor: UniformColor,
                  ),
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
                              'Someone commented on your post',
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
                            '$difference minutes ago',
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
              )),
          Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://xenforo.com/community/data/avatars/o/202/202502.jpg?1587654225'),
                    radius: 30,
                    backgroundColor: UniformColor,
                  ),
                  FlatButton(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'your post received an up vote',
                            style: GoogleFonts.koHo(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            '12 minutes ago',
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
              )),
          Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://susanaclavero.files.wordpress.com/2015/09/myavatar.jpg'),
                    radius: 30,
                    backgroundColor: UniformColor,
                  ),
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
                              'your post received a down vote',
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
                            '40 minutes ago',
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
              )),
          Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://cdn.pixabay.com/photo/2016/08/20/05/36/avatar-1606914_960_720.png'),
                    radius: 30,
                    backgroundColor: UniformColor,
                  ),
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
                              'your post received a down vote',
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
                            '1 hour ago',
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
              )),
          Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://cdn.pixabay.com/photo/2017/01/31/19/07/avatar-2026510_960_720.png'),
                    radius: 30,
                    backgroundColor: UniformColor,
                  ),
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
                              'your post received an up vote',
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
                            '2 hours ago',
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
              )),
          Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://cdn.pixabay.com/photo/2016/08/20/05/38/avatar-1606916_960_720.png'),
                    radius: 30,
                    backgroundColor: UniformColor,
                  ),
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
                              'Someone commented on your post',
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
                            '5 hours ago',
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
              )),
        ],
      ),
    );
  }
}
