import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habini/screens/welcome_screen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components.dart';

final _firebase = FirebaseFirestore.instance;

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: UniformColor,
          title: Row(
            children: [
              Icon(
                Icons.settings,
              ),
              SizedBox(
                width: 20.0,
              ),
              Text(
                'Settings',
                style: GoogleFonts.koHo(
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
            ],
          )),
      body: SettingsList(
        sections: [
          SettingsSection(
            tiles: [
              SettingsTile(
                title: 'Profile ',
                leading: Icon(Icons.account_circle),
                onPressed: (BuildContext context) {
                  Navigator.pushNamed(context, 'profile_page');
                },
              ),
              SettingsTile(
                title: 'Contact us',
                leading: Icon(Icons.contact_mail_outlined),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile(
                title: 'FAQ',
                leading: Icon(Icons.question_answer),
                onPressed: (BuildContext context) {},
              ),
              // SettingsTile(
              //   title: 'Delete Account',
              //   leading: Icon(Icons.block_flipped),
              //   onPressed: (BuildContext context) {
              //     Alert(
              //       context: context,
              //       type: AlertType.warning,
              //       title: "Delete your Account",
              //       desc:
              //           "are you sure you want to delete your account ? , all your posts and comments will be deleted after this action",
              //       buttons: [
              //         DialogButton(
              //           child: Text(
              //             "Yes",
              //             style: TextStyle(color: Colors.white, fontSize: 20),
              //           ),
              //           onPressed: () async {
              //             await _firebase
              //                 .collection('Posts')
              //                 .doc()
              //                 .collection('Comments')
              //                 .where('commenter', isEqualTo: logedInUser.uid)
              //                 .get()
              //                 .then(
              //                   (snapshot) {
              //                 for (DocumentSnapshot ds in snapshot.docs) {
              //                   ds.reference.delete();
              //                 }
              //               },
              //             );
              //             await _firebase
              //                 .collection('Posts')
              //                 .where('poster', isEqualTo: logedInUser.uid)
              //                 .get()
              //                 .then((snapshot) {
              //               for (DocumentSnapshot ds in snapshot.docs) {
              //                 ds.reference.delete();
              //               }
              //             });
              //             try {
              //               await _firebase
              //                   .collection('Users')
              //                   .doc(logedInUser.uid)
              //                   .delete();
              //             } catch (e) {
              //               print(e);
              //             }
              //             Navigator.pushAndRemoveUntil(
              //               context,
              //               MaterialPageRoute(
              //                 builder: (BuildContext context) =>
              //                     WelcomeScreen(),
              //               ),
              //               (route) => false,
              //             );
              //           },
              //           color: Color.fromRGBO(0, 179, 134, 1.0),
              //         ),
              //       ],
              //     ).show();
              //   },
              // ),
              SettingsTile(
                title: 'Sign out',
                leading: Icon(
                  Icons.exit_to_app,
                  color: Colors.redAccent,
                ),
                onPressed: (BuildContext context) async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WelcomeScreen(),
                      ),
                      (route) => false);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
