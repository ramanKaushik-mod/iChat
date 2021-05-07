import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ichat/models/approveRequestModel.dart';
import 'package:ichat/models/userModel.dart';
import 'package:ichat/helperCode/helperClasses.dart';

class PendingScreen extends StatefulWidget {
  const PendingScreen({Key key}) : super(key: key);

  @override
  _PendingScreenState createState() => _PendingScreenState();
}

class _PendingScreenState extends State<PendingScreen> {
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
        margin: EdgeInsets.symmetric(horizontal: 10),
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
                  'Your Requests',
                  style: getTextStyle(),
                ),
              ),
            ),
            Divider(
              height: 10,
              color: Colors.white,
            ),
            Expanded(
              child: FutureBuilder<List<UserTile>>(
                future: FirebaseUtility.getPendingList(update: () {
                  setState(() {});
                }),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    List<UserTile> list = snapshot.data;

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
                              color: Color(0xFFF2F2F2),
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

class RequestScreen extends StatefulWidget {
  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
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
        margin: EdgeInsets.symmetric(horizontal: 10),
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
                  'Pending Requests',
                  style: getTextStyle(),
                ),
              ),
            ),
            Divider(
              height: 10,
              color: Colors.white,
            ),
            Expanded(
              child: FutureBuilder<List<ApproveRequestTile>>(
                future: FirebaseUtility.getForApprovedList(update: () {
                  setState(() {});
                }),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    List<ApproveRequestTile> list = snapshot.data;

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
                              color: Color(0xFFF2F2F2),
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
