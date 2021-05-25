import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ichat/helperCode/firebaseFunctions.dart';
import 'package:ichat/models/approveRequestModel.dart';
import 'package:ichat/models/userModel.dart';
import 'package:ichat/helperCode/helperClasses.dart';

class PendingScreen extends StatefulWidget {
  const PendingScreen({Key key}) : super(key: key);

  @override
  _PendingScreenState createState() => _PendingScreenState();
}

class _PendingScreenState extends State<PendingScreen> {
  HandlingFirebaseDB handlingFirebaseDB;
  Future<int> dbReady;
  @override
  void initState() {
    super.initState();
    getDBInstance();
  }

  getDBInstance() async {
    handlingFirebaseDB =
        HandlingFirebaseDB(contactID: await Utility.getContactFromPreference());
    setState(() {
      dbReady = Future.value(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    var expanded = Expanded(
      child: FutureBuilder<int>(
        future: dbReady,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return StreamBuilder<QuerySnapshot>(
              stream: handlingFirebaseDB.getPendingListAsStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                    ),
                  );
                }
                return snapshot.data.docs.isNotEmpty
                    ? SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: snapshot.data.docs
                              .map((e) => UserTile(
                                  buttonText: 'cancel',
                                  userModel: UserModel.fromMap(e.data()),
                                  notifyChanges: () async {
                                    Map<String, dynamic> map = e.data();
                                    await handlingFirebaseDB.cancelRequest(
                                        otherContactId: map['contactNo']);
                                  }))
                              .toList(),
                        ),
                      )
                    : Center(
                        child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(26),
                            ),
                            child: Card(
                              elevation: 20,
                              color: Color(0xFFF2F2F7),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Text(
                                  "Here the requests you made \nwill appear\n\nIf you want to cancel any request,\njust press the cancel button",
                                  style: DecorateText.getDecoratedTextStyle(
                                    height: height,
                                    fontSize: 14,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                              ),
                            )),
                      );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
            ),
          );
        },
      ),
    );

    return Scaffold(
      backgroundColor: Color(0xFFF2F2F7),
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
        height: height,
        width: width,
        color: Color(0xFFF2F2F7),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: width,
                color: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Text(
                  'Un-Accepted Requests',
                  style: DecorateText.getDecoratedTextStyle(
                    height: height,
                    fontSize: 26,
                    color: Colors.deepPurple,
                  ),
                )),
            Divider(
              height: 10,
              color: Colors.white,
            ),
            expanded,
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}

class RequestScreen extends StatefulWidget {
  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  Future<int> dbReady;
  HandlingFirebaseDB handlingFirebaseDB;
  @override
  void initState() {
    super.initState();
    getDBInstance();
  }

  getDBInstance() async {
    handlingFirebaseDB =
        HandlingFirebaseDB(contactID: await Utility.getContactFromPreference());
    setState(() {
      dbReady = Future.value(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    var expanded = Expanded(
      child: FutureBuilder<int>(
        future: dbReady,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return StreamBuilder<QuerySnapshot>(
              stream: handlingFirebaseDB.getForApprovedListAsStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                    ),
                  );
                }
                return snapshot.data.docs.isNotEmpty
                    ? SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: snapshot.data.docs
                              .map((e) => ApproveRequestTile(
                                  model: ApproveRequestModel.fromMap(e.data()),
                                  updateUI: (String val) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(val),
                                      duration: Duration(milliseconds: 800),
                                    ));
                                  }))
                              .toList(),
                        ),
                      )
                    : Center(
                        child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(26),
                            ),
                            child: Card(
                              elevation: 20,
                              color: Color(0xFFF2F2F7),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Text(
                                  "If you want to accept any request,\npress the add button\n\nand if you want to deny ,\njust press the deny button",
                                  style: DecorateText.getDecoratedTextStyle(
                                    height: height,
                                    fontSize: 14,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                              ),
                            )),
                      );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
            ),
          );
        },
      ),
    );
    return Scaffold(
      backgroundColor: Color(0xFFF2F2F7),
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
        height: height,
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                width: width,
                color: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Text(
                  'Pending Requests',
                  style: DecorateText.getDecoratedTextStyle(
                    height: height,
                    fontSize: 26,
                    color: Colors.deepOrange,
                  ),
                )),
            Divider(
              height: 10,
              color: Colors.white,
            ),
            expanded,
            SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }
}
