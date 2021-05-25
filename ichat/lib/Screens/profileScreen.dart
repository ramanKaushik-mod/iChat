import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ichat/Screens/imageCapture.dart';
import 'package:ichat/helperCode/firebaseFunctions.dart';
import 'package:ichat/helperCode/helperClasses.dart';
import 'package:ichat/helperCode/helperFunctions.dart';
import 'package:ichat/models/userModel.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode;
  Image imageFromPreferences;
  Future<int> value;

  int toggle = 0;
  String dialogCode;
  HandlingFirebaseDB handlingFirebaseDB;
  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    getDBInstance();
  }

  getDBInstance() async {
    handlingFirebaseDB =
        HandlingFirebaseDB(contactID: await Utility.getContactFromPreference());
  }

  _loadImageFromPreferences() {
    Utility.getImageFromPreferences().then((imgString) {
      if (null == imgString) {
        return;
      }
      setState(() {
        imageFromPreferences = Utility.imageFromBase64String(imgString);
        value = Future.value(4);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () {
        Utility.exitApp(context);
        return Future<bool>.value(true);
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _firstPage(width, height),
                  Container(
                    margin: EdgeInsets.all(20),
                    child: FloatingActionButton(
                      onPressed: () async {
                        if (_controller.text.trim().length > 2) {
                          await Utility.addUserName(_controller.text.trim());
                          UserModel userModel = UserModel(
                              contactNo:
                                  await Utility.getContactFromPreference(),
                              name: _controller.text.trim(),
                              imageStr:
                                  await Utility.getImageFromPreferences());

                          showBottomModal(context, dialogCode: "Loading...");
                          handlingFirebaseDB.addUserToUsers( userModel:userModel,
                              nextPage: () async {
                            await Utility.addLoginStatus();
                            await Utility.setStatus(userModel.contactStatus);
                            Phoenix.rebirth(context);
                          });
                        } else {
                          showBottomModal(context,
                              dialogCode: "enter a valid name ( length > 3 )");
                        }
                      },
                      child: Icon(Icons.arrow_forward_ios_sharp),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _firstPage(double width, double height) {
    return SingleChildScrollView(
      child: Container(
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
            ),
            DecorateText.getDecoratedText(
              text: "Profile info",
              height: height,
              color: Colors.blue[500],
              fontWeight: FontWeight.w600,
            ),
            SizedBox(
              height: 20,
            ),
            DecorateText.getDecoratedText(
                text: "Provide your name and an optional photo",
                height: height,
                color: Colors.grey[700],
                fontWeight: FontWeight.w400,
                little: 'little'),
            SizedBox(
              height: 30,
            ),
            FutureBuilder(
                future: value,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return CircleAvatar(
                      radius: 70,
                      backgroundColor: Color(0xFFF2F2F2),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ImageCapture(function: () {
                                    imageFromPreferences = null;
                                    _loadImageFromPreferences();
                                  })));
                        },
                        child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(62),
                              gradient: LinearGradient(colors: [
                                Colors.blue,
                                Colors.purple,
                                Colors.purpleAccent,
                                Colors.red
                              ])),
                          child: CircleAvatar(
                            backgroundColor: Color(0xFFF2F2F3),
                            radius: 60,
                          
                            child: ClipRRect(
                              clipBehavior: Clip.hardEdge,
                              borderRadius: BorderRadius.circular(60),
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: imageFromPreferences),
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ImageCapture(
                                  function: () {
                                    if (imageFromPreferences == null) {
                                      _loadImageFromPreferences();
                                    }
                                  },
                                )));
                      },
                      child: CircleAvatar(
                        backgroundColor: Color(0xFFF2F2F3),
                        radius: 60,
                        child: Center(
                          child: Icon(
                            Icons.add_a_photo_rounded,
                            size: 50,
                            color: Colors.grey[400],
                          ),
                        ),
                      ),
                    );
                  }
                }),
            SizedBox(
              height: 40,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blue[50],
              ),
              width: width / 1.2,
              child: TextField(
                autofocus: true,
                controller: _controller,
                focusNode: _focusNode,
                style: DecorateText.getDecoratedTextStyle(
                  height:height,
                    fontSize: 20, color: Colors.blue),
                textAlign: TextAlign.start,
                cursorColor: Colors.blue,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    border: UnderlineInputBorder(borderSide: BorderSide.none),
                    hintText: "Enter your name",
                    hintStyle: GoogleFonts.muli(
                        fontWeight: FontWeight.w600,
                        fontSize: width / 20,
                        color: Colors.grey[500])),
                onChanged: (value) {},
              ),
            )
          ],
        ),
      ),
    );
  }
}
