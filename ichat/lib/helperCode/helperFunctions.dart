import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';


exit(){
  SystemNavigator.pop();
}

showDialogue(BuildContext context, String e) {
  return showDialog(
      context: context,
      builder: (BuildContext c){
        Timer(Duration(seconds: 3),(){
          Navigator.of(context).pop();
        });
        return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            backgroundColor: Colors.transparent,
            content: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              child: Wrap(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        e,
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
      });
}




showLoadingDialog(BuildContext context, String e) {
  final width = MediaQuery.of(context).size.width;
  return showDialog(
      context: context,
      builder: (BuildContext c){
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          backgroundColor: Colors.transparent,
          content: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            child: Wrap(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.blue),
                        ),
                        SizedBox(width: 20,),
                        Text(
                          e,
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w500,
                            fontSize: width/24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

showLoadingBottomModal(context){
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext c){
        return Wrap(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(padding: const EdgeInsets.only(left:40.0, right: 20),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.blue[100]),
                  ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Loading...",
                      style: GoogleFonts.muli(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600]
                      )
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      }
  );
}


bottomSheet(dialogCode, {
  Function login,
  Function showBottomSheet,
  Function editStateFunction,
  Function okStateFunction
}){
  return BottomSheet(
    enableDrag: false,
    builder: (BuildContext context) {
      return Wrap(
        children: [
          Container(
            height: dialogCode[0] != "W"?60: 200,
            margin: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: dialogCode == "Loading..." || dialogCode == "detecting SMS code"
                  ?MainAxisAlignment.start
                  :MainAxisAlignment.center,
              children: [
                if(dialogCode == "Loading..." || dialogCode == "detecting SMS code")...[
                  Padding(
                    padding:
                    const EdgeInsets.only(left: 40.0, right: 20),
                    child: CircularProgressIndicator(
                      valueColor:
                      AlwaysStoppedAnimation(Colors.blue[100]),
                    ),
                  ),
                ],
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(dialogCode,
                      style: GoogleFonts.muli(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600])),
                ),
              ],
            ),
          ),
          if(dialogCode.toString().trim().length > 50 )...[
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: () {

                      editStateFunction();

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
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: () {

                      login();
                      okStateFunction();

                    },
                    child: Text(
                      "Ok",
                      style: GoogleFonts.muli(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                )
              ],
            )
          ]
        ],
      );
    },
    onClosing: () {},
  );
}
