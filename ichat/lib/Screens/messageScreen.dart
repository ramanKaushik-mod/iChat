import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ichat/models/contactModel.dart';
import 'package:ichat/Screens/checkPurpose.dart';
import 'package:ichat/helperCode/helperClasses.dart';
import 'package:ichat/models/messageModel.dart';

class MessageScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('Chats');
  final ContactModel contactModel;
  MessageScreen({this.contactModel});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    var expanded = Expanded(
      child: StreamBuilder<QuerySnapshot>(
          stream: collectionReference
              .doc(contactModel.sharedDoucment)
              .collection('messages')
              .orderBy('createdAt')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              );
            }
            return SingleChildScrollView(
              reverse: true,
              scrollDirection: Axis.vertical,
              physics: BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: snapshot.data.docs
                    .map((e) => MessageTile(
                          message: Message.fromJson(e.data()), contactSema: contactModel.alignmentSemaphore,
                        )) 
                    .toList(),
              ),
            );
          }),
    );
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => CheckPurpose()));
          return Future.value(true);
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: _appBar(context),
          body: Container(
            color: Colors.white,
            height: height,
            width: width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
              
                expanded,
                _bottomSheet(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  _appBar(context) {
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
                          text: contactModel.name,
                          style: Utility.getTextStyle(17, Colors.grey[400]))),
                  RichText(
                      text: TextSpan(
                          text: contactModel.contactNo,
                          style: Utility.getTextStyle(12, Colors.grey[400])))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _bottomSheet(context) {
    return Container(
      
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        color: Colors.white,
        height: 100,
        width: MediaQuery.of(context).size.width,
        child: Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Expanded(
        child: Container(
          // height: 46.0,
          padding: EdgeInsets.only(left: 20, right: 20, top: 3,bottom: 3),
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color(0xFFF2F2F7)),
          child: TextField(
            textAlignVertical: TextAlignVertical.center,
            textCapitalization: TextCapitalization.sentences,
            controller: _controller,
            style: Utility.getTextStyle(18, Colors.grey[600]),
            textAlign: TextAlign.start,
            keyboardType: TextInputType.multiline,
            cursorColor: Colors.black,
            maxLines: 5,
            minLines: 1,
            // expands: true,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical:16),
                border: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                hintText: 'Text message',
                hintStyle: Utility.getTextStyle(18, Colors.grey[600])),
            onChanged: (_) {
              // print("Size of the list is : ${list.length}");
            },
          ),
        ),
      ),
      InkWell(
        onTap: () async {
          // send message to firebase
          if (_controller.text.trim().isNotEmpty) {
            await FirebaseUtility.doMessage(
                message: Message(
                        messageBody: _controller.text.trim(),
                        createdAt: Timestamp.now(),
                        contactNo: contactModel.contactNo,
                        alignmentSemaphore: contactModel.alignmentSemaphore,
                        sentTime:
                            '${DateTime.now().hour} : ${DateTime.now().minute}')
                    .toJson(),
                sharedDoucment: contactModel.sharedDoucment);
            _controller.clear();
          }
        },
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 8.0, vertical: 14.0),
          child: CircleAvatar(
              backgroundColor: Color(0xFFF2F2F7),
              child: Icon(
                Icons.arrow_upward,
                color: Colors.grey[400],
              )),
        ),
      )
    ],
        ),
      );
  }
}
