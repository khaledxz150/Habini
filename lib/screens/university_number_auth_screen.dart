import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habini/components.dart';
import 'package:habini/models/user_data.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habini/screens/welcome_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

import 'otp_screen.dart';


Color UniformColor = Color.fromRGBO(60, 174, 163, 1);

final _auth = FirebaseAuth.instance;
final _firebase = FirebaseFirestore.instance;

final textController = TextEditingController();


class UniversityAuth extends StatefulWidget {
  @override
  _State createState() => _State();
}


String studentId = null;
String password = null ;

class _State extends State<UniversityAuth> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  bool showSpinner = false;

  bool isExists;

  UserData _userData;

  @override
  Widget build(BuildContext context) {
    Future<UserData> studentData() async {
      var response = await http.post(
        Uri.https('hashemiteuni.azurewebsites.net',
            'api/Student/IfStudent/$studentId/$password'),
      );
      var data = response.body;
      if (data.isEmpty){
        FocusScope.of(context).unfocus();
        _scaffoldkey.currentState.showSnackBar(
          SnackBar(
            content: Text('invalid user'),
          ),
        );
      }
      if (response.statusCode == 200) {
        print(data);
        String responseString = response.body;
        return userDataFromJson(responseString);
      }
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Scaffold(
          key: _scaffoldkey,
          backgroundColor: UniformColor,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 100,
                  ),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.all(3.0),
                      child: Text(
                        'Are you a student ?',
                        style: GoogleFonts.koHo(
                          fontSize: 38,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: KTextField(
                            labelText: 'University ID',
                            labelStyle: TextStyle(
                              color: UniformColor,
                            ),
                            icon: Icon(
                              Icons.account_circle,
                              color: UniformColor,
                            ),
                            keyBordType: null,
                            hidden: false,
                            inputFormatters: null,
                            onChange: (value) {
                              setState(() {
                                studentId = value;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: KTextField(
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              color: UniformColor,
                            ),
                            icon: Icon(
                              Icons.lock,
                              color: UniformColor,
                            ), //sss
                            keyBordType: null,
                            hidden: true,
                            inputFormatters: null,
                            onChange: (value) {
                              setState(() {
                                password = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        KmaterialButton(
                          label: 'Next',
                          onPressed: () async {
                            setState(() {
                              showSpinner = true;
                            });
                            if (studentId == null) {
                              setState(() {
                                showSpinner = false;
                              });
                              FocusScope.of(context).unfocus();
                              _scaffoldkey.currentState.showSnackBar(
                                SnackBar(
                                  content:
                                      Text('Please enter your university ID'),
                                ),
                              );
                            }
                            if (password == null) {
                              setState(() {
                                showSpinner = false;
                              });
                              FocusScope.of(context).unfocus();
                              _scaffoldkey.currentState.showSnackBar(
                                SnackBar(
                                  content:
                                  Text('Please enter your password'),
                                ),
                              );
                            }
                            else {
                              try {
                                UserData data = await studentData();
                                if(data!=null){
                                  setState(() {
                                    _userData = data;
                                  });

                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => OTPScreen(_userData),
                                    ),
                                  );
                                  setState(() {
                                    showSpinner = false;
                                  });
                                  studentId=null;
                                  password=null;
                                }else{
                                  FocusScope.of(context).unfocus();
                                  _scaffoldkey.currentState.showSnackBar(
                                    SnackBar(
                                      content: Text('invalid user'),
                                    ),
                                  );
                                }
                              }catch(e){
                                print (e);
                              }
                            }
                          },
                          color: UniformColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
