import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ichat/helperCode/firebaseFunctions.dart';
import 'package:ichat/helperCode/helperFunctions.dart';
import 'package:ichat/models/activeContactModel.dart';
import 'package:ichat/models/contactModel.dart';
import 'package:ichat/models/userModel.dart';
import 'package:ichat/helperCode/helperClasses.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final Function close, changePage;
  ChatPage({@required this.close, @required this.changePage});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Future<int> dbReady;
  HandlingFirebaseDB handlingFirebaseDB;
  @override
  void initState() {
    super.initState();
    getDBInstance();
  }

  getDBInstance() async {
    handlingFirebaseDB =
        HandlingFirebaseDB(contactID: await Utility.getContactFromPreference());
    setState(() {
      dbReady = Future.value(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    var expanded = Expanded(
      child: FutureBuilder<int>(
        future: dbReady,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return StreamBuilder<QuerySnapshot>(
              stream: handlingFirebaseDB.getActivatedContactListAsStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFFF2F2F7)),
                    ),
                  );
                }
                List<ActiveContactTile> list = snapshot.data.docs
                    .map((e) => ActiveContactTile(
                        model: ActiveContactModel.fromMap(e.data()),
                        contactID: handlingFirebaseDB.contactID))
                    .toList();
                list.removeWhere((element) => element == null);
                return snapshot.data.docs.isNotEmpty
                    ? SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        physics: BouncingScrollPhysics(),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: list),
                      )
                    : Center(
                        child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(26),
                            ),
                            child: Card(
                              elevation: 20,
                              color: Color(0xFFF2F2F7),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Text(
                                  "Search iChat \nyou don't have any\nfriends or collegues to chat with\nright now",
                                  style: DecorateText.getDecoratedTextStyle(
                                    height: height,
                                    fontSize: 14,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                              ),
                            )),
                      );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF2F2F7)),
            ),
          );
        },
      ),
    );
    var bottomSheetContainer = Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      width: width,
      child: Wrap(
        alignment: WrapAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    widget.changePage();
                  },
                  child: Card(
                    elevation: 10,
                    margin: EdgeInsets.only(right: 20),
                    color: Color(0xFFF2F2F7),
                    shadowColor: Color(0xFFF2F2F7),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Container(
                        padding: EdgeInsets.all(16),
                        child: Center(
                          child: DecorateText.getDecoratedText(
                              text: 'Search iChat',
                              height: height,
                              color: Colors.green,
                              fontWeight: FontWeight.w600),
                        )),
                  ),
                ),
              ),
              Card(
                elevation: 10,
                color: Color(0xFFF2F2F7),
                shadowColor: Color(0xFFF2F2F7),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: IconButton(
                  splashColor: Colors.deepPurple,
                  splashRadius: 20,
                  onPressed: () {
                    Navigator.pushNamed(context, '/userScreen',
                        arguments: handlingFirebaseDB.contactID);
                  },
                  icon: Icon(
                    Icons.person,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Card(
                elevation: 20,
                color: Color(0xFFF2F2F7),
                shadowColor: Color(0xFFF2F2F7),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: IconButton(
                  splashColor: Colors.grey[600],
                  splashRadius: 20,
                  onPressed: () {
                    Navigator.pushNamed(context, '/contactScreen');
                  },
                  icon: Icon(
                    Icons.notifications,
                    color: Colors.grey[600],
                  ),
                ),
              )
            ],
          ),
          Container(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {},
                  child: Card(
                    elevation: 10,
                    margin: EdgeInsets.only(right: 20),
                    color: Color(0xFFF2F2F7),
                    shadowColor: Color(0xFFF2F2F7),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Container(
                        padding: EdgeInsets.all(16),
                        child: Center(
                          child: DecorateText.getDecoratedText(
                              text: 'Share iChat',
                              height: height,
                              color: Colors.blue,
                              fontWeight: FontWeight.w800),
                        )),
                  ),
                ),
              ),
              Card(
                elevation: 10,
                color: Color(0xFFF2F2F7),
                shadowColor: Color(0xFFF2F2F7),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: IconButton(
                  splashColor: Colors.green,
                  splashRadius: 20,
                  onPressed: () {
                    Navigator.pushNamed(context, '/contactScreen');
                  },
                  icon: Icon(
                    Icons.settings,
                    color: Colors.green,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Card(
                elevation: 10,
                color: Color(0xFFF2F2F7),
                shadowColor: Color(0xFFF2F2F7),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: IconButton(
                  splashColor: Colors.deepOrange,
                  splashRadius: 20,
                  onPressed: () {
                    widget.changePage();
                  },
                  icon: Icon(
                    Icons.search,
                    color: Colors.deepOrange,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
    return WillPopScope(
      onWillPop: () {
        widget.close();
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          color: Color(0xFFF2F2F7),
          height: height,
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              expanded,
              bottomSheetContainer,
            ],
          ),
        ),
      ),
    );
  }
}

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  HandlingFirebaseDB handlingFirebaseDB;
  Future<int> dbReady;
  @override
  void initState() {
    super.initState();
    getDBInstance();
  }

  getDBInstance() async {
    handlingFirebaseDB =
        HandlingFirebaseDB(contactID: await Utility.getContactFromPreference());

    setState(() {
      dbReady = Future.value(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    var expanded = Expanded(
      child: FutureBuilder(
        future: dbReady,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return StreamBuilder<QuerySnapshot>(
              stream: handlingFirebaseDB.getContactListAsStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFFF2F2F7)),
                    ),
                  );
                }
                if (snapshot.data.docs.isNotEmpty) {
                  snapshot.data.docs.forEach((element) async {
                    await handlingFirebaseDB.getOrSetUpdateOtherNameInContacts(
                        element: element);
                  });
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: snapshot.data.docs
                          .map((e) => ContactTile(
                              model: ContactModel.fromMap(e.data()),
                              contactID: handlingFirebaseDB.contactID))
                          .toList(),
                    ),
                  );
                } else {
                  return Center(
                    child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(26),
                        ),
                        child: Card(
                          elevation: 20,
                          color: Color(0xFFF2F2F7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Text(
                              "You don't have any contacts yet",
                              style: DecorateText.getDecoratedTextStyle(
                                height: height,
                                fontSize: 14,
                                color: Colors.deepPurple,
                              ),
                            ),
                          ),
                        )),
                  );
                }
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF2F2F7)),
            ),
          );
        },
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.grey[600])),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(color: Color(0xFFF2F2F7)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                width: width,
                color: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Text(
                  'Contacts',
                  style: DecorateText.getDecoratedTextStyle(
                    height: height,
                    fontSize: 26,
                    color: Colors.green,
                  ),
                )),
            Divider(
              color: Colors.white,
              thickness: 1,
            ),
            expanded,
            SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }
}

class RequestPage extends StatefulWidget {
  final Function close;
  RequestPage({@required this.close});
  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  UserTile _userTile;
  final TextEditingController _controller = TextEditingController();
  FocusNode _focusNode;
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

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () {
        widget.close();
        Provider.of<GetChanges>(context, listen: false).turnUserTileToNull();
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          bottomSheet: BottomSheet(
              onClosing: () {},
              enableDrag: false,
              builder: (BuildContext context) {
                return Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Card(
                        elevation: 20,
                        color: Color(0xFFF2F2F7),
                        shadowColor: Color(0xFFF2F2F7),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        child: IconButton(
                          splashRadius: 20,
                          splashColor: Colors.green,
                          onPressed: () {
                            Navigator.pushNamed(context, '/contactScreen');
                          },
                          icon: Icon(Icons.connect_without_contact_sharp),
                          color: Colors.green,
                        ),
                      ),
                      Card(
                        elevation: 20,
                        color: Color(0xFFF2F2F7),
                        shadowColor: Color(0xFFF2F2F7),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        child: IconButton(
                            splashRadius: 20,
                            splashColor: Colors.deepPurple,
                            onPressed: () {
                              Navigator.pushNamed(context, '/pendingScreen');
                            },
                            icon: Icon(Icons.pending_actions_rounded,
                                color: Colors.deepPurple)),
                      ),
                      Card(
                          elevation: 20,
                          color: Color(0xFFF2F2F7),
                          shadowColor: Color(0xFFF2F2F7),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          child: IconButton(
                              splashColor: Colors.red,
                              splashRadius: 20,
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/requestScreen',
                                );
                              },
                              icon: Icon(
                                Icons.safety_divider_rounded,
                                color: Colors.red,
                              )))
                    ],
                  ),
                );
              }),
          body: Container(
            color: Color(0xFFF2F2F7),
            child: Stack(
              children: [
                Center(
                  child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(26),
                      ),
                      child: Card(
                        elevation: 20,
                        color: Color(0xFFF2F2F7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Text(
                              "Search iChat \n\nEnter a 10 digit number\nto find your friends on iChat",
                              style: DecorateText.getDecoratedTextStyle(
                                height: height,
                                fontSize: 14,
                                color: Colors.deepPurple,
                              ),
                            )),
                      )),
                ),
                Container(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Wrap(
                        children: [
                          ConstrainedBox(
                            constraints:
                                BoxConstraints(maxHeight: 240, minHeight: 140),
                            child: Container(
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Card(
                                          color: Color(0xFFF2F2F7),
                                          shadowColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(14)),
                                          elevation: 20,
                                          margin: EdgeInsets.all(10),
                                          child: Container(
                                            padding: EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                            child: TextField(
                                              showCursor: false,
                                              controller: _controller,
                                              style: DecorateText
                                                  .getDecoratedTextStyle(
                                                      height: height,
                                                      fontSize: 20,
                                                      color: Colors.deepPurple),
                                              textAlign: TextAlign.center,
                                              keyboardType:
                                                  TextInputType.number,
                                              focusNode: _focusNode,
                                              decoration: InputDecoration(
                                                  border: UnderlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                  ),
                                                  hintText: 'Search Here',
                                                  hintStyle: DecorateText
                                                      .getDecoratedTextStyle(
                                                          height: height,
                                                          fontSize: 22,
                                                          color: Colors
                                                              .deepPurple)),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Card(
                                        elevation: 10,
                                        margin: EdgeInsets.only(
                                            right: 20, left: 10),
                                        color: Color(0xFFF2F2F7),
                                        shadowColor: Color(0xFFF2F2F7),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: IconButton(
                                          splashRadius: 20,
                                          splashColor: Colors.deepPurple,
                                          color: Color(0xFFF2F2F7),
                                          onPressed: () async {
                                            setState(() {
                                              _focusNode.unfocus();
                                            });

                                            var contactNo =
                                                _controller.text.trim();

                                            if (contactNo.length != 10) {
                                              showBottomModal(context,
                                                  dialogCode:
                                                      'Enter a 10 digit number');
                                            } else {
                                              for (var item
                                                  in contactNo.split("")) {
                                                if (!item.contains(
                                                    RegExp(r'[0-9]'))) {
                                                  _controller.clear();
                                                }
                                              }
                                            }
                                            if (await Utility
                                                    .getContactFromPreference() ==
                                                '+91$contactNo') {
                                              showBottomModal(context,
                                                  dialogCode: "It's you");
                                              _controller.clear();
                                            }

                                            if (await handlingFirebaseDB
                                                    .presentInCollectionsOrNot(
                                                        otherContactId:
                                                            '+91$contactNo',
                                                        collectionName:
                                                            'Contacts') ==
                                                true) {
                                              showBottomModal(context,
                                                  dialogCode:
                                                      "check ${_controller.text} in Contacts");
                                              _controller.clear();
                                            } else if (await handlingFirebaseDB
                                                    .presentInCollectionsOrNot(
                                                        otherContactId:
                                                            '+91$contactNo',
                                                        collectionName:
                                                            'PendingList') ==
                                                true) {
                                              showBottomModal(context,
                                                  dialogCode:
                                                      "${_controller.text} present in Request Queue");
                                              _controller.clear();
                                            } else if (await handlingFirebaseDB
                                                    .presentInCollectionsOrNot(
                                                        otherContactId:
                                                            '+91$contactNo',
                                                        collectionName:
                                                            'ForApproveList') ==
                                                true) {
                                              showBottomModal(context,
                                                  dialogCode:
                                                      "${_controller.text} present in Pending Queue");
                                              _controller.clear();
                                            }

                                            if (_controller.text
                                                    .trim()
                                                    .length ==
                                                10) {
                                              //check that number exists or not
                                              //if exists, turn it into a UserTile object
                                              Map<String, dynamic> map =
                                                  await handlingFirebaseDB
                                                      .findUser(
                                                          otherContactId:
                                                              '+91$contactNo');

                                              if (map != null &&
                                                  map.isNotEmpty) {
                                                var getChanges =
                                                    Provider.of<GetChanges>(
                                                        context,
                                                        listen: false);
                                                _userTile = UserTile(
                                                    buttonText: 'request',
                                                    userModel:
                                                        UserModel.fromMap(map),
                                                    notifyChanges: () async {
                                                      getChanges
                                                          .removeUserTile();
                                                    });

                                                getChanges
                                                    .updateUserTile(_userTile);
                                              } else {
                                                showBottomModal(context,
                                                    dialogCode:
                                                        '${_controller.text.trim()} is not registered');
                                                _controller.clear();
                                              }
                                            }
                                          },
                                          icon: Icon(
                                            Icons.search,
                                            color: Colors.deepPurple,
                                          ),
                                        ),
                                      ),
                                      Card(
                                        elevation: 10,
                                        margin: EdgeInsets.only(right: 20),
                                        color: Color(0xFFF2F2F7),
                                        shadowColor: Color(0xFFF2F2F7),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: IconButton(
                                          color: Color(0xFFF2F2F7),
                                          splashRadius: 20,
                                          splashColor: Colors.deepOrange,
                                          onPressed: () {
                                            Provider.of<GetChanges>(context,
                                                    listen: false)
                                                .turnUserTileToNull();
                                            _controller.clear();
                                          },
                                          icon: Icon(Icons.clear,
                                              color: Colors.deepOrange),
                                        ),
                                      )
                                    ],
                                  ),
                                  Expanded(
                                    child: Consumer<GetChanges>(
                                      builder: (BuildContext context, value,
                                          Widget child) {
                                        return value.userTile != null
                                            ? value.getUpdatedUserTile()
                                            : Center(
                                                child: Icon(
                                                  Icons.search,
                                                  size: 50,
                                                  color: Colors.blue[100],
                                                ),
                                              );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
