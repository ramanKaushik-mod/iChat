import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ichat/helperCode/helperClasses.dart';
import 'package:ichat/helperCode/firebaseFunctions.dart';

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
  final Function updateUI;
  ApproveRequestTile({@required this.model, this.updateUI});

  @override
  _ApproveRequestTileState createState() => _ApproveRequestTileState();
}

class _ApproveRequestTileState extends State<ApproveRequestTile> {
  HandlingFirebaseDB handlingFirebaseDB;
  String add = 'Adding', remove = 'Removing';

  @override
  void initState() {
    super.initState();
    getDBInstance();
  }

  getDBInstance() async {
    handlingFirebaseDB =
        HandlingFirebaseDB(contactID: await Utility.getContactFromPreference());
  }

  @override
  Widget build(BuildContext context) {
        final height = MediaQuery.of(context).size.height;
    return Card(
                          elevation: 20,
                          color: Color(0xFFF2F2F7),
                          shadowColor: Color(0xFFF2F2F7),
                          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
      child: Container(
        height: 80,
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
              child: Card(
                          elevation: 20,
                          color: Colors.deepPurple,
                          shadowColor: Colors.deepPurple,
                          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),

                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
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
                                  style: DecorateText.getDecoratedTextStyle(
                                          height:height,
                                      fontSize: 18, color: Colors.white)))),
                      SizedBox(
                        height: 4,
                      ),
                      Flexible(
                          child: RichText(
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                              text: TextSpan(
                                  text: widget.model.contactNo,
                                  style: DecorateText.getDecoratedTextStyle(
                                          height:height,
                                      fontSize: 12, color: Colors.white)))),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Card(
                          elevation: 20,
                          color: Color(0xFFF2F2F7),
                          shadowColor: Color(0xFFF2F2F7),
                          margin: EdgeInsets.all(2),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                    child: IconButton(
                      
                        splashColor: Colors.deepPurple,
                        splashRadius: 20,
                        onPressed: () async {
                          await handlingFirebaseDB.addContactToContactList(
                              otherContactId: widget.model.contactNo);

                          // widget.updateUI('check your contact list');
                        },
                        icon: Icon(Icons.add_circle_outline_rounded,color: Colors.deepPurple,)
                        ,),
                  ),
                  Card(
                          elevation: 20,
                          color: Color(0xFFF2F2F7),
                          shadowColor: Color(0xFFF2F2F7),
                          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                    child: IconButton(
                        splashColor: Colors.red,
                        splashRadius: 20,
                        onPressed: () async {
                          await handlingFirebaseDB
                              .removeRequestFromApprovalAndPendingList(
                                  otherContactId: widget.model.contactNo);
                          widget.updateUI('request removed');
                        },
                        icon: Icon(Icons.remove_circle_outline_rounded, color: Colors.red,)
                  ),)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
