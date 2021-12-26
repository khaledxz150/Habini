import 'package:flutter/material.dart';
import 'package:habini/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:international_phone_input/international_phone_input.dart';
import 'package:habini/screens/home_screen.dart';
import 'package:habini/screens/otp_screen.dart';
import 'package:google_fonts/google_fonts.dart';
Color UniformColor = Color.fromRGBO(60, 174, 163, 1);

class SignUp extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<SignUp> {
  final _auth = FirebaseAuth.instance;
  bool showSinner = false;
  @override
  String _controller;
  String isoCode;
  String _codeController;
  bool hidePass = true;
  void onPhoneNumberChange(
      String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
      _controller = internationalizedPhoneNumber;
      print(_controller);
      isoCode = isoCode;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniformColor,
      body: ModalProgressHUD(
        inAsyncCall: showSinner,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 100,
                ),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.all(3.0),
                    child: Text(
                      'Sign Up',
                      style: GoogleFonts.koHo(
                        fontSize: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
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
                        height: 10,
                      ),
                      Container(
                        child: InternationalPhoneInput(
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: UniformColor, width: 1),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(90.0),
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(90.0),
                                ),
                                borderSide:
                                    BorderSide(color: UniformColor, width: 0.5),
                              ),
                              labelText: 'PhoneNumber',
                              labelStyle: TextStyle(
                                color: UniformColor,
                              )),
                          onPhoneNumberChange: onPhoneNumberChange,
                          initialPhoneNumber: _controller,
                          initialSelection: 'JO',
                          showCountryCodes: true,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      /*  Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: KTextField(
                          cursorColor: Colors.black,
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            color: UniformColor,
                          ),
                          icon: Icon(
                            Icons.lock,
                            color: UniformColor,
                          ),
                          keyBordType: null,
                          hidden: hidePass,
                          inputFormatters: null,
                          onChange: (value) {},
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: KTextField(
                          cursorColor: Colors.black,
                          labelText: 'Confirm Password',
                          labelStyle: TextStyle(
                            color: UniformColor,
                          ),
                          icon: Icon(
                            Icons.lock,
                            color: UniformColor,
                          ),
                          keyBordType: null,
                          hidden: hidePass,
                          inputFormatters: null,
                          onChange: (value) {},
                        ),
                      ), */
                      SizedBox(
                        height: 10,
                      ),
                      KmaterialButton(
                        label: 'Continue',
                        onPressed: () {
                          if (_controller == null || _controller.length != 13) {
                            Alert(
                                    context: context,
                                    title: "Warning",
                                    desc: "invalid phone number")
                                .show();
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => OTPScreen(_controller),
                              ),
                            );
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
    );
  }
}
