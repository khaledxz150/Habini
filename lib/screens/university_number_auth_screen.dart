import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habini/components.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habini/screens/welcome_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class UniversityAuth extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<UniversityAuth> {
  bool showSinner = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: UniformColor,
        body: ModalProgressHUD(
          inAsyncCall: showSinner,
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
                            onChange: (value) {},
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        KmaterialButton(
                          label: 'Check',
                          onPressed: () {
                            Navigator.pushNamed(context, 'sign_up_screen');
                          },
                          color: UniformColor,
                        ),
                        Column(
                          children: <Widget>[
                            FlatButton(
                              onPressed: () {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    'sign_in_screen',
                                    (Route<dynamic> route) => false);
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
