import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ichat/helperCode/firebaseFunctions.dart';
import 'package:ichat/helperCode/helperClasses.dart';

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
  final BuildContext contextOfMainScreen;

  UserTile(
      {@required this.buttonText,
      @required this.contextOfMainScreen,
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
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
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
                          radius: 27,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 24,
                            child: CircleAvatar(
                              backgroundColor: Colors.blue[50],
                              radius: 23,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: widget.userModel.imageStr != null
                                      ? Image.memory(
                                          base64Decode(
                                              widget.userModel.imageStr),
                                          fit: BoxFit.fill,
                                        )
                                      : Icon(Icons.person)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        margin: EdgeInsets.all(5),
                        elevation: 20,
                        color: Colors.deepPurple,
                        shadowColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.transparent),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Flexible(
                                  child: RichText(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(
                                          text: widget.userModel.name,
                                          style: DecorateText
                                              .getDecoratedTextStyle(
                                                  height: height,
                                                  fontSize: 17,
                                                  color: Colors.white)))),
                              Text(
                                widget.userModel.contactNo,
                                style: GoogleFonts.muli(
                                  fontSize: height / 54,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: Card(
                elevation: 20,
                color: Color(0xFFF2F2F7),
                shadowColor: Color(0xFFF2F2F7),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: IconButton(
                  splashColor: widget.buttonText != 'cancel'
                      ? Colors.deepPurple
                      : Colors.deepOrange,
                  splashRadius: 20,
                  onPressed: () async {
                    //for request and cancel operations
                    if (widget.buttonText == 'request') {
                      widget.notifyChanges();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('sending request'),
                        duration: Duration(milliseconds: 300),
                      ));

                      await handlingFirebaseDB.updateRequest(
                          otherContactId: widget.userModel.contactNo);
                    } else if (widget.buttonText == 'cancel') {
                      await widget.notifyChanges();
                      ScaffoldMessenger.of(widget.contextOfMainScreen)
                          .showSnackBar(SnackBar(
                        content: Text('request canceled'),
                        duration: Duration(milliseconds: 300),
                      ));
                    }
                  },
                  icon: widget.buttonText != 'cancel'
                      ? Icon(
                          Icons.add_circle_outline_rounded,
                          color: Colors.deepPurple,
                        )
                      : Icon(
                          Icons.cancel_outlined,
                          color: Colors.deepOrange,
                        ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
