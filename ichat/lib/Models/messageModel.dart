import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ichat/helperCode/helperClasses.dart';

class Message {
  final String messageBody;
  final Timestamp createdAt;
  final String contactNo;
  final int alignmentSemaphore;
  final String sentTime;

  Message(
      {this.messageBody,
      this.createdAt,
      this.contactNo,
      this.alignmentSemaphore,
      this.sentTime});

  Map<String, dynamic> toJson() => {
        'messageBody': messageBody,
        'createdAt': createdAt,
        'contactNo': contactNo,
        'alignmentSemaphore': alignmentSemaphore,
        'sentTime': sentTime
      };

  Message.fromJson(Map<String, dynamic> map)
      : messageBody = map['messageBody'],
        createdAt = map['createdAt'],
        contactNo = map['contactNo'],
        alignmentSemaphore = map['alignmentSemaphore'],
        sentTime = map['sentTime'];
}

class MessageTile extends StatelessWidget {
  final Message message;
  final int contactSema;
  MessageTile({
    @required this.message,
    this.contactSema
  });
  @override
  Widget build(BuildContext context) {
    int alSem = message.alignmentSemaphore;
    if (message.alignmentSemaphore == contactSema){
      alSem = 0;
    } else {
      alSem = 1;
    }
    String timeString = message.sentTime;
    return Row(
      mainAxisAlignment: 1 == alSem
          ? MainAxisAlignment.start
          : MainAxisAlignment.end,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: 1 == alSem
                  ? Color(0xFFF2F2F7)
                  : Colors.blue[50]
              // : Color(0xFF309c6e),
              ),
          child: Wrap(
            direction: Axis.vertical,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width / 1.4),
                    child: Container(
                      padding: const EdgeInsets.only(
                          top: 10.0, bottom: 5, left: 10, right: 20),
                      child: RichText(
                          overflow: TextOverflow.visible,
                          maxLines: 100,
                          text: TextSpan(
                              text: message.messageBody,
                              style: Utility.getChatTextStyle(
                                  16,
                                  1 == alSem
                                      ? Colors.grey[600]
                                      : Colors.blue))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    child: Text(
                      timeString,
                      style: TextStyle(
                          color: 1 == alSem
                              ? Colors.grey[600]
                              : Colors.blue),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
