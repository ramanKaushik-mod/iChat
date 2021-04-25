import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ichat/Models/userModel.dart';
import 'package:ichat/helperCode/helperClasses.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Utility.exitApp(context);
        return Future.value(false);
      },
      child: Container(
        child: Center(
          child: Text('Chat Page'),
        ),
      ),
    );
  }
}

class ContactPage extends StatelessWidget {
  final PageController pageController;

  ContactPage({this.pageController});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        pageController.jumpToPage(0);
        return Future.value(false);
      },
      child: Container(
        child: Center(
          child: Text('Contact Page'),
        ),
      ),
    );
  }
}

class RequestPage extends StatefulWidget {
  final PageController pageController;
  TextEditingController _controller = TextEditingController();

  RequestPage({this.pageController});

  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  UserTile _userTile;

  @override
  Widget build(BuildContext context) {
    // Provider.of<GetChanges>(context, listen: false).updatePendingList();
    // final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () {
        widget.pageController.jumpToPage(0);
        return Future.value(false);
      },
      child: Stack(
        children: [
          Center(child: Icon(Icons.verified_user_rounded, color: Colors.white,size: 100,),),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  height: 180,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20), color: Colors.white),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 40,
                              padding: EdgeInsets.only(left: 20),
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Color(0xFFF2F2F2)),
                              child: TextField(
                                controller: widget._controller,
                                style: getTextStyle(),
                                textAlign: TextAlign.start,
                                keyboardType: TextInputType.visiblePassword,
                                cursorColor: Colors.blue,
                                decoration: InputDecoration(
                                    // suffixIcon:
                                    border: UnderlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                    hintText: 'Search Here',
                                    hintStyle: getTextStyle()),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: IconButton(
                              color: Colors.grey[600],
                              onPressed: () async {
                                var contactNo = widget._controller.text.trim();
                                if (contactNo.length != 10) {
                                  print("length is not apropriate");
                                } else {
                                  for (var item in contactNo.split("")) {
                                    if (!item.contains(RegExp(r'[0-9]'))) {
                                      widget._controller.clear();
                                    }
                                  }
                                }

                                if (widget._controller.text.trim().length == 10) {
                                  //check that number exists or not
                                  //if exists, turn it into a UserTile object
                                  Map<String, dynamic> map =
                                      await FirebaseUtility.findUser(
                                          contactNumber: '+91$contactNo');

                                  if (map.isNotEmpty) {
                                    var getChanges = Provider.of<GetChanges>(
                                        context,
                                        listen: false);
                                    _userTile = UserTile(
                                        buttonText: 'Request',
                                        map: map,
                                        notifyChanges: () async {
                                          getChanges.removeUserTile();
                                          getChanges.updatePendingList();
                                        });

                                    getChanges.updateUserTile(_userTile);
                                  }
                                }
                              },
                              icon: Icon(Icons.search),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Consumer<GetChanges>(
                          builder: (BuildContext context, value, Widget child) {
                            return value.userTile != null
                                ? value.getUpdatedUserTile()
                                : Center(
                                    child: Icon(
                                      Icons.search,
                                      size: 50,
                                      color: Colors.grey[300],
                                    ),
                                  );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // Container(
                //   height: MediaQuery.of(context).size.height / 2,
                //   width: width,
                //   // color: Colors.blue,
                //   child: SingleChildScrollView(
                //       scrollDirection: Axis.vertical,
                //       child: Consumer<GetChanges>(
                //         builder: (BuildContext context, value, Widget child) {
                //           return value.pendingList == null ||
                //                   value.pendingList.isEmpty
                //               ? Center(child: Text('No requests'))
                //               : Column(
                //                   children: value.pendingList,
                //                 );
                //         },
                //       )),
                // ),
                Container(
                  margin: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            textStyle: getTextStyle(),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text('Pendings'),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            textStyle: getTextStyle(),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text('Requests'),
                        ),
                      ),
                      SizedBox(height: 80),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextStyle getTextStyle() {
    return GoogleFonts.muli(
        decoration: TextDecoration.none,
        fontWeight: FontWeight.w600,
        fontSize: 20,
        color: Colors.grey[500]);
  }
}
