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

final _auth = FirebaseAuth.instance;
final _firebase = FirebaseFirestore.instance;

final textController = TextEditingController();
bool showSpinner = false;

class UniversityAuth extends StatefulWidget {
  @override
  _State createState() => _State();
}
String studentId = null;



class _State extends State<UniversityAuth> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();


  String password;

  bool isExists;

  UserData _userData;

  @override
  Widget build(BuildContext context) {


    Future<UserData> studentData() async {
      var response = await http.post(
        Uri.https('hashemiteuni.azurewebsites.net', 'api/Student/IfStudent/$studentId/123456'),
      );
      var data = response.body;
      print(data);

      if (response.statusCode == 201) {
        String responseString = response.body;
        userDataFromJson(responseString);
      } else{
        FocusScope.of(context).unfocus();
        _scaffoldkey.currentState.showSnackBar(
          SnackBar(
            content:
            Text('Please enter your university ID'),
          ),
        );
      }
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldkey,
        backgroundColor: UniformColor,
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: SafeArea(
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
                        SizedBox(
                          height: 10,
                        ),
                        KmaterialButton(
                          label: 'Check',
                          onPressed: () async {
                            UserData data =
                            await studentData();

                            setState(() {
                              _userData = data;
                            });
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
                            } else {
                              try {
                                var doc = await _firebase
                                    .collection("university_ids")
                                    .doc(studentId)
                                    .get();

                                if (doc.exists) {
                                  Navigator.pushNamed(
                                      context, 'sign_up_screen');
                                  setState(() {
                                    showSpinner = false;
                                  });
                                } else {
                                  setState(() {
                                    showSpinner = false;
                                  });
                                  Alert(
                                    context: context,
                                    type: AlertType.error,
                                    title: "Your university ID does not exist",
                                    desc:
                                        "Try check if your university ID is correct ",
                                    buttons: [
                                      DialogButton(
                                        child: Text(
                                          "Back",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                        width: 120,
                                      ),
                                    ],
                                  ).show();
                                }
                              } catch (e) {
                                setState(() {
                                  showSpinner = false;
                                });
                                print(e);
                                FocusScope.of(context).unfocus();
                                _scaffoldkey.currentState.showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('Please enter your university ID'),
                                  ),
                                );
                              }
                            }
                          },
                          color: UniformColor,
                        ),
                        Column(
                          children: <Widget>[
                            FlatButton(
                              onPressed: () async {


                              },
                              child: Text(
                                'Already Signed Up',
                                style: TextStyle(
                                  color: UniformColor,
                                ),
                              ),
                            ),
                          ],
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
