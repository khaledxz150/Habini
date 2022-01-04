import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habini/screens/save_user_data.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:pinput/pin_put/pin_put_state.dart';
import 'package:habini/screens/home_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:habini/components.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habini/screens/navigation_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
Color UniformColor = Color.fromRGBO(60, 174, 163, 1);

class OTPScreen extends StatefulWidget {
  final studentData;
  OTPScreen(this.studentData);

  @override
  _State createState() => _State();
}

class _State extends State<OTPScreen> {
  bool showSinner = false;

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  String _verificationCode;
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: UniformColor,
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: UniformColor,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniformColor,
      key: _scaffoldkey,
      body: ModalProgressHUD(
        inAsyncCall: showSinner,
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 100,
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.all(3.0),
                  child: Text(
                    'Verify ${"+962" + widget.studentData.phoneNumber.toString()}',
                    style: GoogleFonts.koHo(
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
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
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: PinPut(
                        fieldsCount: 6,
                        textStyle: const TextStyle(
                            fontSize: 25.0, color: Colors.white),
                        eachFieldWidth: 40.0,
                        eachFieldHeight: 55.0,
                        focusNode: _pinPutFocusNode,
                        controller: _pinPutController,
                        submittedFieldDecoration: pinPutDecoration,
                        selectedFieldDecoration: pinPutDecoration,
                        followingFieldDecoration: pinPutDecoration,
                        pinAnimationType: PinAnimationType.fade,
                        onSubmit: (pin) async {
                          try {
                            setState(() {
                              showSinner = true;
                            });
                            await FirebaseAuth.instance
                                .signInWithCredential(
                                    PhoneAuthProvider.credential(
                                        verificationId: _verificationCode,
                                        smsCode: pin))
                                .then((value) async {
                              if (value.user != null) {
                                setState(() {
                                  showSinner = false;
                                });
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SaveUserData(
                                      userData:widget.studentData,
                                    ),
                                  ),
                                  (route) => false,
                                );
                              }
                            });
                          } catch (e) {
                            setState(() {
                              showSinner = false;
                            });
                            FocusScope.of(context).unfocus();
                            _scaffoldkey.currentState.showSnackBar(
                              SnackBar(
                                content: Text('invalid OTP'),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    // KmaterialButton(
                    //   label: 'Edit Phone Number',
                    //   onPressed: () {
                    //     Navigator.pop(context);
                    //   },
                    //   color: UniformColor,
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+962" + widget.studentData.phoneNumber.toString(),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) async {
          if (value.user != null) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => SaveUserData(),
              ),
              (route) => false,
            );
          }
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        FocusScope.of(context).unfocus();
        _scaffoldkey.currentState.showSnackBar(
          SnackBar(
            content: Text('Try again Later'),
          ),
        );
      },
      codeSent: (String verficationID, int resendToken) {
        setState(() {
          _verificationCode = verficationID;
        });
      },
      codeAutoRetrievalTimeout: (String verificationID) {
        setState(() {
          _verificationCode = verificationID;
        });
      },
      timeout: Duration(seconds: 120),
    );
  }

  @override
  void initState() {
    super.initState();
    _verifyPhone();
  }
}
