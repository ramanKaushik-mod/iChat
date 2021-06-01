import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ichat/helperCode/firebaseFunctions.dart';
import 'package:ichat/helperCode/helperClasses.dart';
import 'package:ichat/helperCode/helperFunctions.dart';
import 'package:provider/provider.dart';

class ActiveContactModel {
  final String name;
  final String contactNo;
  final String lastMessage;
  final int alignmentSemaphore;
  Timestamp lastMsgTime;
  bool activeStatus;
  bool userActive;
  int unreadMessages;

  ActiveContactModel(
      {this.contactNo = '',
      this.name = '',
      this.lastMessage = '',
      this.alignmentSemaphore,
      this.lastMsgTime,
      this.userActive=false,
      this.activeStatus = true,
      this.unreadMessages = 0});

  ActiveContactModel.fromMap(Map<String, dynamic> map)
      : contactNo = map['contactNo'],
        lastMessage = map['lastMessage'],
        alignmentSemaphore = map['alignmentSemaphore'],
        lastMsgTime = map['lastMsgTime'],
        activeStatus = map['activeStatus'],
        unreadMessages = map['unreadMessages'],
        userActive = map['userActive'],
        name = map['name'];

  Map<String, dynamic> toJson() => {
        'name': this.name,
        'contactNo': this.contactNo,
        'lastMessage': this.lastMessage,
        'alignmentSemaphore': this.alignmentSemaphore,
        'lastMsgTime': this.lastMsgTime,
        'activeStatus': this.activeStatus,
        'unreadMessages': this.unreadMessages,
        'userActive':this.userActive
      };
}

class ActiveContactTile extends StatefulWidget {
  final ActiveContactModel model;
  final String contactID;
  ActiveContactTile({@required this.model, this.contactID});

  @override
  _ActiveContactTileState createState() => _ActiveContactTileState();
}

class _ActiveContactTileState extends State<ActiveContactTile> {
  HandlingFirebaseDB handlingFirebaseDB;
  String timeString;
  DateTime dateTime;
  bool flag = false, flag2 = false;
  @override
  void initState() {
    super.initState();
    getDBInstance();
  }

  getDBInstance() async {
    handlingFirebaseDB = HandlingFirebaseDB(contactID: widget.contactID);
  }

  setAllMsgC() async {
    await Utility.setAllMsgC(1);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    if (widget.model.unreadMessages != 0 && flag2 == false) {
      setAllMsgC();
      if (flag2 == false) {
        Provider.of<GetChanges>(context, listen: false).updateChatCount();
        setState(() {
          flag2 = true;
        });
      }
    }
    if (widget.model.unreadMessages == 0 && flag2 == true) {
      Provider.of<GetChanges>(context, listen: false).updateChatCount();
      setState(() {
        flag2 = false;
      });
    }

    if (widget.model.unreadMessages == 0 && flag != false) {
      setState(() {
        flag = false;
      });
    }
    return InkWell(
      onTap: () async {
        if (widget.model.unreadMessages != 0 && flag == false) {
          await Utility.setAllMsgC(-1);
          Provider.of<GetChanges>(context, listen: false).updateChatCount();
          setState(() {
            flag = true;
          });
        }
        Future.delayed(Duration(milliseconds: 10), () async {
          await handlingFirebaseDB.setMsgCountToZero(
              otherContactId: widget.model.contactNo);
        });
        Navigator.pushNamed(context, '/messageScreen',
            arguments: widget.model.toJson());
      },
      onLongPress: () {
        bottomModalForMainScreenDeleteOperations(context,
            contactId: widget.contactID,
            otherContactId: widget.model.contactNo);
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        elevation: 20,
        color: Color(0xFFF2F2F7),
        shadowColor: Color(0xFFF2F2F7),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
              StreamBuilder<DocumentSnapshot>(
                  stream: handlingFirebaseDB
                      .getUserDocOfOther(otherContactId: widget.model.contactNo)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (!snapshot.hasData || snapshot.hasError) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFFF2F2F7)),
                        ),
                      );
                    }
                    if (widget.model.lastMsgTime != null) {
                      dateTime = widget.model.lastMsgTime.toDate();
                    }

                    Map<String, dynamic> map = snapshot.data.data();
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 30,
                        child: CircleAvatar(
                          backgroundColor: Color(0xFFF2F2F7),
                          radius: 26,
                          child: CircleAvatar(
                            backgroundColor: Color(0xFFF2F2F7),
                            radius: 24,
                            child: map['imageStr'] != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.memory(
                                      base64Decode(map['imageStr']),
                                      fit: BoxFit.fill,
                                    ))
                                : Icon(Icons.person),
                          ),
                        ),
                      ),
                    );
                  }),
              Expanded(
                child: Card(
                  elevation: 20,
                  margin: EdgeInsets.all(5),
                  color: Colors.deepPurple,
                  shadowColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17)),
                  child: Container(
                    padding: EdgeInsets.only(right: 10),
                    margin: EdgeInsets.only(left: 10),
                    height: 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                                child: RichText(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                        text: widget.model.name,
                                        style:
                                            DecorateText.getDecoratedTextStyle(
                                                height: height,
                                                fontSize: 17,
                                                color: Colors.white)))),
                            if (widget.model.unreadMessages != 0) ...[
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 4),
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.green,
                                ),
                                child: Center(
                                  child: Text(
                                    '${widget.model.unreadMessages}',
                                    style: DecorateText.getDecoratedTextStyle(
                                        height: height,
                                        fontSize: 14,
                                        color: Colors.white),
                                  ),
                                ),
                              )
                            ]
                          ],
                        ),
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
                                        style:
                                            DecorateText.getDecoratedTextStyle(
                                                height: height,
                                                fontSize: 11,
                                                color: Colors.white)))),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: StreamBuilder<DocumentSnapshot>(
                                  stream: handlingFirebaseDB
                                      .getChatDoc(
                                          otherContactId:
                                              widget.model.contactNo)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData ||
                                        snapshot.hasError) {
                                      return Text('');
                                    }
                                    Map<String, dynamic> map =
                                        snapshot.data.data();
                                    String timeString = '';
                                    if (map != null) {
                                      if (map['lastMsgTime'] != null) {
                                        dateTime = map['lastMsgTime'].toDate();
                                        timeString =
                                            '${dateTime.day}/${dateTime.month}/${dateTime.year}';
                                      } else {
                                        timeString = '';
                                      }
                                    }
                                    return Text(
                                      dateTime != null ? timeString : '',
                                      style: DecorateText.getDecoratedTextStyle(
                                          height: height,
                                          fontSize: 11,
                                          color: Colors.white),
                                    );
                                  }),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
