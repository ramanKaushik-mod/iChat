import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ichat/models/contactModel.dart';
import 'package:ichat/models/userModel.dart';
import 'package:ichat/helperCode/helperClasses.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final Function close;
  ChatPage({@required this.close});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () {
        widget.close();
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          height: height,
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              Expanded(
                child: FutureBuilder<List<ContactTile>>(
                  future: FirebaseUtility.getContactList(update: () {}),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      List<ContactTile> list = snapshot.data;

                      return list.isNotEmpty
                          ? SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              physics: BouncingScrollPhysics(),
                              child: Column(
                                children: snapshot.data,
                              ),
                            )
                          : Center(
                              child: Icon(
                                Icons.error,
                                size: 100,
                                color: Color(0xFFF2F2F7),
                              ),
                            );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("Something Went Wrong", style: Utility.getTextStyle(20, Color(0xFFF2F2F7)),),
                      );
                    }
                    return Center(
                      child: Text('Loading...', style: Utility.getTextStyle(20, Color(0xFFF2F2F7))),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 40,
              )
            ],
          ),
        ),
        floatingActionButton: TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/contactScreen');
          },
          style: TextButton.styleFrom(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              backgroundColor: Color(0xFFF2F2F7),
              textStyle:
                  GoogleFonts.muli(fontSize: 20, fontWeight: FontWeight.w600)),
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, bottom: 6, left: 10, right: 5),
                child: Icon(
                  Icons.message,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('message'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.grey[600])),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 2),
        height: height,
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Text(
                  'Contacts',
                  style: getTextStyle(),
                ),
              ),
            ),
            Divider(
              height: 10,
              color: Colors.black,
            ),
            Expanded(
              child: FutureBuilder<List<ContactTile>>(
                future: FirebaseUtility.getContactList(update: () {}),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    List<ContactTile> list = snapshot.data;

                    return list.isNotEmpty
                        ? SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            physics: BouncingScrollPhysics(),
                            child: Column(
                              children: snapshot.data,
                            ),
                          )
                        : Center(
                            child: Icon(
                              Icons.error,
                              size: 100,
                              color: Color(0xFFF2F2F7),
                            ),
                          );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Something Went Wrong"),
                    );
                  }
                  return Center(
                    child: Text('Loading...'),
                  );
                },
              ),
            ),
            SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }

  getTextStyle() {
    return GoogleFonts.muli(
        fontSize: 30, fontWeight: FontWeight.w600, color: Colors.grey[500]);
  }
}

class RequestPage extends StatefulWidget {
  final Function close;
  RequestPage({@required this.close});
  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  UserTile _userTile;
  final TextEditingController _controller = TextEditingController();
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        widget.close();
        Provider.of<GetChanges>(context, listen: false).turnUserTileToNull();
        return Future.value(false);
      },
      child: Stack(
        children: [
          Center(
            child: Icon(
              Icons.verified_user_rounded,
              color: Color(0xFFF2F2F7),
              size: 100,
            ),
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  height: 180,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xFFF2F2F7)),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 40,
                              padding: EdgeInsets.only(left: 20),
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                              ),
                              child: TextField(
                                controller: _controller,
                                style: getTextStyle(),
                                textAlign: TextAlign.start,
                                keyboardType: TextInputType.number,
                                cursorColor: Colors.blue,
                                focusNode: _focusNode,
                                decoration: InputDecoration(
                                    border: UnderlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                    hintText: 'Search Here',
                                    hintStyle: getTextStyle()),
                                onChanged: (_) {},
                              ),
                            ),
                          ),
                          IconButton(
                            color: Colors.grey[600],
                            onPressed: () async {
                              setState(() {
                                _focusNode.unfocus();
                              });
                              var contactNo = _controller.text.trim();
                              if (contactNo.length != 10) {
                                print("length is not apropriate");
                              } else {
                                for (var item in contactNo.split("")) {
                                  if (!item.contains(RegExp(r'[0-9]'))) {
                                    _controller.clear();
                                  }
                                }
                              }

                              if (_controller.text.trim().length == 10) {
                                //check that number exists or not
                                //if exists, turn it into a UserTile object
                                Map<String, dynamic> map =
                                    await FirebaseUtility.findUser(
                                        contactNumber: '+91$contactNo');

                                if (map != null && map.isNotEmpty) {
                                  var getChanges = Provider.of<GetChanges>(
                                      context,
                                      listen: false);
                                  _userTile = UserTile(
                                      buttonText: 'request',
                                      map: map,
                                      notifyChanges: () async {
                                        getChanges.removeUserTile();
                                      });

                                  getChanges.updateUserTile(_userTile);
                                } else {
                                  _controller.text =
                                      '${_controller.text.trim()} not exists';
                                  Timer(Duration(seconds: 1), () {
                                    _controller.text = '';
                                  });
                                }
                              }
                            },
                            icon: Icon(Icons.search),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right:8),
                            child: IconButton(
                                                            color: Colors.grey[600],
                              onPressed: () {
                                Provider.of<GetChanges>(context, listen: false)
                                    .turnUserTileToNull();
                              },
                              icon: Icon(Icons.clear),
                            ),
                          )
                        ],
                      ),
                      Expanded(
                        child: Consumer<GetChanges>(
                          builder: (BuildContext context, value, Widget child) {
                            return value.userTile != null
                                ? value.getUpdatedUserTile()
                                : Center(
                                    child: Icon(
                                      Icons.search,
                                      size: 50,
                                      color: Colors.grey[300],
                                    ),
                                  );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/pendingScreen');
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xFFF2F2F7),
                            textStyle: getTextStyle(),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text('Request Queue'),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/requestScreen');
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xFFF2F2F7),
                            textStyle: getTextStyle(),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text('Pending Queue'),
                        ),
                      ),
                      SizedBox(height: 80),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextStyle getTextStyle() {
    return GoogleFonts.muli(
        decoration: TextDecoration.none,
        fontWeight: FontWeight.w600,
        fontSize: 20,
        color: Colors.grey[500]);
  }
}
