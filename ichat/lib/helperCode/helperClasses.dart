import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ichat/models/approveRequestModel.dart';
import 'package:ichat/models/contactModel.dart';
import 'package:ichat/models/userModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

final String loginStatusKey = "LOGIN_STATUS_KEY";
final String userName = "USER_NAME";
final String imgKey = 'IMAGE_KEY';
final String contactNo = 'CONTACT_NUMBER';
final String lastMessage = 'LAST_MESSAGE';

class Utility {
  static SharedPreferences _preferences;
  static addLoginStatus() async {
    _preferences = await SharedPreferences.getInstance();
    _preferences.setInt(loginStatusKey, 0);
  }

  static getLoginStatus() async {
    _preferences = await SharedPreferences.getInstance();
    return _preferences.getInt(loginStatusKey);
  }

  static clearPreferences() async {
    await SharedPreferences.getInstance().then((value) => value.clear());
  }

  static Future<bool> saveImageToPreferences(String value) async {
    _preferences = await SharedPreferences.getInstance();
    return _preferences.setString(imgKey, value);
  }

  static Future<String> getImageFromPreferences() async {
    _preferences = await SharedPreferences.getInstance();
    return _preferences.getString(imgKey);
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }

  static Image imageFromBase64String(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      fit: BoxFit.fill,
    );
  }

  // User Info
  static addUserName(String name) async {
    await SharedPreferences.getInstance()
        .then((value) => value.setString(userName, name));
  }

  static addContactToPreference({@required String contact}) async {
    await SharedPreferences.getInstance()
        .then((value) => value.setString(contactNo, contact));
  }

  static getContactFromPreference() async {
    _preferences = await SharedPreferences.getInstance();
    return _preferences.get(contactNo);
  }

  static setLastMessage(String message) async {
    await SharedPreferences.getInstance()
        .then((value) => value.setString(lastMessage, message));
  }

  static getLastMessage() async {
    _preferences = await SharedPreferences.getInstance();
    return _preferences.get(lastMessage);
  }

  // _exit the app
  static exitApp(context) {
    SystemNavigator.pop();
  }

  //UI purpose
  static getTextStyle(double fontSize, Color color) {
    return GoogleFonts.muli(
      fontSize: fontSize,
      color: color,
      fontWeight: FontWeight.w700,
    );
  }

  static getChatTextStyle(double fontSize, Color color) {
    return GoogleFonts.muli(
      fontSize: fontSize,
      color: color,
      fontWeight: FontWeight.w600,
    );
  }
}

class FirebaseUtility {
  static logout() async {
    await FirebaseAuth.instance.signOut();
    await Utility.clearPreferences();
  }

  static addUserToUsers(Map<String, dynamic> data, {Function nextPage}) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Users').doc(data['contactNo']);

    await documentReference.get().then((value) {
      if (value.exists) {
        documentReference
            .update({'name': data['name'], 'imageStr': data['imageStr']});
      } else {
        documentReference.set(data);
      }
      nextPage();
    });
  }

  static Future<Map<String, dynamic>> findUser(
      {@required String contactNumber}) async {
    Map<String, dynamic> map;
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(contactNumber)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        map = documentSnapshot.data();
      }
    });
    return map;
  }

  static updateRequests(Map<String, dynamic> requestTo) async {
    var contactNo = await Utility.getContactFromPreference();
    Map<String, dynamic> thisUser = await findUser(contactNumber: contactNo);
    //this User's database
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(thisUser['contactNo'])
        .collection('PendingList')
        .doc(requestTo['contactNo'])
        .set(requestTo);

    //Requested User's database
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(requestTo['contactNo'])
        .collection('ForApproveList')
        .doc(thisUser['contactNo'])
        .set(thisUser);
  }

  static cancelRequest(
      {@required String requester, @required String requested}) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(requester)
        .collection('PendingList')
        .doc(requested)
        .delete();

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(requested)
        .collection('ForApproveList')
        .doc(requester)
        .delete();
  }

  static Future<List<UserTile>> getPendingList(
      {@required Function update}) async {
    List<UserTile> pendingList = [];
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(await Utility.getContactFromPreference())
        .collection('PendingList')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        Map<String, dynamic> map = element.data();
        pendingList.add(UserTile(
            buttonText: 'cancel',
            map: map,
            notifyChanges: () async {
              await FirebaseUtility.cancelRequest(
                  requested: map['contactNo'],
                  requester: await Utility.getContactFromPreference());
              update();
            }));
      });
    });
    return pendingList;
  }

  static Future<List<ApproveRequestTile>> getForApprovedList(
      {@required Function update}) async {
    List<ApproveRequestTile> approvePendingList = [];
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(await Utility.getContactFromPreference())
        .collection('ForApproveList')
        .get()
        .then((value) {
      approvePendingList = value.docs
          .map((e) => ApproveRequestTile(
                model: ApproveRequestModel.fromMap(e.data()),
              ))
          .toList();
    });
    return approvePendingList;
  }

  static addContactToContactList(
      {@required Map<String, dynamic> requesteeMap,
      @required Function updateUI}) async {
    //requestee - who have made the request

    String currentUserContact = await Utility.getContactFromPreference();
    DocumentReference sharedDoucment =
        FirebaseFirestore.instance.collection('Chats').doc();
    DocumentReference documentReference2,
        documentReference = FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUserContact);

    documentReference2 = FirebaseFirestore.instance
        .collection('Users')
        .doc(requesteeMap['contactNo']);

    //updateing user's contact list
    await documentReference
        .collection('Contacts')
        .doc(requesteeMap['contactNo'])
        .set(await documentReference2.get().then((value) => value.data()));
    await documentReference
        .collection('Contacts')
        .doc(requesteeMap['contactNo'])
        .update({'sharedDoucment': sharedDoucment.id, 'alignmentSemaphore': 0});

    //updating user's ForApproveList by deleting the requester
    await documentReference
        .collection('ForApproveList')
        .doc(requesteeMap['contactNo'])
        .delete();

    //requestee collection

    //requested deleted from the requester's pendinglist
    await documentReference2
        .collection('PendingList')
        .doc(currentUserContact)
        .delete();
    await documentReference2
        .collection('Contacts')
        .doc(currentUserContact)
        .set(await documentReference.get().then((value) => value.data()));
    await documentReference2
        .collection('Contacts')
        .doc(currentUserContact)
        .update({'sharedDoucment': sharedDoucment.id, 'alignmentSemaphore': 1});

    await sharedDoucment.set({'activeStatus': false});
    updateUI();
  }

  static removeFromContactList(
      {@required String requester, @required Function updateUI}) async {
    String currentUserContact = await Utility.getContactFromPreference();
    DocumentReference documentReference2,
        documentReference = FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUserContact);

    documentReference2 =
        FirebaseFirestore.instance.collection('Users').doc(requester);

    await documentReference
        .collection('ForApproveList')
        .doc(requester) //requester - number of person who have made the request
        .delete();

    //requestee collection

    //requested deleted from the requester's pendinglist
    await documentReference2
        .collection('PendingList')
        .doc(currentUserContact)
        .delete();

    updateUI();
  }

  static Future<List<ContactTile>> getContactList(
      {@required Function update}) async {
    List<ContactTile> contactList = [];
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(await Utility.getContactFromPreference())
        .collection('Contacts')
        .get()
        .then((value) {
      contactList = value.docs
          .map((e) => ContactTile(
                model: ContactModel.fromMap(e.data()),
              ))
          .toList();
      update();
    });
    return contactList;
  }

  static doMessage(
      {@required Map<String, dynamic> message,
      @required String sharedDoucment}) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Chats').doc(sharedDoucment);
    await documentReference.get().then((value) async {
      if (value.data()['activeStatus'] == false) {
        await addContactToActivatedList(
            otherPersonContact: message['contactNo']);
        await documentReference.collection('messages').doc().set(message);
        await documentReference.update({'activeStatus': true});
      } else {
        await documentReference.collection('messages').doc().set(message);
      }
    });
  }

  static addContactToActivatedList({@required otherPersonContact}) async {
    String currentUserContact = await Utility.getContactFromPreference();

    DocumentReference otherUserDoc,
        currentUserDoc = FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUserContact);
    await currentUserDoc
        .collection('ActivatedContacts')
        .doc(otherPersonContact)
        .set(await currentUserDoc
            .collection('Contacts')
            .doc(otherPersonContact)
            .get()
            .then((value) => value.data()));

    otherUserDoc =
        FirebaseFirestore.instance.collection('Users').doc(otherPersonContact);
    await otherUserDoc
        .collection('ActivatedContacts')
        .doc(currentUserContact)
        .set(await otherUserDoc
            .collection('Contacts')
            .doc(currentUserContact)
            .get()
            .then((value) => value.data()));
  }

  static Future<ContactModel> getUserDetails() async {
    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(await Utility.getContactFromPreference())
        .get()
        .then((value) => ContactModel.fromMap(value.data()));
  }
}

class DialogUtility {
  static int status = 0;

  static showLoadingDialog(BuildContext context, String e) {
    final width = MediaQuery.of(context).size.width;
    return showDialog(
        context: context,
        builder: (BuildContext c) {
          if (status != 0) {
            Navigator.of(context).pop();
          }
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            backgroundColor: Colors.transparent,
            content: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              child: Wrap(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.blue),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            e,
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w500,
                              fontSize: width / 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class GetChanges extends ChangeNotifier {
  int semaphoreForMainScreen = 0;
  int getSemaphoreForMainScreen() => semaphoreForMainScreen;
  int currentTime = 0;
  int getUpdatedTime() => currentTime;
  UserTile userTile;
  UserTile getUpdatedUserTile() => userTile;
  String btnText = 'request';
  String getbtnText() => btnText;

  updateMainSemaphore0() {
    semaphoreForMainScreen = 0;
    notifyListeners();
  }

  updateMainSemaphore1() {
    semaphoreForMainScreen = 1;
    notifyListeners();
  }

  updateTime() {
    currentTime++;
    notifyListeners();
  }

  updateUserTile(UserTile userTile) {
    this.userTile = userTile;
    notifyListeners();
  }

  turnUserTileToNull() {
    userTile = null;
    notifyListeners();
  }

  removeUserTile() {
    userTile = null;
    notifyListeners();
  }

  updateBtnText() {
    btnText = 'request...';
    notifyListeners();
  }

  setBtnText() {
    btnText = 'request';
    notifyListeners();
  }
}
