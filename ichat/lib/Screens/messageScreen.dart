import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ichat/helperCode/firebaseFunctions.dart';
import 'package:ichat/helperCode/helperClasses.dart';
import 'package:ichat/models/messageModel.dart';

class MessageScreen extends StatefulWidget {
  final Map<String, dynamic> contactModel;
  MessageScreen({this.contactModel});

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  Future<int> readyDB;
  HandlingFirebaseDB handlingFirebaseDB;
  TextEditingController _controller = TextEditingController();
  FocusNode focusNode;
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('Chats');
  String lastMSG;
  bool flag = false;
  @override
  void initState() {
    super.initState();
    getDBInstance();
    focusNode = FocusNode();
  }

  getDBInstance() async {
    await Utility.setChatGlobalStatus(true);
    handlingFirebaseDB =
        HandlingFirebaseDB(contactID: await Utility.getContactFromPreference());
    flag = await handlingFirebaseDB.checkContactInContacts(
        otherContactId: widget.contactModel['contactNo']);
    handlingFirebaseDB.changeContactChatStatus(status: true);
    setState(() {
      readyDB = Future.value(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    var expanded = Expanded(
      child: FutureBuilder<int>(
        future: readyDB,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return StreamBuilder<QuerySnapshot>(
                stream: handlingFirebaseDB.getChatMessagesAsStream(
                    otherContactId: widget.contactModel['contactNo']),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFFF2F2F7)),
                      ),
                    );
                  }
                  if (snapshot.data.docs.length > 0) {
                    Map<String, dynamic> map = snapshot.data.docs.last.data();
                    lastMSG = map['messageBody'];
                  }
                  List<Widget> messageList = [];
                  String str = '';
                  if (snapshot.data.docs.length != 0) {
                    messageList = snapshot.data.docs.map((e) {
                      if (str != e.data()['sentDate']) {
                        str = e.data()['sentDate'];

                        return MessageTile(
                          otherContactId: widget.contactModel['contactNo'],
                          message: Message.fromJson(e.data()),
                          contactSema:
                              widget.contactModel['alignmentSemaphore'],
                          lastSnapShot: snapshot,
                          cd: 'not null',
                        );
                      } else {
                        return MessageTile(
                          otherContactId: widget.contactModel['contactNo'],
                          message: Message.fromJson(e.data()),
                          contactSema:
                              widget.contactModel['alignmentSemaphore'],
                          lastSnapShot: snapshot,
                        );
                      }
                    }).toList();
                  }

                  return SingleChildScrollView(
                    reverse: true,
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: messageList),
                  );
                });
          }
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF2F2F7)),
            ),
          );
        },
      ),
    );
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          await Utility.setChatGlobalStatus(false);
          Future.delayed(Duration(seconds: 1), () async {
            await handlingFirebaseDB.changeContactChatStatus(status: false);
          });
          Navigator.pop(context);
          return Future.value(true);
        },
        child: Scaffold(
          backgroundColor: Color(0xFFF2F2F7),
          appBar: _appBar(context, height),
          body: Container(
            decoration: BoxDecoration(color: Color(0xFFF2F2F7)),
            height: height,
            width: width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [expanded, _bottomSheet(context, height)],
            ),
          ),
        ),
      ),
    );
  }

  _appBar(context, height) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: GestureDetector(
          onTap: () async {
            await Utility.setChatGlobalStatus(true);
            Future.delayed(Duration(seconds: 1), () async {
              await handlingFirebaseDB.changeContactChatStatus(status: false);
            });
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_outlined,
            color: Colors.grey[400],
          )),
      title: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Color(0xFFF2F2F7),
            elevation: 4,
            shadowColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            )),
        onPressed: () {
          //TODO profile screen that'll display the friend's information
        },
        child: FutureBuilder(
          future: readyDB,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return StreamBuilder<DocumentSnapshot>(
                  stream: handlingFirebaseDB.getOtherContactCredentialsAsStream(
                      otherContactId: widget.contactModel['contactNo']),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFFF2F2F7)),
                      );
                    }
                    Map<String, dynamic> map = snapshot.data.data();
                    if (widget.contactModel['name'] != map['name']) {
                      Future.delayed(Duration(milliseconds: 10), () async {
                        await handlingFirebaseDB
                            .updateOtherNameInActiveContactList(
                                otherContactId:
                                    widget.contactModel['contactNo'],
                                name: map['name']);
                      });
                    }
                    return Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.end,
                      children: [
                        RichText(
                            maxLines: 1,
                            text: TextSpan(
                                text: map['name'],
                                style: DecorateText.getDecoratedTextStyle(
                                    height: height,
                                    fontSize: 16,
                                    color: Colors.deepPurple))),
                        if (map['contactChatStatus'] == true &&
                            flag == true) ...[
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.circle,
                            color: Colors.green,
                            size: 8,
                          )
                        ]
                      ],
                    );
                  });
            }
            return CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF2F2F7)),
            );
          },
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  _bottomSheet(context, height) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      height: 90,
      width: MediaQuery.of(context).size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Card(
              margin: EdgeInsets.only(right: 15),
              color: Color(0xFFF2F2F7),
              elevation: 10,
              shadowColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Container(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 3, bottom: 3),
                // margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Color(0xFFF2F2F7),
                ),
                child: TextField(
                  enabled: flag,
                  textAlignVertical: TextAlignVertical.center,
                  textCapitalization: TextCapitalization.sentences,
                  controller: _controller,
                  style: DecorateText.getDecoratedTextStyle(
                      height: height, fontSize: 18, color: Colors.deepPurple),
                  textAlign: TextAlign.start,
                  keyboardType: TextInputType.multiline,
                  cursorColor: Colors.white,
                  maxLines: 5,
                  minLines: 1,
                  // expands: true,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Text message',
                      hintStyle: DecorateText.getDecoratedTextStyle(
                          height: height,
                          fontSize: 18,
                          color: Colors.deepPurple)),
                ),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.deepPurple,
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50))),
            onPressed: () async {
              // send message to firebase
              if (_controller.text.trim().isNotEmpty) {
                var message = _controller.text.trim();
                _controller.clear();
                DateTime dateTime = DateTime.now();
                await handlingFirebaseDB.doMessage(
                    message: Message(
                        messageBody: message,
                        createdAt: Timestamp.now(),
                        contactNo: widget.contactModel['contactNo'],
                        alignmentSemaphore:
                            widget.contactModel['alignmentSemaphore'],
                        sentTime: '${dateTime.hour} : ${dateTime.minute}',
                        sentDate:
                            '${dateTime.year}-${dateTime.month}-${dateTime.day}',
                        messageId: await handlingFirebaseDB.newChatRef(
                            otherContactId: widget.contactModel['contactNo'])));

                if (lastMSG != null) {
                  Future.delayed(Duration(milliseconds: 10), () async {
                    await handlingFirebaseDB.updateLastMessage(
                        otherContactId: widget.contactModel['contactNo'],
                        lastMessage: lastMSG);
                  });
                }

                handlingFirebaseDB.checkUserActiveOrNot(
                    otherContactId: widget.contactModel['contactNo']);
              }
            },
            child: Icon(
              Icons.arrow_upward,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
