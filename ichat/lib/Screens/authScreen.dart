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
  String vefiId = "";

  String _phoneNumber = "", smsCode = '';
  int flag = 0, reToken, timerCount = 30;

  TextEditingController _controller = TextEditingController();
  TextEditingController _controllerSMS = TextEditingController();

  _login() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try{
      auth.verifyPhoneNumber(
        phoneNumber: "+91$_phoneNumber",
        verificationCompleted: (PhoneAuthCredential credential) async {
          showLoadingDialog(context, "Connecting");
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
            showDialogue(context, 'The provided phone number is not valid.');
          } else {
            showDialogue(context, e.toString());
          }
          // Handle other errors
        },
        codeSent: (String verificationId, int resendToken) async {
          setState(() {
            flag = 1;
          });
          countDownTimer();
          vefiId = verificationId;
          reToken = resendToken;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          vefiId = verificationId;
          showDialogue(context, "enter the code");
        },
        // codeAutoRetrievalTimeout:
      );
    }on FirebaseAuthException catch(e){
      if(e.code == "captcha-check-failed"){
        showDialogue(context, "check your internet connection");
      }else if(e.code == "invalid-phone-number"){
        showDialogue(context, "invalid phone number");
      }else if(e.code == "user-disabled"){
        showDialogue(context, "this number is disabled");
      }else{
        showDialogue(context, "this number is disabled");
      }
    }
  }

  _signInUser(context) async {
    if(_controllerSMS.text.trim().length == 6){
      Timer(Duration(milliseconds: 100), () {
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.blue),
        );
      });
      try{
        AuthCredential credential = PhoneAuthProvider.credential(
            verificationId: vefiId, smsCode: smsCode);
        await FirebaseAuth.instance.signInWithCredential(credential);

        if (FirebaseAuth.instance.currentUser != null) {
          await Utility.addLoginStatus();
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => ProfileScreen()));
        }
      }on FirebaseAuthException catch(e){
        if(e.code == 'invalid-verification-code'){
          showDialogue(context, "invalid code");
        }else{
          showDialogue(context, e.toString());
        }
      }
    }else if(_controllerSMS.text.trim().isEmpty){
      showDialogue(context, "provide a code");
    }else if(_controllerSMS.text.trim().length != 6){
      showDialogue(context, "enter the 6 digit code");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                flag != 0 ? _secondPage() : _firstPage(),
                bottomButton(),
              ],
            )
          ],
        ));
  }

  confirmNumber(BuildContext context, String e) {
    showDialog(
        context: context,
        builder: (BuildContext c) => AlertDialog(
              contentPadding: EdgeInsets.all(0),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              content: Wrap(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20, bottom: 10, left: 20.0, right: 20),
                    child: Text("We will be verifying the phone number",
                        style: GoogleFonts.muli(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.black)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 10, left: 20.0, right: 20),
                    child: Text(e,
                        style: GoogleFonts.muli(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 20, left: 20.0, right: 20),
                    child: Text(
                        "Is this OK, or would you like to edit the number?",
                        style: GoogleFonts.muli(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.black)),
                  ),
                ],
              ),
              actions: [
                FloatingActionButton(
                  backgroundColor: Colors.white,
                  onPressed: () {
                    Timer(Duration(milliseconds: 100), () {
                      Navigator.of(context).pop();
                    });
                  },
                  child: Text(
                    "Edit",
                    style: GoogleFonts.muli(
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
                FloatingActionButton(
                  backgroundColor: Colors.white,
                  onPressed: () {
                    _controller.text = "";
                    _phoneNumber = e;
                    _login();
                    Timer(Duration(milliseconds: 50), () {
                      showLoadingDialog(context, "Loading...");
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Ok",
                    style: GoogleFonts.muli(
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
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
              "Waiting to automatically detect an SMS sent to $_phoneNumber",
              style: GoogleFonts.muli(
                  fontWeight: FontWeight.w300,
                  fontSize: width / 28,
                  color: Colors.grey[800]),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  flag = 0;
                });
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
                  color: Colors.grey[800]
              ),
            ),
            SizedBox(height: 16,),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:26.0, vertical: 4),
                      child: Text(
                        "Resent SMS",
                        style: GoogleFonts.muli(
                            fontWeight: FontWeight.w500,
                            fontSize: width / 26,
                            color: Colors.grey[800]
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:26.0, vertical: 4),
                      child: Text(
                        "0 : $timerCount",
                        style: GoogleFonts.muli(
                            fontWeight: FontWeight.w500,
                            fontSize: width / 26,
                            color: Colors.grey[800]
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Divider(thickness: 1, color: Colors.grey[400],),
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
                autofocus: true,
                controller: _controller,
                style: TextStyle(fontSize: width / 20, color: Colors.black),
                textAlign: TextAlign.center,
                cursorColor: Colors.blue,
                keyboardType: TextInputType.number,
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
    for (int x = 30; x > 0; x--) {
      await Future.delayed(Duration(seconds: 1)).then((_) {
        setState(() {
          timerCount -= 1;
        });
      });
    }
  }

  bottomButton(){
    return Container(
      margin: EdgeInsets.all(20),
      child: FloatingActionButton(
        onPressed: () {
          if (flag == 0) {
            if (_controller.text.isEmpty) {
              showDialogue(context, "Number is Required");
            } else if (_controller.text.length != 10) {
              showDialogue(context, "Contact Number Length != 10");
              _controller.text = "";
            } else {
              confirmNumber(context, _controller.text.trim());
            }
          } else if(flag == 1) {
            _signInUser(context);
          }
        },
        child: Icon(Icons.arrow_forward_ios_sharp),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
    _controllerSMS.dispose();
  }
}
