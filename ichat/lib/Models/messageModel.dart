import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ichat/helperCode/helperClasses.dart';

class Message {
  final String messageBody;
  final Timestamp createdAt;
  final String contactNo;
  final int alignmentSemaphore;
  final String sentTime;
  final String messageId;

  Message(
      {this.messageBody,
      this.createdAt,
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
        'messageId': messageId
      };

  Message.fromJson(Map<String, dynamic> map)
      : messageBody = map['messageBody'],
        createdAt = map['createdAt'],
        contactNo = map['contactNo'],
        alignmentSemaphore = map['alignmentSemaphore'],
        sentTime = map['sentTime'],
        messageId = map['messageId'];
}

class MessageTile extends StatelessWidget {
  final Message message;
  final int contactSema;
  MessageTile({@required this.message, this.contactSema});
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    int alSem = message.alignmentSemaphore;
    if (message.alignmentSemaphore == contactSema) {
      alSem = 0;
    } else {
      alSem = 1;
    }
    String timeString = message.sentTime;
    return Row(
      mainAxisAlignment:
          1 == alSem ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        Card(
          color: 1 == alSem ? Color(0xFFF2F2F7) : Colors.deepPurple,
          shadowColor: 1 == alSem ? Color(0xFFF2F2F7) : Colors.deepPurple,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          elevation: alSem == 1 ? 0 : 10,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: 1 == alSem ? Colors.blue[50] : Colors.deepPurple[800],
            ),
            child: Wrap(
              direction: Axis.vertical,
              crossAxisAlignment: WrapCrossAlignment.end,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width / 1.3,
                      minWidth: 104),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      color: 1 == alSem ? Color(0xFFF2F2F7) : Colors.deepPurple,
                    ),
                    padding: const EdgeInsets.only(
                        top: 10.0, bottom: 5, left: 10, right: 20),
                    child: RichText(
                        overflow: TextOverflow.visible,
                        maxLines: 100,
                        text: TextSpan(
                            text: message.messageBody,
                            style: DecorateText.getDecoratedTextStyle(
                                        height:height,
                                fontSize: alSem == 1 ? 14 : 12,
                                color:
                                    alSem == 1 ? Colors.blue : Colors.white))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  child: Text(
                    timeString,
                    style: DecorateText.getDecoratedTextStyle(
                                        height:height,
                        fontSize: 10,
                        color: alSem == 1 ? Colors.blue : Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
