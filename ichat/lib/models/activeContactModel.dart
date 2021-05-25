import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ichat/helperCode/firebaseFunctions.dart';
import 'package:ichat/helperCode/helperClasses.dart';

class ActiveContactModel {
  final String contactNo;
  final String lastMessage;
  final int alignmentSemaphore;
  Timestamp lastMsgTime;
  bool activeStatus;

  ActiveContactModel(
      {this.contactNo = '',
      this.lastMessage = '',
      this.alignmentSemaphore,
      this.lastMsgTime,
      this.activeStatus = true});

  ActiveContactModel.fromMap(Map<String, dynamic> map)
      : contactNo = map['contactNo'],
        lastMessage = map['lastMessage'],
        alignmentSemaphore = map['alignmentSemaphore'],
        lastMsgTime = map['lastMsgTime'],
        activeStatus = map['activeStatus'];

  Map<String, dynamic> toJson() => {
        'contactNo': this.contactNo,
        'lastMessage': this.lastMessage,
        'alignmentSemaphore': this.alignmentSemaphore,
        'lastMsgTime': this.lastMsgTime,
        'activeStatus': this.activeStatus
      };
}

class ActiveContactTile extends StatefulWidget {
  final ActiveContactModel model;
  final String contactID;

  ActiveContactTile({@required this.model, @required this.contactID});

  @override
  _ActiveContactTileState createState() => _ActiveContactTileState();
}

class _ActiveContactTileState extends State<ActiveContactTile> {
  HandlingFirebaseDB handlingFirebaseDB;
  String timeString = '';
  @override
  void initState() {
    super.initState();
    getDBInstance();
    DateTime dateTime = widget.model.lastMsgTime.toDate();
    timeString = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  getDBInstance() async {
    handlingFirebaseDB = HandlingFirebaseDB(contactID: widget.contactID);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return StreamBuilder(
      stream: handlingFirebaseDB
          .getUserDocOfOther(otherContactId: widget.model.contactNo)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData || snapshot.hasError) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF2F2F7)),
            ),
          );
        }

        return InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/messageScreen',
                arguments: widget.model.toJson());
          },
          child: Card(
            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
            elevation: 20,
            color: Color(0xFFF2F2F7),
            shadowColor: Color(0xFFF2F2F7),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                      color: Colors.deepPurple,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 30,
                      child: CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 26,
                        child: CircleAvatar(
                          backgroundColor: Color(0xFFF2F2F7),
                          radius: 24,
                          child: snapshot.data.data()['imageStr'] != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.memory(
                                    base64Decode(
                                        snapshot.data.data()['imageStr']),
                                    fit: BoxFit.fill,
                                  ))
                              : Icon(Icons.person),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(right: 10),
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
                                      text: snapshot.data.data()['name'],
                                      style: DecorateText.getDecoratedTextStyle(
                                          height: height,
                                          fontSize: 17,
                                          color: Colors.deepPurple)))),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                  child: RichText(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(
                                          text: widget.model.lastMessage,
                                          style: DecorateText
                                              .getDecoratedTextStyle(
                                                  height: height,
                                                  fontSize: 11,
                                                  color: Colors.deepPurple)))),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  timeString,
                                  style: DecorateText.getDecoratedTextStyle(
                                      height: height,
                                      fontSize: 11,
                                      color: Colors.deepPurple),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
