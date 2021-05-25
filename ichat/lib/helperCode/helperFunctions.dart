import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ichat/helperCode/helperClasses.dart';

showBottomModal(BuildContext context,
    {String dialogCode,
    Function login,
    Function showBottomSheet,
    Function editStateFunction,
    Function okStateFunction}) {
  final height = MediaQuery.of(context).size.height;
  return showModalBottomSheet(
      elevation: 0,
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      builder: (BuildContext c) {
        return Wrap(
          children: [
            Container(
              height: dialogCode[0] != "W" ? 64 : 200,
              margin: EdgeInsets.only(top: 10, left: 10, right: 10),
              child: Row(
                mainAxisAlignment: dialogCode == "Loading..."
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.center,
                children: [
                  if (dialogCode == "Loading..." ||
                      dialogCode == "detecting SMS code") ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 40.0, right: 20),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.blue[100]),
                      ),
                    ),
                  ],
                  Card(
                    color: Color(0xFFF2F2F7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 10,
                                      child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                       child: Text(dialogCode,
                                  style: DecorateText.getDecoratedTextStyle(
                                    height: height,
                                    fontSize: 14,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                    ),
                  ),
                ],
              ),
            ),
            if (dialogCode.toString().trim().length > 50) ...[
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: FloatingActionButton(
                      backgroundColor: Colors.white,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: DecorateText.getDecoratedText(
                          text: 'Edit',
                          fontWeight: FontWeight.w600,
                          color: Colors.deepOrange,
                          height: height),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: FloatingActionButton(
                      backgroundColor: Colors.white,
                      onPressed: () async {
                        // login();
                        Future.delayed(Duration(milliseconds: 20), () {
                          okStateFunction();
                        });
                        Navigator.of(context).pop();
                      },
                      child: DecorateText.getDecoratedText(
                          text: 'Ok',
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                          height: height),
                    ),
                  )
                ],
              )
            ]
          ],
        );
      });
}
