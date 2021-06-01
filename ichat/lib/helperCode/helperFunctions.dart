import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ichat/helperCode/firebaseFunctions.dart';
import 'package:ichat/helperCode/helperClasses.dart';
import 'package:provider/provider.dart';

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
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        dialogCode,
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

bottomModalForMainScreenDeleteOperations(context,
    {@required String contactId, @required String otherContactId}) {
  HandlingFirebaseDB handlingFirebaseDB =
      HandlingFirebaseDB(contactID: contactId);
  return showModalBottomSheet(
      context: context,
      builder: (BuildContext c) {
        final height = MediaQuery.of(context).size.height;
        return Container(
          padding: EdgeInsets.all(8),
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      elevation: 0,
                      color: Color(0xFFF2F2F7),
                      shadowColor: Color(0xFFF2F2F7),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10.0),
                        child: Text(
                          "Are you sure ?\nabout the contact : $otherContactId",
                          style: DecorateText.getDecoratedTextStyle(
                              height: height,
                              fontSize: 16,
                              color: Colors.deepPurple),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Card(
                            elevation: 20,
                            color: Color(0xFFF2F2F7),
                            shadowColor: Color(0xFFF2F2F7),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: IconButton(
                                splashColor: Colors.deepPurple,
                                splashRadius: 20,
                                onPressed: () {
                                  Future.delayed(Duration(milliseconds: 10),
                                      () {
                                    handlingFirebaseDB.removeUserCompletely(
                                        cleanUnreads: () {
                                          Provider.of<GetChanges>(context,
                                              listen: false);
                                        },
                                        otherContactId: otherContactId);
                                  });
                                  Navigator.pop(c);
                                },
                                icon: Icon(
                                  Icons.delete_outline_rounded,
                                  color: Colors.deepOrange,
                                )),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'remove contact completely',
                            style: DecorateText.getDecoratedTextStyle(
                                height: height,
                                fontSize: 16,
                                color: Colors.deepPurple),
                          ),
                        ],
                      ),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Card(
                            elevation: 20,
                            color: Color(0xFFF2F2F7),
                            shadowColor: Color(0xFFF2F2F7),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: IconButton(
                                splashColor: Colors.blue,
                                splashRadius: 20,
                                onPressed: () {
                                  Future.delayed(Duration(milliseconds: 10),
                                      () async {
                                    await handlingFirebaseDB.removeChatsOnly(
                                        otherContactId: otherContactId);
                                  });
                                  Navigator.pop(c);
                                },
                                icon: Icon(
                                  Icons.chat_bubble_outline_rounded,
                                  color: Colors.blue,
                                )),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'remove chats only',
                            style: DecorateText.getDecoratedTextStyle(
                                height: height,
                                fontSize: 16,
                                color: Colors.deepPurple),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        );
      });
}

bottomModalForMessageScreenDeleteOperations(context,
    {@required String contactId,
    @required Timestamp msgTime,
    @required int alSem,
    @required String messageId,
    @required AsyncSnapshot<QuerySnapshot> lastSnapShot,
    @required String otherContactId}) {
  HandlingFirebaseDB handlingFirebaseDB =
      HandlingFirebaseDB(contactID: contactId);
  final height = MediaQuery.of(context).size.height;
  bool alsem0 = false, both = false;
  Duration duration = DateTime.now().difference(msgTime.toDate());
  if (alSem == 0) {
    alsem0 = true;
    if (duration.inHours < 2) {
      both = true;
    }
  }
  return showModalBottomSheet(
      enableDrag: false,
      context: context,
      builder: (BuildContext c) {
        return Container(
          padding: EdgeInsets.all(8),
          child: Wrap(
            children: [
              alsem0 == true
                  ? Center(
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Card(
                                  elevation: 20,
                                  color: Color(0xFFF2F2F7),
                                  shadowColor: Color(0xFFF2F2F7),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: IconButton(
                                      splashColor: Colors.deepPurple,
                                      splashRadius: 20,
                                      onPressed: () {
                                        Future.delayed(
                                            Duration(milliseconds: 10),
                                            () async {
                                          await handlingFirebaseDB
                                              .updateLastMessageAndTime(
                                                  snapshot: lastSnapShot,
                                                  createdAt: msgTime,
                                                  otherContactId:
                                                      otherContactId);
                                          await handlingFirebaseDB
                                              .deleteMessage(
                                                  deleteType: 'single',
                                                  messageId: messageId,
                                                  otherContactId:
                                                      otherContactId);
                                        });

                                        Navigator.pop(c);
                                      },
                                      icon: Icon(
                                        Icons.delete_outline_rounded,
                                        color: Colors.deepOrange,
                                      )),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'delete for me',
                                  style: DecorateText.getDecoratedTextStyle(
                                      height: height,
                                      fontSize: 16,
                                      color: Colors.deepPurple),
                                ),
                              ],
                            ),
                            if (both == true) ...[
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Card(
                                    elevation: 20,
                                    color: Color(0xFFF2F2F7),
                                    shadowColor: Color(0xFFF2F2F7),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: IconButton(
                                        splashColor: Colors.deepPurple,
                                        splashRadius: 20,
                                        onPressed: () {
                                          Future.delayed(
                                              Duration(milliseconds: 10),
                                              () async {
                                            await handlingFirebaseDB
                                                .updateLastMessageAndTime(
                                                    snapshot: lastSnapShot,
                                                    createdAt: msgTime,
                                                    both: 'both',
                                                    otherContactId:
                                                        otherContactId);
                                            await handlingFirebaseDB
                                                .deleteMessage(
                                                    messageId: messageId,
                                                    deleteType: 'both',
                                                    otherContactId:
                                                        otherContactId);
                                          });

                                          Navigator.pop(c);
                                        },
                                        icon: Icon(
                                          Icons.delete_forever_outlined,
                                          color: Colors.deepOrange,
                                        )),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'delete for both',
                                    style: DecorateText.getDecoratedTextStyle(
                                        height: height,
                                        fontSize: 16,
                                        color: Colors.deepPurple),
                                  ),
                                ],
                              ),
                            ]
                          ],
                        ),
                      ),
                    )
                  : Center(
                      child: Container(
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Card(
                              elevation: 20,
                              color: Color(0xFFF2F2F7),
                              shadowColor: Color(0xFFF2F2F7),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: IconButton(
                                  splashColor: Colors.deepPurple,
                                  splashRadius: 20,
                                  onPressed: () {
                                    Future.delayed(Duration(milliseconds: 10),
                                        () async {
                                      await handlingFirebaseDB
                                          .updateLastMessageAndTime(
                                              snapshot: lastSnapShot,
                                              createdAt: msgTime,
                                              otherContactId: otherContactId);
                                      await handlingFirebaseDB.deleteMessage(
                                          deleteType: 'single',
                                          messageId: messageId,
                                          otherContactId: otherContactId);
                                    });

                                    Navigator.pop(c);
                                  },
                                  icon: Icon(
                                    Icons.delete_outline_rounded,
                                    color: Colors.deepOrange,
                                  )),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'delete for me',
                              style: DecorateText.getDecoratedTextStyle(
                                  height: height,
                                  fontSize: 16,
                                  color: Colors.deepPurple),
                            ),
                          ],
                        ),
                      ),
                    )
            ],
          ),
        );
      });
}

Widget showDate({@required String date, @required double height}) {
  return Wrap(
    direction: Axis.horizontal,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      Container(
        child: Column(children: [
         
      Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Colors.deepPurple,
        shadowColor: Colors.deepPurple,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:8.0, vertical: 4),
          child: Text(
            date,
            style: DecorateText.getDecoratedTextStyle(
                height: height, fontSize: 12, color: Colors.white),
          ),
        ),
      ),
      Divider(
        color: Color(0xFFF2F2F7),
        height: 2,
        thickness: 2,
      ),
        ],),
      )
    ],
  );
}
