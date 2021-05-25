import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ichat/Screens/pages.dart';
import 'package:ichat/helperCode/firebaseFunctions.dart';
import 'package:ichat/helperCode/helperClasses.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  HandlingFirebaseDB handlingFirebaseDB;
  @override
  void initState() {
    super.initState();
    getDBInstance();
  }

  getDBInstance() async {
    handlingFirebaseDB = await HandlingFirebaseDB(
        contactID: await Utility.getContactFromPreference());
    handlingFirebaseDB.changeContactChatStatus(status: true);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
            backgroundColor: Color(0xFFF2F2F7),
            appBar: _appBar(width),
            resizeToAvoidBottomInset: false,
            body: Consumer<GetChanges>(
              builder: (BuildContext context, value, Widget child) {
                return value.getSemaphoreForMainScreen() == 0
                    ? ChatPage(
                        close: () {
                          SystemNavigator.pop(animated: true);
                        },
                        changePage: () {
                          Provider.of<GetChanges>(context, listen: false)
                              .updateMainSemaphore1();
                        },
                      )
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
      backgroundColor: Colors.transparent,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<GetChanges>(
          builder: (BuildContext context, val, Widget child) {
            if (val.semaphoreForMainScreen == 1) {
              return CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                    splashRadius: 20,
                    splashColor: Colors.deepPurple,
                    onPressed: () {
                      Navigator.pushNamed(context, '/userScreen',
                          arguments: handlingFirebaseDB.contactID);
                    },
                    icon: Icon(
                      Icons.person_outline,
                      color: Colors.deepPurple,
                    )),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 14.0),
          child: IconButton(
            splashRadius: 20,
            splashColor: Colors.deepPurple,
            onPressed: () {},
            icon: Icon(
              Icons.lightbulb_outline_rounded,
              color: Colors.deepPurple,
            ),
          ),
        ),
      ],
    );
  }
}
