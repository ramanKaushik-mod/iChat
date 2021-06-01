import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ichat/helperCode/helperClasses.dart';
import 'package:ichat/helperCode/helperFunctions.dart';

class Message {
  final String messageBody;
  final Timestamp createdAt;
  final String contactNo;
  final int alignmentSemaphore;
  final String sentTime;
  final String sentDate;
  final String messageId;

  Message(
      {this.messageBody,
      this.createdAt,
      this.sentDate,
      this.contactNo,
      this.alignmentSemaphore,
      this.sentTime,
      this.messageId});

  Map<String, dynamic> toJson() => {
        'messageBody': messageBody,
        'createdAt': createdAt,
        'contactNo': contactNo,
        'alignmentSemaphore': alignmentSemaphore,
        'sentTime': sentTime,
        'messageId': messageId,
        'sentDate': sentDate
      };

  Message.fromJson(Map<String, dynamic> map)
      : messageBody = map['messageBody'],
        createdAt = map['createdAt'],
        contactNo = map['contactNo'],
        alignmentSemaphore = map['alignmentSemaphore'],
        sentTime = map['sentTime'],
        sentDate = map['sentDate'],
        messageId = map['messageId'];
}

class MessageTile extends StatelessWidget {
  final Message message;
  final AsyncSnapshot<QuerySnapshot> lastSnapShot;
  final int contactSema;
  final String otherContactId;
  final String cd;
  MessageTile(
      {@required this.message,
      this.contactSema,
      this.otherContactId,
      this.lastSnapShot,
      this.cd});
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    int alSem = message.alignmentSemaphore;
    if (message.alignmentSemaphore == contactSema) {
      alSem = 0;
    } else {
      alSem = 1;
    }
    String timeString = message.sentTime;
    return Wrap(
                  direction: Axis.horizontal,
                  crossAxisAlignment: WrapCrossAlignment.center,

      children: [
        if(cd != null)...[showDate(date:message.sentDate, height:height),],
        InkWell(
          onLongPress: () async {
            await bottomModalForMessageScreenDeleteOperations(context,
                contactId: await Utility.getContactFromPreference(),
                alSem: alSem,
                lastSnapShot: lastSnapShot,
                msgTime: message.createdAt,
                messageId: message.messageId,
                otherContactId: otherContactId);
          },
          child: Row(
            mainAxisAlignment:
                1 == alSem ? MainAxisAlignment.start : MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                color: 1 == alSem ? Colors.black : Colors.deepPurple,
                shadowColor: 1 == alSem ? Colors.black : Colors.deepPurple,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                margin: EdgeInsets.only(
                    left: alSem == 1 ? 10 : 4,
                    right: alSem == 1 ? 4 : 10,
                    top: 5,
                    bottom: 5),
                elevation: alSem == 1 ? 20 : 20,
                child: Wrap(
                  direction: Axis.vertical,
                  crossAxisAlignment: WrapCrossAlignment.end,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: width / 1.1,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:
                              1 == alSem ? Colors.black : Colors.deepPurple,
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 12),
                        child: RichText(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 100,
                            text: TextSpan(
                                text: message.messageBody,
                                style: DecorateText.getDecoratedTextStyle(
                                    height: height,
                                    fontSize: alSem == 1 ? 14 : 13,
                                    color: alSem == 1
                                        ? Colors.white
                                        : Colors.white))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0, bottom: 2),
                      child: Text(
                        timeString,
                        style: DecorateText.getDecoratedTextStyle(
                            height: height,
                            fontSize: 10,
                            color: alSem == 1 ? Colors.white : Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
