import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ichat/helperCode/helperClasses.dart';
import 'package:provider/provider.dart';

class UserTile extends StatelessWidget {
  final Map<String, dynamic> map;
  final String buttonText;
  final Function notifyChanges, optional;

  UserTile(
      {@required this.buttonText,
      @required this.map,
      this.notifyChanges,
      this.optional});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.all(10),
      width: width,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 10),
                child: CircleAvatar(
                  backgroundColor: Color(0xFFF2F2F2),
                  radius: 26,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 22,
                    child: CircleAvatar(
                      backgroundColor: Colors.blue[50],
                      radius: 20,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.memory(
                            base64Decode(map['imageStr']),
                            fit: BoxFit.fill,
                          )),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blue[50]),
                height: 60,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      map['name'],
                      style: GoogleFonts.muli(
                          fontSize: height / 48,
                          color: Colors.blue,
                          fontWeight: FontWeight.w600),
                    ),
                    Divider(
                      height: 4,
                    ),
                    Text(
                      map['contactNo'],
                      style: GoogleFonts.muli(
                        fontSize: height / 54,
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            // alignment: Alignment.centerRight,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: TextButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      primary: Colors.blue[50],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      textStyle: GoogleFonts.muli(
                          fontSize: height / 54,
                          color: Colors.blue,
                          fontWeight: FontWeight.w600)),
                  onPressed: () async {
                    //for request and cancel operations
                    if (buttonText == 'request') {
                      var changBtnText =
                          Provider.of<GetChanges>(context, listen: false);
                      changBtnText.updateBtnText();
                      await FirebaseUtility.updateRequests(map);
                      notifyChanges();
                      changBtnText.setBtnText();
                    } else if (buttonText == 'cancel') {
                      notifyChanges();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: buttonText != 'cancel'
                        ? Consumer<GetChanges>(
                            builder:
                                (BuildContext context, value, Widget child) {
                              return Text(value.getbtnText());
                            },
                          )
                        : Text(buttonText),
                  )),
            ),
          )
        ],
      ),
    );
  }
}
