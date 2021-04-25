import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ichat/Screens/pages.dart';

class CheckPurpose extends StatefulWidget {
  @override
  _CheckPurposeState createState() => _CheckPurposeState();
}

class _CheckPurposeState extends State<CheckPurpose> {
  int toggle = 0;
  Timer timer;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    // timer = Timer.periodic(Duration(seconds: 1), (timer) {
    //   var timerInfo = Provider.of<GetChanges>(context, listen: false);
    //   timerInfo.updateTime();
    // });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
      bottomSheet: _menu(height),
      appBar: _appBar(width),
      backgroundColor: Color(0xFFF2F2F2),
      body: PageView(
        controller: _pageController,
        children: [
          ChatPage(),
          ContactPage(
            pageController: _pageController,
          ),
          RequestPage(
            pageController: _pageController,
          )
        ],
      ),
    ));
  }

  _appBar(width) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Color(0xFFF2F2F2),
      title: Container(
        padding: EdgeInsets.all(10),
        // height: 40,
        width: width / 2,
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(40),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Good Morning",
            style: GoogleFonts.muli(
                fontSize: MediaQuery.of(context).size.width / 20,
                color: Colors.blue,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
              radius: 12,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.circle_notifications,
                color: Colors.blue[50],
              )),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: CircleAvatar(
            backgroundColor: Colors.blue[50],
            child: Icon(Icons.person),
          ),
        ),
      ],
    );
  }

  _menu(height) {
    return BottomSheet(
        onClosing: () {},
        builder: (context) {
          return Container(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue[50],
                  child: Icon(
                    Icons.chat,
                    color: Colors.blue,
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.blue[50],
                  child: Icon(
                    Icons.person,
                    color: Colors.blue,
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.blue[50],
                  child: Icon(
                    Icons.request_quote_outlined,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          );
        });
  }
}
