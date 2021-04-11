import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ichat/helperCode/helperClasses.dart';
import 'package:ichat/helperCode/helperFunctions.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  TextEditingController _controller = TextEditingController();
  DialogUtility dialogAppear;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _firstPage(width),
                Container(
                  margin: EdgeInsets.all(20),
                  child: FloatingActionButton(
                    onPressed: (){
                      DialogUtility.showLoadingDialog(context, "loading");
                      Future.delayed(Duration(seconds: 5),(){
                        setState(() {
                          DialogUtility.status = 1;
                        });
                      });
                      // Utility.addUserName(_controller.text.trim());
                      // Utility.clearPreferences();
                      // FirebaseUtility.logout();
                      // Navigator.of(context).pop();
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
            CircleAvatar(
              backgroundColor: Color(0xFFF2F2F3),
              radius: 60,
              child: Center(
                child: Icon(Icons.add_a_photo_rounded, size: 50,color: Colors.grey[400],),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: width / 1.2,
              child: TextField(
                autofocus: true,
                controller: _controller,
                style: GoogleFonts.muli(
                  decoration: TextDecoration.none,
                    fontWeight: FontWeight.w600,
                    fontSize: width / 20,
                    color: Colors.grey[500]
                ),
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
                      color: Colors.grey[500]
                  )
                ),
                onChanged: (value) {},
              ),
            )
          ],
        ),
      ),
    );
  }

}
