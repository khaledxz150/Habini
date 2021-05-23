import 'package:flutter/material.dart';
import 'package:habini/screens/welcome_screen.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components.dart';

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
                title: 'Change Profile avatar',
                leading: Icon(Icons.account_circle),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile(
                title: 'Change Password',
                leading: Icon(Icons.lock),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile(
                title: 'Change Location',
                leading: Icon(Icons.add_location_alt),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile.switchTile(
                  title: 'Dark mode',
                  leading: Icon(Icons.nights_stay),
                  switchValue: false,
                  onToggle: (bool value) {}),
              SettingsTile(
                title: 'Contact us',
                leading: Icon(Icons.contact_mail_outlined),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile(
                title: 'Delete Account',
                leading: Icon(Icons.block_flipped),
                onPressed: (BuildContext context) {},
              ),
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
