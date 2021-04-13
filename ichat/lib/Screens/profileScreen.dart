import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ichat/Screens/checkPurpose.dart';
import 'package:ichat/Screens/imageCapture.dart';
import 'package:ichat/helperCode/helperClasses.dart';
import 'package:ichat/helperCode/helperFunctions.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode;
  DialogUtility dialogAppear;

  Image imageFromPreferences;
  Future<int> value;

  int toggle = 0;
  String dialogCode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }


  _changeState() {
    setState(() {
      toggle = 1;
      _focusNode.unfocus();
    });

    if(dialogCode != "Loading..."){
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          toggle = 0;
          _focusNode.requestFocus();
        });
      });
    }
  }

  _showBottomSheet(code) {
    dialogCode = code;
    _changeState();
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
    return SafeArea(
      child: Scaffold(
        bottomSheet: toggle == 0
            ? null
            : bottomSheet(dialogCode),
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _firstPage(width),
                Container(
                  margin: EdgeInsets.all(20),
                  child: FloatingActionButton(
                    onPressed: ()async {
                      if(_controller.text.trim().length > 2){
                        await Utility.addUserName(_controller.text.trim());
                        _showBottomSheet("Loading...");
                        // FirebaseUtility.logout();
                        Future.delayed(Duration(seconds: 2), () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => CheckPurpose()));
                        });
                      }else{
                        _showBottomSheet("enter a valid name ( length > 3 )");
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
    );
  }

  _firstPage(double width) {
    return SingleChildScrollView(
      child: Container(
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              "Profile info",
              style: GoogleFonts.muli(
                  fontWeight: FontWeight.w600,
                  fontSize: width / 20,
                  color: Colors.blue[500]),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Provide your name and an optional photo",
              style: GoogleFonts.muli(
                  fontWeight: FontWeight.w300,
                  fontSize: width / 28,
                  color: Colors.grey[800]),
            ),
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
                              builder: (context) => ImageCapture(function:(){
                                imageFromPreferences = null;
                                if(imageFromPreferences == null){
                                  _loadImageFromPreferences();
                                }
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
                              borderRadius: BorderRadius.circular(60),
                              child: imageFromPreferences,
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
                              function: (){
                                if(imageFromPreferences == null){
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
              height: 10,
            ),
            Container(
              width: width / 1.2,
              child: TextField(
                autofocus: true,
                controller: _controller,
                focusNode: _focusNode,
                style: GoogleFonts.muli(
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.w600,
                    fontSize: width / 20,
                    color: Colors.grey[500]),
                textAlign: TextAlign.start,
                cursorColor: Colors.blue,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(width: 2, color: Colors.grey[300])),
                    hintText: "Enter your name",
                    hintStyle: GoogleFonts.muli(
                        fontWeight: FontWeight.w600,
                        fontSize: width / 20,
                        color: Colors.grey[500])),
                onChanged: (value) {

                },
              ),
            )
          ],
        ),
      ),
    );
  }

}
