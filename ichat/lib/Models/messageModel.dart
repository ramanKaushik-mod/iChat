import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ichat/helperCode/helperClasses.dart';

class Message {
  final String messageBody;
  final Timestamp createdAt;
  final String contactNo;
  final int alignmentSemaphore;
  final Timestamp timeStamp;

  Message(
      {this.messageBody,
      this.createdAt,
      this.contactNo,
      this.alignmentSemaphore,
      this.timeStamp});

  Map<String, dynamic> toJson() => {
        'messageBody': messageBody,
        'createdAt': createdAt,
        'contactNo': contactNo,
        'alignmentSemaphore': alignmentSemaphore,
        'timeStamp': timeStamp
      };

  Message.fromJson(Map<String, dynamic> map)
      : messageBody = map['messageBody'],
        createdAt = map['createdAt'],
        contactNo = map['contactNo'],
        alignmentSemaphore = map['alignmentSemaphore'],
        timeStamp = map['timeStamp'];
}

class MessageTile extends StatelessWidget {
  final Message message;
  MessageTile({@required this.message});
  @override
  Widget build(BuildContext context) {
    String timeString = '';
    if (message.createdAt != null) {
      timeString = '${message.timeStamp.toDate().hour} : ${message.timeStamp.toDate().second}';
    }
    return Row(
      mainAxisAlignment: message.alignmentSemaphore == 1
          ? MainAxisAlignment.start
          : MainAxisAlignment.end,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: message.alignmentSemaphore == 1
                ? Color(0xFFF2F2F7)
                : Color(0xFF309c4e),
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
                                  message.alignmentSemaphore == 1
                                      ? Colors.grey[600]
                                      : Colors.white))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    child: Text(
                      timeString,
                      style: TextStyle(
                          color: message.alignmentSemaphore == 1
                              ? Colors.grey[600]
                              : Colors.white),
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
