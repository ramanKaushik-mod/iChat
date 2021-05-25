import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ichat/helperCode/firebaseFunctions.dart';
import 'package:ichat/helperCode/helperClasses.dart';
import 'package:provider/provider.dart';

class UserModel {
  final String name;
  final String imageStr;
  final String contactNo;
  final String contactStatus;
  final bool contactChatStatus;

  UserModel(
      {this.name,
      this.imageStr,
      this.contactNo,
      this.contactStatus = "Hey there, i am using iChat",
      this.contactChatStatus = false});

  UserModel.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        imageStr = map['imageStr'],
        contactNo = map['contactNo'],
        contactStatus = map['contactStatus'],
        contactChatStatus = map['contactChatStatus'];

  Map<String, dynamic> toJson() => {
        'name': this.name,
        'imageStr': this.imageStr,
        'contactNo': this.contactNo,
        'contactStatus': this.contactStatus,
        'contactChatStatus': this.contactChatStatus,
      };
}

class UserTile extends StatefulWidget {
  final UserModel userModel;
  final String buttonText;
  final Function notifyChanges, optional;

  UserTile(
      {@required this.buttonText,
      // @required this.map,
      this.userModel,
      this.notifyChanges,
      this.optional});

  @override
  _UserTileState createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  HandlingFirebaseDB handlingFirebaseDB;
  @override
  void initState() {
    super.initState();
    getDBInstance();
  }

  getDBInstance() async {
    handlingFirebaseDB =
        HandlingFirebaseDB(contactID: await Utility.getContactFromPreference());
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Card(
      margin: EdgeInsets.all(10),
      color: Color(0xFFF2F2F7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      shadowColor: Color(0xFFF2F2F7),
      elevation: 20,
      child: Container(
        width: width,
        height: 90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10),
                      child: Card(
                          elevation: 20,
                          color: Color(0xFFF2F2F7),
                          shadowColor: Color(0xFFF2F2F7),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                        child: CircleAvatar(
                          backgroundColor: Colors.deepPurple,
                          radius: 26,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 25,
                            child: CircleAvatar(
                              backgroundColor: Colors.blue[50],
                              radius: 24,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: widget.userModel.imageStr != null
                                      ? Image.memory(
                                          base64Decode(widget.userModel.imageStr),
                                          fit: BoxFit.fill,
                                        )
                                      : Icon(Icons.person)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Card(
                          elevation: 20,
                          color: Color(0xFFF2F2F7),
                          shadowColor: Color(0xFFF2F2F7),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.transparent),
                        height: 60,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              widget.userModel.name,
                              style: GoogleFonts.muli(
                                  fontSize: height / 48,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600),
                            ),
                            Divider(
                              height: 4,
                            ),
                            Text(
                              widget.userModel.contactNo,
                              style: GoogleFonts.muli(
                                fontSize: height / 54,
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              // alignment: Alignment.centerRight,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: Card(
                          elevation: 20,
                          color: Color(0xFFF2F2F7),
                          shadowColor: Color(0xFFF2F2F7),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                  child: TextButton(
                      onPressed: () async {
                        //for request and cancel operations
                        if (widget.buttonText == 'request') {
                          var changBtnText =
                              Provider.of<GetChanges>(context, listen: false);
                          changBtnText.updateBtnText();
                          await handlingFirebaseDB.updateRequest(
                              otherContactId: widget.userModel.contactNo);
                          widget.notifyChanges();
                          changBtnText.setBtnText();
                        } else if (widget.buttonText == 'cancel') {
                          widget.notifyChanges();
                        }
                      },
                      child: widget.buttonText != 'cancel'
                          ? Consumer<GetChanges>(
                              builder:
                                  (BuildContext context, value, Widget child) {
                                return Text(value.getbtnText());
                              },
                            )
                          : Text(widget.buttonText)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
