import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ichat/Models/userModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

final String loginStatusKey = "LOGIN_STATUS_KEY";
final String userName = "USER_NAME";
final String imgKey = 'IMAGE_KEY';
final String contactNo = 'CONTACT_NUMBER';

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

  // _exit the app
  static exitApp(context) {
    SystemNavigator.pop();
  }
}

class FirebaseUtility {
  static logout() async {
    await FirebaseAuth.instance.signOut();
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
  int currentTime = 0;
  int getUpdatedTime() => currentTime;
  UserTile userTile;
  UserTile getUpdatedUserTile() => userTile;
  List<UserTile> pendingList;
  List<UserTile> getPendingList() => pendingList;

  updateTime() {
    currentTime++;
    notifyListeners();
  }

  updateUserTile(UserTile userTile) {
    this.userTile = userTile;
    notifyListeners();
  }

  updatePendingList() async {
    pendingList = [];
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
            notifyChanges: () {
              print("call a function to delete the request");
            }));
      });
    });
    notifyListeners();
  }

  removeUserTile() {
    userTile = null;
    notifyListeners();
  }
}
