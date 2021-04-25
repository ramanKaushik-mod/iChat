import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ichat/helperCode/helperClasses.dart';

class UserTile extends StatelessWidget {
  final Map<String, dynamic> map;
  final String buttonText;
  final Function notifyChanges;

  UserTile({@required this.buttonText, @required this.map, this.notifyChanges});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // final height = MediaQuery.of(context).size.height;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        margin: EdgeInsets.all(10),
        width: width,
        height: 80,
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
                    radius: 30,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 26,
                      child: CircleAvatar(
                        backgroundColor: Colors.blue[50],
                        radius: 24,
                        child: Icon(Icons.person, color: Colors.blue,),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.blue[50]),
                    height: 40,
                    child: Text(
                      map['name'],
                      style: GoogleFonts.muli(
                          fontSize: 18,
                          color: Colors.blue,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: TextButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 2,
                        primary: Colors.blue[50],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        textStyle: GoogleFonts.muli(
                            fontSize: 18,
                            color: Colors.blue,
                            fontWeight: FontWeight.w600)),
                    onPressed: () async {
                      //for request and cancel operations
                      if (buttonText == 'Request') {
                        await FirebaseUtility.updateRequests(map);
                        notifyChanges();
                      } else if(buttonText == 'cancel'){
                        await FirebaseUtility.cancelRequest(
                            requested: map['contactNo'],
                            requester:
                                await Utility.getContactFromPreference());
                        // Navigator.pop(context);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal:8.0),
                      child: Text(buttonText),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}



// ClipRRect(
//                             borderRadius: BorderRadius.circular(50),
//                             child: Image.memory(
//                               base64Decode(map['imageStr']),
//                               fit: BoxFit.fill,
//                             )),