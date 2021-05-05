import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ichat/helperCode/helperClasses.dart';

class ContactModel {
  final String imageStr;
  final String name;
  final String contactNo;
  final int contactChatStatus; // activated or deactivate chat
  final String contactStatus;
  final String sharedDoucment;
  final int alignmentSemaphore;

  ContactModel(
      {this.imageStr,
      this.name = '',
      this.contactNo = '',
      this.contactChatStatus,
      this.contactStatus = '',
      this.sharedDoucment,
      this.alignmentSemaphore});

  ContactModel.fromMap(Map<String, dynamic> map)
      : imageStr = map['imageStr'],
        name = map['name'],
        contactNo = map['contactNo'],
        contactChatStatus = map['contactChatStatus'],
        contactStatus = map['contactStatus'],
        sharedDoucment = map['sharedDoucment'],
        alignmentSemaphore = map['alignmentSemaphore'];

  Map<String, dynamic> toJson() => {
        'imageStr': this.imageStr,
        'name': this.name,
        'contactNo': this.contactNo,
        'contactChatStatus': this.contactChatStatus,
        'contactStatus': this.contactStatus,
        'sharedDoucment': this.sharedDoucment,
        'alignmentSemaphore': this.alignmentSemaphore
      };
}

class ContactTile extends StatefulWidget {
  final ContactModel model;
  ContactTile({@required this.model});

  @override
  _ContactTileState createState() => _ContactTileState();
}

class _ContactTileState extends State<ContactTile> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/messageScreen', arguments: widget.model);
      },
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color(0xFFF2F2F7),
          ),
          height: 80,
          width: width,
          child: Row(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: CircleAvatar(
                  backgroundColor: Color(0xFFF2F2F7),
                  radius: 30,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 26,
                    child: CircleAvatar(
                      backgroundColor: Colors.blue[50],
                      radius: 24,
                      child: widget.model.imageStr != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.memory(
                                base64Decode(widget.model.imageStr),
                                fit: BoxFit.fill,
                              ))
                          : Icon(Icons.person),
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
                                  text: widget.model.name,
                                  style:
                                      Utility.getTextStyle(16, Colors.blue)))),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Divider(
                          height: 10,
                          color: Colors.black,
                        ),
                      ),
                      Flexible(
                          child: RichText(
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                              text: TextSpan(
                                  text: widget.model.contactStatus,
                                  style:
                                      Utility.getTextStyle(12, Colors.blue)))),
                    ],
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
