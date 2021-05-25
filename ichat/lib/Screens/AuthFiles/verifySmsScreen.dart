import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ichat/helperCode/firebaseFunctions.dart';
import 'package:ichat/helperCode/helperClasses.dart';
import 'package:ichat/helperCode/helperFunctions.dart';
import 'package:provider/provider.dart';

class VerifySmsScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  const VerifySmsScreen({@required this.data});

  @override
  _VerifySmsScreenState createState() => _VerifySmsScreenState();
}

class _VerifySmsScreenState extends State<VerifySmsScreen> {
  String phoneNumber, vefyID;
  int resendToken;
  bool flag = false;
  Timer timer;

  final TextEditingController _controllerSMS = TextEditingController();
  @override
  void initState() {
    super.initState();
    phoneNumber = widget.data['phoneNumber'];
    resendToken = widget.data['resendToken'];
    vefyID = widget.data['vefyID'];
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      Provider.of<GetChanges>(context, listen: false).updateSmsWaitingTime(
          cancelTimer: () {
        timer.cancel();
        if (FirebaseAuth.instance.currentUser == null) {
          showBottomModal(context, dialogCode: 'enter the 6 digit SMS Code');
        }
        flag = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Utility.exitApp(context);
        return Future<bool>.value(true);
      },
      child: Scaffold(
        body: body(context),
        backgroundColor: Colors.white,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (flag == true) {
              var smsCode = _controllerSMS.text.trim();
              if (smsCode.length == 6) {
                FirebaseFunctions.signInUser(
                  context,
                  smsCode: _controllerSMS.text.trim(),
                  vefyId: vefyID,
                  phoneNumber: phoneNumber,
                );
              } else {
                if (FirebaseAuth.instance.currentUser == null) {
                  showBottomModal(context,
                      dialogCode: 'enter the 6 digit SMS Code');
                }
              }
            }
          },
          child: Icon(Icons.arrow_forward_ios_sharp),
        ),
      ),
    );
  }

  body(context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
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
            DecorateText.getDecoratedText(
                text: "Waiting to automatically detect an SMS sent",
                height: height,
                fontWeight: FontWeight.w300,
                color: Colors.grey[500]),
            SizedBox(
              height: 10,
            ),
            DecorateText.getDecoratedText(
              text: "to $phoneNumber",
              height: height,
              fontWeight: FontWeight.w300,
              color: Colors.grey[800],
            ),
            TextButton(
              onPressed: () {
                if (flag == true) {
                  flag = false;
                  Provider.of<GetChanges>(context, listen: false)
                      .turnTimeTo30();
                  Navigator.pushNamed(context, '/verifyNumberScreen');
                }
              },
              child: DecorateText.getDecoratedText(
                  text: "Wrong number ?",
                  fontWeight: FontWeight.w500,
                  height: height,
                  color: Colors.blue[500],
                  little: 'little'),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue[50]),
              width: width / 3,
              child: TextField(
                autofocus: true,
                controller: _controllerSMS,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.blue[500],
                ),
                textAlign: TextAlign.center,
                showCursor: false,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  hintText: "- - -  - - -",
                  hintStyle:
                      TextStyle(fontSize: width / 10, color: Colors.grey[500]),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            DecorateText.getDecoratedText(
                text: "Enter 6-digit code",
                fontWeight: FontWeight.w500,
                height: height,
                color: Colors.grey[500],
                little: 'little'),
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
                      child: DecorateText.getDecoratedText(
                          text: "Resend SMS",
                          fontWeight: FontWeight.w500,
                          height: height,
                          color: Colors.grey[500],
                          little: 'little'),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 26.0, vertical: 4),
                        child: Consumer<GetChanges>(
                          builder: (BuildContext context, value, Widget child) {
                            return DecorateText.getDecoratedText(
                                text: "0 : ${value.time}",
                                fontWeight: FontWeight.w500,
                                height: height,
                                color: Colors.grey[500],
                                little: 'little');
                          },
                        ))
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

  @override
  void dispose() {
    _controllerSMS.dispose();
    super.dispose();
  }
}
