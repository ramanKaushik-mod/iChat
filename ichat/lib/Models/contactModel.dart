import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ichat/helperCode/firebaseFunctions.dart';
import 'package:ichat/helperCode/helperClasses.dart';

class ContactModel {
  final String name;
  final String contactNo;
  final int alignmentSemaphore;

  ContactModel({this.contactNo = '', this.alignmentSemaphore, this.name});

  ContactModel.fromMap(Map<String, dynamic> map)
      : contactNo = map['contactNo'],
        name = map['name'],
        alignmentSemaphore = map['alignmentSemaphore'];

  Map<String, dynamic> toJson() => {
        'name': this.name,
        'contactNo': this.contactNo,
        'alignmentSemaphore': this.alignmentSemaphore
      };
}

class ContactTile extends StatefulWidget {
  final ContactModel model;
  final String contactID;
  ContactTile({@required this.model, @required this.contactID});

  @override
  _ContactTileState createState() => _ContactTileState();
}

class _ContactTileState extends State<ContactTile> {
  HandlingFirebaseDB handlingFirebaseDB;
  @override
  void initState() {
    super.initState();
    getDBInstance();
  }

  getDBInstance() async {
    handlingFirebaseDB = HandlingFirebaseDB(contactID: widget.contactID);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return StreamBuilder<DocumentSnapshot>(
        stream: handlingFirebaseDB
            .getUserDocOfOther(otherContactId: widget.model.contactNo)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
              ),
            );
          }
          Map<String, dynamic> map = snapshot.data.data();
          return InkWell(
            splashColor: Colors.green,
            radius: 20,
            onTap: () {
              Navigator.pushNamed(context, '/messageScreen',
                  arguments: widget.model.toJson());
            },
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
              elevation: 20,
              color: Color(0xFFF2F2F7),
              shadowColor: Color(0xFFF2F2F7),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.transparent),
                height: 80,
                width: width,
                child: Row(
                  children: [
                    Container(
                      height: 40,
                      width: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(40),
                            bottomRight: Radius.circular(40)),
                        color: Colors.green,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10),
                      child: CircleAvatar(
                        backgroundColor: Color(0xFFF2F2F7),
                        radius: 30,
                        child: CircleAvatar(
                          backgroundColor: Color(0xFFF2F2F7),
                          radius: 26,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 24,
                            child: map['imageStr'] != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.memory(
                                      base64Decode(
                                          map['imageStr']),
                                      fit: BoxFit.fill,
                                    ))
                                : Icon(Icons.person, color: Colors.blue[200]),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 80,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                                child: RichText(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                        text: map['name'],
                                        style:
                                            DecorateText.getDecoratedTextStyle(
                                                height: height,
                                                fontSize: 17,
                                                color:
                                                    Colors.deepOrangeAccent)))),
                            Flexible(
                              child: RichText(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                      // text: widget.model.contactStatus,
                                      text:
                                          map['contactStatus'],
                                      style: DecorateText.getDecoratedTextStyle(
                                          height: height,
                                          fontSize: 12,
                                          color: Colors.green))),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
