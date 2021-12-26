import 'package:flutter/material.dart';
import 'package:habini/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habini/screens/sign_in_screen.dart';
import 'package:habini/screens/settings_page.dart';
import 'package:habini/screens/add_post_screen.dart';
import 'package:habini/screens/notification_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components.dart';
Color UniformColor = Color.fromRGBO(60, 174, 163, 1);
class MyBottomNavigationBar extends StatefulWidget {
  static const TextStyle optionStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int selectedIndex = 0;

  final List<Widget> widgetOptions = [
    HomeIndex(),
    AddPost(),
    Notifications(),
    SettingScreen(),
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widgetOptions[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: UniformColor,
        onTap: onItemTapped,
      ),
    );
  }
}
