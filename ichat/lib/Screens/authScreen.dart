import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ichat/Screens/profileScreen.dart';
import 'package:ichat/helperCode/helperClasses.dart';
import 'package:ichat/helperCode/helperFunctions.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  FocusNode _focusNode;
  String vefiId = "";

  int toggle = 0;
  String _phoneNumber = "", smsCode = '', dialogCode;
  int flag = 0, reToken, timerCount = 30;

  TextEditingController _controller = TextEditingController();
  TextEditingController _controllerSMS = TextEditingController();

  _login() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      auth.verifyPhoneNumber(
        phoneNumber: _phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // showLoadingDialog(context, "Connecting");
          // ANDROID ONLY!

          // Sign the user in (or link) with the auto-generated credential
          await auth.signInWithCredential(credential);

          if (FirebaseAuth.instance.currentUser != null) {
            await Utility.addLoginStatus();
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => ProfileScreen()));
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            _showBottomSheet("The provided phone number is not valid.");
          } else {
            _showBottomSheet(e.toString());
          }
          // Handle other errors
        },
        codeSent: (String verificationId, int resendToken) async {
          setState(() {
            flag = 1;
            toggle = 0;
            _showBottomSheet("detecting SMS code");
            _focusNode.requestFocus();
            countDownTimer();
          });
          vefiId = verificationId;
          reToken = resendToken;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          vefiId = verificationId;
          _showBottomSheet("enter the code");
        },
        // codeAutoRetrievalTimeout:
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == "captcha-check-failed") {
        _showBottomSheet("check your internet connection");
      } else if (e.code == "invalid-phone-number") {
        _showBottomSheet("invalid phone number");
      } else if (e.code == "user-disabled") {
        _showBottomSheet("this number is disabled");
      } else {
        _showBottomSheet(e.toString());
      }
    }
  }

  _signInUser(context) async {
    if (_controllerSMS.text.trim().length == 6) {
      try {
        AuthCredential credential = PhoneAuthProvider.credential(
            verificationId: vefiId, smsCode: smsCode);
        _showBottomSheet("Loading...");
        await FirebaseAuth.instance.signInWithCredential(credential);

        if (FirebaseAuth.instance.currentUser != null) {
          await Utility.addLoginStatus();
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) => ProfileScreen()));
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'invalid-verification-code') {
          _showBottomSheet("invalid code");
        } else {
          _showBottomSheet(e.toString());
        }
      }
    } else if (_controllerSMS.text.trim().isEmpty) {
      _showBottomSheet("provide a code");
    } else if (_controllerSMS.text.trim().length != 6) {
      _showBottomSheet("enter the 6 digit code");
    }
  }

  _changeState() {
    setState(() {
      _focusNode.unfocus();
      toggle = 1;
    });

    if(dialogCode != "Loading..."){
      if(dialogCode[0] == "d"){
        Future.delayed(Duration(seconds: 32), () {
          setState(() {
            toggle = 0;
          });
        });
      }else if(dialogCode[0] != "W"){
        Future.delayed(Duration(seconds: 2), () {
          setState(() {
            toggle = 0;
            _focusNode.requestFocus();
          });
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        bottomSheet: toggle == 0
            ? null
            : bottomSheet(
            dialogCode,
            login: _login,
            showBottomSheet: _showBottomSheet,
            editStateFunction: (){
              setState(() {
                toggle = 0;
                _focusNode.requestFocus();
              });
            },
          okStateFunction: (){
              setState(() {
                toggle = 0;
              });
              _showBottomSheet("Loading...");
          }
        ),

        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                flag != 0 ? _secondPage() : _firstPage(),
                Container(
                  margin: EdgeInsets.all(10),
                  child: FloatingActionButton(
                    onPressed: () {
                      if (flag == 0) {
                        if (_controller.text.isEmpty) {
                          _showBottomSheet("Number is Required");
                        } else if (_controller.text.length != 10) {
                          _showBottomSheet("Contact Number Length != 10");
                        } else {
                          _phoneNumber = "+91${_controller.text.trim()}";
                          _showBottomSheet("We will be verifying\nthe phone number\n\n "
                              "$_phoneNumber\n\n "
                              "Is this OK, or would you\n like to edit the number?");
                        }
                      } else if (flag == 1) {
                        _signInUser(context);
                      }
                    },
                    child: Icon(Icons.arrow_forward_ios_sharp),
                  ),
                )
              ],
            )
          ],
        ));
  }

  _secondPage() {
    final width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
            ),
            Text(
              "Verify $_phoneNumber",
              style: GoogleFonts.muli(
                  fontWeight: FontWeight.w600,
                  fontSize: width / 20,
                  color: Colors.blue[500]),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Waiting to automatically detect an SMS sent",
              style: GoogleFonts.muli(
                  fontWeight: FontWeight.w300,
                  fontSize: width / 28,
                  color: Colors.grey[800]),
            ),
            Text(
              "to $_phoneNumber",
              style: GoogleFonts.muli(
                  fontWeight: FontWeight.w300,
                  fontSize: width / 28,
                  color: Colors.grey[800]),
            ),
            TextButton(
              onPressed: () {
                if(timerCount == 0){
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context)=>AuthScreen())
                  );
                }
              },
              child: Text(
                "Wrong number ?",
                style: GoogleFonts.muli(
                    fontWeight: FontWeight.w500,
                    fontSize: width / 28,
                    color: Colors.blue),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: width / 3,
              child: TextField(
                autofocus: true,
                controller: _controllerSMS,
                style: TextStyle(fontSize: 20, color: Colors.black),
                textAlign: TextAlign.center,
                showCursor: false,
                keyboardType: TextInputType.number,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(width: 2, color: Colors.grey[300])),
                  hintText: "- - -  - - -",
                  hintStyle:
                      TextStyle(fontSize: width / 10, color: Colors.grey[500]),
                ),
                onChanged: (value) {
                  smsCode = value;
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Enter 6-digit code",
              style: GoogleFonts.muli(
                  fontWeight: FontWeight.w500,
                  fontSize: width / 28,
                  color: Colors.grey[800]),
            ),
            SizedBox(
              height: 16,
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 26.0, vertical: 4),
                      child: Text(
                        "Resend SMS",
                        style: GoogleFonts.muli(
                            fontWeight: FontWeight.w500,
                            fontSize: width / 26,
                            color: Colors.grey[800]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 26.0, vertical: 4),
                      child: Text(
                        "0 : $timerCount",
                        style: GoogleFonts.muli(
                            fontWeight: FontWeight.w500,
                            fontSize: width / 26,
                            color: Colors.grey[800]),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Divider(
                    thickness: 1,
                    color: Colors.grey[400],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  _firstPage() {
    final width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
            ),
            Text(
              "Enter your phone number",
              style: GoogleFonts.muli(
                  fontWeight: FontWeight.w600,
                  fontSize: width / 20,
                  color: Colors.blue[500]),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "iChat will send an SMS message to verify your phone number",
              style: GoogleFonts.muli(
                  fontWeight: FontWeight.w300,
                  fontSize: width / 28,
                  color: Colors.grey[800]),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: width / 2,
              child: TextField(
                autofocus: toggle == 0 ? true : false,
                controller: _controller,
                style: TextStyle(fontSize: width / 20, color: Colors.black),
                textAlign: TextAlign.center,
                cursorColor: Colors.blue,
                keyboardType: TextInputType.number,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(width: 2, color: Colors.grey[300])),
                ),
                onChanged: (value) {},
              ),
            )
          ],
        ),
      ),
    );
  }

  countDownTimer() async {
    while(timerCount > 0) {
      await Future.delayed(Duration(seconds: 1)).then((_) {
        setState(() {
          timerCount -= 1;
        });
      });
    }
  }

  _showBottomSheet(code) {
    dialogCode = code;
    _changeState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
    _controllerSMS.dispose();
    _focusNode.dispose();
  }
}
