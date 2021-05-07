import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ichat/helperCode/helperClasses.dart';
import 'package:ichat/models/contactModel.dart';

class UserProfile extends StatefulWidget {
  final ContactModel model;
  UserProfile({@required this.model});
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.blue[50]
            ),
            child: Text("ME", style: Utility.getChatTextStyle(22, Colors.blue),)),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.grey[600])),
        elevation: 0,
        backgroundColor: Colors.white,
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(32),
                // color: Colors.yellow,
                width: width,
                height: height / 4,
                child: Stack(
                  children: [
                    Center(
                      child: CircleAvatar(
                        backgroundColor: Color(0xFFF2F2F7),
                        radius: 72,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 70,
                          child: widget.model.imageStr != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.memory(
                                    base64Decode(widget.model.imageStr),
                                    fit: BoxFit.fill,
                                  ))
                              : Icon(Icons.person),
                        ),
                      ),
                    ),
                    Positioned.fromRect(
                      rect: Rect.fromCircle(
                          center: Offset(width / 2, width / 3.1), radius: 40),
                      child: Center(
                          child: IconButton(
                              color: Colors.blue[100],
                              onPressed: () {},
                              icon: Icon(
                                FontAwesomeIcons.edit,
                                size: 30,
                              ))),
                    )
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFFF2F2F7)),
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: _nameController,
                  style: GoogleFonts.muli(
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.w600,
                      fontSize: width / 20,
                      color: Colors.grey[500]),
                  textAlign: TextAlign.start,
                  cursorColor: Colors.blue,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                      suffixIcon: Icon(Icons.edit),
                      prefixIcon: Icon(Icons.person),
                      border: UnderlineInputBorder(borderSide: BorderSide.none),
                      hintText: widget.model.name,
                      hintStyle: GoogleFonts.muli(
                          fontWeight: FontWeight.w600,
                          fontSize: width / 20,
                          color: Colors.grey[500])),
                  onChanged: (value) {},
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFFF2F2F7)),
                child: TextField(
                  controller: _statusController,
                  style: GoogleFonts.muli(
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.w600,
                      fontSize: width / 20,
                      color: Colors.grey[500]),
                  textAlign: TextAlign.start,
                  cursorColor: Colors.blue,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                      suffixIcon: Icon(Icons.edit),
                      prefixIcon: Icon(Icons.error),
                      border: UnderlineInputBorder(borderSide: BorderSide.none),
                      hintText: widget.model.contactStatus ?? 'Available',
                      hintStyle: GoogleFonts.muli(
                          fontWeight: FontWeight.w600,
                          fontSize: width / 20,
                          color: Colors.grey[500])),
                  onChanged: (value) {},
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: width,
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFFF2F2F7)),
                child: TextField(
                  enabled: false,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.phone),
                      border: UnderlineInputBorder(borderSide: BorderSide.none),
                      hintText: widget.model.contactNo,
                      hintStyle: GoogleFonts.muli(
                          fontWeight: FontWeight.w600,
                          fontSize: width / 20,
                          color: Colors.grey[500])),
                  ),
                ),
              
            ],
          ),
        ),
      ),
    );
  }
}
