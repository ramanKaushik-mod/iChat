import 'package:flutter/material.dart';
import 'package:ichat/helperCode/firebaseFunctions.dart';
import 'package:ichat/helperCode/helperClasses.dart';
import 'package:ichat/helperCode/helperFunctions.dart';

class VerifyNumberScreen extends StatefulWidget {
  @override
  _VerifyNumberScreenState createState() => _VerifyNumberScreenState();
}

class _VerifyNumberScreenState extends State<VerifyNumberScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Utility.exitApp(context);
        return Future<bool>.value(true);
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: body(context),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              var phoneNumber = '+91${_controller.text.trim()}';
              if (phoneNumber.length == 13) {
                showBottomModal(context,
                    dialogCode: "We will be verifying\nthe phone number\n\n "
                        "$phoneNumber\n\n "
                        "Is this OK, or would you\n like to edit the number?", okStateFunction: () {
                  showBottomModal(context,
                      dialogCode: 'Loading...');
                  FirebaseFunctions.verifyNumber(context, phoneNumber);
                });
              } else {
                showBottomModal(context,
                    dialogCode: 'Enter a valid number');
              }
            },
            child: Icon(Icons.arrow_forward_ios_sharp),
          ),
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
                text: "Enter your phone number",
                height: height,
                color: Colors.blue,
                fontWeight: FontWeight.w600),
            SizedBox(
              height: 20,
            ),
            DecorateText.getDecoratedText(
                text:
                    "iChat will send an SMS message to verify your phone number",
                height: height,
                color: Colors.grey[500],
                fontWeight: FontWeight.w600,
                little: 'little'),
            SizedBox(
              height: 30,
            ),
            Container(
              width: width / 2,
              child: TextField(
                autofocus: true,
                controller: _controller,
                style: DecorateText.getDecoratedNumberStyle(),
                textAlign: TextAlign.center,
                cursorColor: Colors.blue,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(width: 2, color: Colors.grey[300])),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
