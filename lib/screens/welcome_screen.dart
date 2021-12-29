import 'package:flutter/material.dart';
import 'package:habini/components.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: TypewriterAnimatedTextKit(
                speed: Duration(milliseconds: 700),
                text: ['5abini'],
                textStyle: GoogleFonts.koHo(
                  color: UniformColor,
                  fontSize: 50,
                ),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: KmaterialButton(
                      color: UniformColor,
                      label: 'Log In',
                      onPressed: () {
                        Navigator.pushNamed(
                            context, 'university_number_auth_screen');
                      }),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
