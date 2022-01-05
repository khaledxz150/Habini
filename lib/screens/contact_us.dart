import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habini/screens/welcome_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components.dart';

final _auth = FirebaseAuth.instance;
final _firebase = FirebaseFirestore.instance;

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

bool showSpinner = false;

class _ContactUsState extends State<ContactUs> {
  String _contactUs;

  String _email;

  final contactUs = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: UniformColor,
        title: Row(
          children: [
            Icon(
              Icons.contact_mail_outlined,
            ),
            SizedBox(
              width: 20.0,
            ),
            Center(
              child: Text(
                'Contact Us',
                style: GoogleFonts.koHo(
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
            ),
          ],
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.all(3.0),
              child: Text(
                'How can we help you? ',
                style: GoogleFonts.koHo(
                  fontSize: 50,
                  color: UniformColor,
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    hintText: 'Please give us details',
                    border: InputBorder.none,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  maxLines: null,
                  style: TextStyle(color: Colors.black),
                  cursorColor: Colors.black,
                  inputFormatters: [],
                  onChanged: (value) {
                    _contactUs = value;
                  }),
            ),
            SizedBox(
              height: 150,
            ),
            SizedBox(
              height: 50,
            ),
            KmaterialButton(
              label: 'Submit',
              onPressed: () async {
                if (_contactUs == null || _contactUs.trim() == "") {
                  setState(() {
                    showSpinner = false;
                  });
                  Alert(
                    context: context,
                    type: AlertType.warning,
                    title: "Post Alert",
                    desc: "Why so empty... ",
                    buttons: [
                      DialogButton(
                        child: Text(
                          "Back",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () => Navigator.pop(context),
                        width: 120,
                      ),
                    ],
                  ).show();
                } else {
                  setState(() {
                    showSpinner = true;
                  });
                  contactUs.clear();
                  String id = _firebase.collection('Posts').doc().id;
                  try {
                    await _firebase.collection('ContactUs').doc(id).set({
                      'content': _contactUs.toString(),
                      'poster': logedInUser.uid,
                      'sentOn': FieldValue.serverTimestamp(),
                    });
                    setState(() {
                      showSpinner = false;
                    });
                    Alert(
                      context: context,
                      type: AlertType.success,
                      title: "Your message has been sent",
                      desc: "Thanks for contacting us",
                      buttons: [
                        DialogButton(
                          child: Text(
                            "Back",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () => Navigator.pop(context),
                          width: 120,
                        )
                      ],
                    ).show();
                  } catch (ex) {
                    showSpinner = false;
                    print(ex);
                  }
                }
              },
              color: UniformColor,
            ),
          ],
        ),
      ),
    );
  }
}
