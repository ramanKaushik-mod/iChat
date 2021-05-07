import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ichat/helperCode/helperClasses.dart';

class ApproveRequestModel {
  final String contactNo;
  final String name;
  final String imageStr;

  ApproveRequestModel(
      {this.imageStr, this.name = 'Raman', this.contactNo = '+917988814189'});

  ApproveRequestModel.fromMap(Map<String, dynamic> map)
      : imageStr = map['imageStr'],
        name = map['name'],
        contactNo = map['contactNo'];

  Map<String, dynamic> toJson() =>
      {'contactNo': contactNo, 'name': name, 'imageStr': imageStr};
}

class ApproveRequestTile extends StatefulWidget {
  final ApproveRequestModel model;
  ApproveRequestTile({@required this.model});

  @override
  _ApproveRequestTileState createState() => _ApproveRequestTileState();
}

class _ApproveRequestTileState extends State<ApproveRequestTile> {
  String add = 'Adding', remove = 'Removing';
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Card(
        elevation: 0,
        margin: EdgeInsets.all(8.0),
        color: Color(0xFFF2F2F7),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: CircleAvatar(
                backgroundColor: Color(0xFFF2F2F2),
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
                                style: Utility.getTextStyle(16, Colors.blue)))),
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
                                text: widget.model.contactNo,
                                style: Utility.getTextStyle(12, Colors.blue)))),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextButton(
                      style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      onPressed: () {
                        FirebaseUtility.addContactToContactList(
                            requesteeMap: widget.model.toJson(),
                            updateUI: () {
                              Navigator.pushReplacementNamed(
                                  context, '/requestScreen');
                            });
                      },
                      child: Container(
                          width: 50,
                          child: Center(
                              child: Text(
                            'Add',
                            style: Utility.getTextStyle(12, Colors.white),
                          )))),
                  TextButton(
                      style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      onPressed: () {
                        FirebaseUtility.removeFromContactList(
                            requester: widget.model.contactNo,
                            updateUI: () {
                              Navigator.pushReplacementNamed(
                                  context, '/requestScreen');
                            });
                      },
                      child: Container(
                          width: 50,
                          child: Center(
                              child: Text('Remove',
                                  style: Utility.getTextStyle(
                                      12, Colors.white))))),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
