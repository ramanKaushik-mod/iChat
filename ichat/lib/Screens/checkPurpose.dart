import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ichat/Screens/pages.dart';
import 'package:ichat/helperCode/helperClasses.dart';
import 'package:provider/provider.dart';

class CheckPurpose extends StatefulWidget {
  @override
  _CheckPurposeState createState() => _CheckPurposeState();
}

class _CheckPurposeState extends State<CheckPurpose> {
  int toggle = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: _appBar(width),
            backgroundColor: Colors.white,
            body: Consumer<GetChanges>(
              builder: (BuildContext context, value, Widget child) {
                return value.getSemaphoreForMainScreen() == 0
                    ? ChatPage(close: () {
                        SystemNavigator.pop(animated: true);
                      })
                    : RequestPage(
                        close: () {
                          Provider.of<GetChanges>(context, listen: false)
                              .updateMainSemaphore0();
                        },
                      );
              },
            )));
  }

  _appBar(width) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      centerTitle: true,
      title: InkWell(
        onTap: () {
          Provider.of<GetChanges>(context, listen: false)
              .updateMainSemaphore1();
        },
        child: Container(
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
              "Search iChat",
              style: GoogleFonts.muli(
                  fontSize: MediaQuery.of(context).size.width / 20,
                  color: Colors.blue,
                  fontWeight: FontWeight.w600),
            ),
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

}
