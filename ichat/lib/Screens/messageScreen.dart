import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ichat/Models/contactModel.dart';
import 'package:ichat/Models/messageModel.dart';
import 'package:ichat/Screens/checkPurpose.dart';
import 'package:ichat/helperCode/helperClasses.dart';

class MessageScreen extends StatefulWidget {
  final ContactModel contactModel;
  MessageScreen({this.contactModel});
  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  CollectionReference collectionReference;
  List<MessageTile> list;
  RegExp exp;
  @override
  void initState() {
    super.initState();
    collectionReference = FirebaseFirestore.instance.collection('Chats');
    list = [];
    // exp = RegExp('Timestamp').firstMatch(input)
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => CheckPurpose()));
          return Future.value(true);
        },
        child: Scaffold(
          bottomSheet: _bottomSheet(),
          backgroundColor: Colors.white,
          appBar: _appBar(),
          body: Container(
            color: Colors.white,
            height: height,
            width: width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: StreamBuilder<DocumentSnapshot>(
                      stream: collectionReference
                          .doc(widget.contactModel.sharedDoucment)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.black),
                            ),
                          );
                        }
                        snapshot.data.data().forEach((key, value) {
                          if (key.startsWith('Timestamp')) {
                            print(
                                "TimeStamp values is : ${snapshot.data.data()[key]}");
                            list.add(MessageTile(
                                message: Message.fromJson(
                                    snapshot.data.data()[key])));
                          }
                        });
                        print("snapshot data : ${snapshot.data.data()}");
                        return list.isNotEmpty
                            ? SingleChildScrollView(
                                reverse: true,
                                scrollDirection: Axis.vertical,
                                physics: BouncingScrollPhysics(),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: list,
                                ),
                              )
                            : Center(
                                child: Text("Say hello to your friend"),
                              );
                      }),
                ),
                KeyBoard(
                  contactModel: widget.contactModel,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_outlined,
            color: Colors.grey[400],
          )),
      title: InkWell(
        onTap: () {
          //TODO profile screen that'll display the friend's information
        },
        child: Container(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 15,
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[400],
                    radius: 14.5,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 12,
                      child: Icon(
                        Icons.person,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  RichText(
                      text: TextSpan(
                          text: widget.contactModel.name,
                          style: Utility.getTextStyle(17, Colors.grey[400]))),
                  RichText(
                      text: TextSpan(
                          text: widget.contactModel.contactNo,
                          style: Utility.getTextStyle(12, Colors.grey[400])))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _bottomSheet() {
    return;
  }
}
