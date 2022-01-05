import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habini/screens/welcome_screen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components.dart';

class ContactUs extends StatefulWidget {

  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
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
          )),
body: ListView(
  children: [Container(
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
    SizedBox(height: 50,),
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
          inputFormatters: [

          ],
          onChanged: (value) {

          }),
    ),
    SizedBox(height: 150,),
    KTextField(
      labelText: 'Enter your E-mail',
      labelStyle: TextStyle(
        color: UniformColor,
      ),
      icon: Icon(
        Icons.mail,
        color: UniformColor,
      ),
      keyBordType: null,
      hidden: false,
      inputFormatters: null,
      onChange: (value) {

      },

    ),
    SizedBox(height: 50,),
    KmaterialButton(
      label: 'Submit',
      onPressed: () async {

      },
      color: UniformColor,
    ),
  ],
)
,

    );
  }
}
