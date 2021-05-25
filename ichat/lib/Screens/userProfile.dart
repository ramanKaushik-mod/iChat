import 'package:flutter/material.dart';
import 'package:ichat/helperCode/firebaseFunctions.dart';
import 'package:ichat/helperCode/helperClasses.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  final String contactNo;
  UserProfile({this.contactNo});
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  HandlingFirebaseDB handlingFirebaseDB;
  TextEditingController _statusController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  FocusNode namefocusNode, statusfocusNode;

  @override
  void initState() {
    super.initState();
    getDBInstance();
    getFields();
    namefocusNode = FocusNode();
    statusfocusNode = FocusNode();
    _loadImageFromPreferences();
  }

  getDBInstance() async {
    handlingFirebaseDB =
        HandlingFirebaseDB(contactID: await Utility.getContactFromPreference());
  }

  getFields() async {
    await Provider.of<GetChanges>(context, listen: false)
        .updateUserName(await Utility.getUserName());
    await Provider.of<GetChanges>(context, listen: false)
        .updateUserStatus(await Utility.getStatus());
  }

  _loadImageFromPreferences() {
    Provider.of<GetChanges>(context, listen: false).setUserImage();
  }

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
                  color: Color(0xFFF2F2F7)),
              child: Text(
                "ME",
                style: DecorateText.getDecoratedTextStyle(
                    height: height, fontSize: 22, color: Colors.deepPurple),
              )),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios, color: Colors.grey[600])),
          elevation: 0,
          backgroundColor: Colors.white,
          actions: [
            Card(
              elevation: 0,
              color: Color(0xFFF2F2F7),
              shadowColor: Color(0xFFF2F2F7),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: IconButton(
                splashColor: Colors.green,
                splashRadius: 20,
                onPressed: () {
                  Navigator.pushNamed(context, '/imageCapture',
                      arguments: () async {
                    await Provider.of<GetChanges>(context, listen: false)
                        .setUserImage();
                    await handlingFirebaseDB.updateUserImage();
                  });
                },
                icon: Icon(
                  Icons.add_a_photo_outlined,
                  color: Colors.green,
                ),
              ),
            ),
            SizedBox(
              width: 4,
            ),
            Card(
              elevation: 0,
              color: Color(0xFFF2F2F7),
              shadowColor: Color(0xFFF2F2F7),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: IconButton(
                splashColor: Colors.deepOrange,
                splashRadius: 20,
                onPressed: () async {
                  Provider.of<GetChanges>(context, listen: false)
                      .setUserImageToNull();
                  await handlingFirebaseDB
                      .getUserDoc()
                      .update({'imageStr': null});
                },
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.deepOrange,
                ),
              ),
            ),
            SizedBox(
              width: 8,
            )
          ],
        ),
        body: Container(
          color: Color(0xFFF2F2F7),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20))),
                padding: EdgeInsets.only(bottom: 10),
                width: width,
                child: Center(
                  child: Consumer<GetChanges>(
                    builder: (BuildContext context, value, Widget child) {
                      return value.userImage != null
                          ? Container(
                            margin: EdgeInsets.only(bottom: 20),
                            padding: EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              gradient: LinearGradient(colors: [
                                Colors.red,
                                Colors.deepPurple,
                                Colors.deepOrange,
                                Colors.purpleAccent
                              ])
                            ),
                            child: CircleAvatar(
                                radius: height / 14,
                                backgroundColor: Colors.deepPurple,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: value.userImage,
                                ),
                              ),
                          )
                          : CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: height / 14,
                              child: Icon(
                                Icons.person,
                                color: Color(0xFFF2F2F7), 
                                size: height / 10,
                              ));
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Consumer<GetChanges>(
                builder: (BuildContext context, value, Widget child) {
                  return buildContainer(context,
                      text: value.getUserName(), caller: 'UserName');
                },
              ),
              Consumer<GetChanges>(
                builder: (BuildContext context, value, Widget child) {
                  return buildContainer(
                    context,
                    text: value.getUserStatus(),
                    caller: 'Status',
                  );
                },
              ),
              Container(
                width: width,
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.phone, color: Colors.deepOrange,),
                    border: UnderlineInputBorder(borderSide: BorderSide.none),
                    hintText: widget.contactNo,
                    hintStyle: DecorateText.getDecoratedTextStyle(
                        height: height, fontSize: 18, color: Colors.deepOrange),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container buildContainer(
    context, {
    String text,
    String caller,
  }) {
    final height = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: caller == 'Status' ? _statusController : _nameController,
        style: DecorateText.getDecoratedTextStyle(
            height: height, fontSize: 18, color: Colors.deepPurple),
        textAlign: TextAlign.start,
        cursorColor: Colors.deepPurple,
        keyboardType: TextInputType.visiblePassword,
        focusNode: caller == 'Status' ? statusfocusNode : namefocusNode,
        decoration: InputDecoration(
            suffixIcon: IconButton(
              splashColor: Colors.green,
              splashRadius: 20,
              onPressed: () async {
                setState(() {
                  caller == 'Status'
                      ? statusfocusNode.unfocus()
                      : namefocusNode.unfocus();
                });
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Updating...'),
                  duration: Duration(milliseconds: 300),
                ));

                if (caller == 'Status') {
                  _nameController.clear();
                  String value = _statusController.text.trim();
                  await handlingFirebaseDB.updateUserStatus(
                      userStatus: _statusController.text.trim().toString());
                  _statusController.clear();

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Updated'),
                    duration: Duration(milliseconds: 300),
                  ));
                  await Provider.of<GetChanges>(context, listen: false)
                      .updateUserStatus(value);
                  await Utility.setStatus(value);
                }
                if (caller == 'UserName') {
                  _statusController.clear();
                  String value = _nameController.text.trim();
                  await handlingFirebaseDB.updateUserName(name: value);
                  _nameController.clear();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Updated'),
                    duration: Duration(milliseconds: 300),
                  ));
                  await Provider.of<GetChanges>(context, listen: false)
                      .updateUserName(value);
                  await Utility.addUserName(value);
                }
              },
              icon: Icon(Icons.edit, color: Colors.green,),
            ),
            prefixIcon:
                caller == 'Status' ? Icon(Icons.error_outline_rounded, color: Colors.deepPurple,) : Icon(Icons.person_outline_rounded, color: Colors.deepPurple,),
            border: UnderlineInputBorder(borderSide: BorderSide.none),
            hintText: caller == 'Status' ? text : text,
            hintStyle: DecorateText.getDecoratedTextStyle(
                height: height, fontSize: 20, color: Colors.deepPurple)),
        onChanged: (value) {},
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _statusController.dispose();
    super.dispose();
  }
}
