import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ichat/helperCode/helperClasses.dart';
import 'package:provider/provider.dart';

class CheckPurpose extends StatefulWidget {
  @override
  _CheckPurposeState createState() => _CheckPurposeState();
}

class _CheckPurposeState extends State<CheckPurpose> {
  int toggle = 0;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
        ),
        backgroundColor: Color(0xFFF2F2F2),
        body: Container(
          width: width,
          height: height,
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //upper layer for FirstScreenUI
              Container(
                height: 180,
                width: width,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                    itemBuilder: (context, index){
                  return getIndividual(index);
                })
              ),
              // getIndividual(),
            ],
          )),
        ),
      ),
    );
  }

  getIndividual(int index) {
    return InkWell(
        onTap: () {
          var forAnimation = Provider.of<ForAnimation>(context, listen: false);
          forAnimation.changeWidthOfContainer();
        },
        child: Consumer<ForAnimation>(
          builder: (BuildContext context, value, Widget child) {
            return AnimatedContainer(
              color: Colors.red,
              margin: EdgeInsets.all(8.0),
              duration: Duration(seconds: 2),
              height: 140,
              width: value.widthForContainer,
              child: RotatedBox(
                quarterTurns: 3,
                child: Text(
                  "User Info"
                ),
              ),
            );
          }
        ));
  }
}
