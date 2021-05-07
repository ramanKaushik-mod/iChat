import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ichat/Screens/authScreen.dart';
import 'package:ichat/helperCode/helperClasses.dart';

class LogoScreen extends StatefulWidget {
  @override
  _LogoScreenState createState() => _LogoScreenState();
}

class _LogoScreenState extends State<LogoScreen> {
  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  _checkStatus() async {
    int status = await Utility.getLoginStatus();
    Future.delayed(Duration(seconds: 2), () {
      if (status == 0) {
        Navigator.pushNamed(context, '/checkPurpose');
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => AuthScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Image.asset("assets\\iChatLogo.jpg"))),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "By Mod",
                  style: GoogleFonts.laBelleAurore(
                      fontWeight: FontWeight.w600,
                      fontSize: 25,
                      color: Colors.grey[350]),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
