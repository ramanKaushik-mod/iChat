import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ichat/models/userModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

final String loginStatusKey = "LOGIN_STATUS_KEY";
final String userName = "USER_NAME";
final String imgKey = 'IMAGE_KEY';
final String contactNo = 'CONTACT_NUMBER';
final String lastMessage = 'LAST_MESSAGE';
final String contactStatus = 'CONTACT_STATUS';

class Utility {
  static Future<SharedPreferences> _preferences =
      SharedPreferences.getInstance();
  static addLoginStatus() async {
    _preferences.then((value) => value.setInt(loginStatusKey, 0));
  }

  static getLoginStatus() async {
    return _preferences.then((value) => value.getInt(loginStatusKey));
  }

  static clearPreferences() async {
    await _preferences.then((value) => value.clear());
  }

  static Future<bool> saveImageToPreferences(String image) async {
    return _preferences.then((value) => value.setString(imgKey, image));
  }

  static Future<String> getImageFromPreferences() async {
    return _preferences.then((value) => value.getString(imgKey));
  }

  static removeImage() async {
    await _preferences.then((value) => value.remove(imgKey));
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
    await _preferences.then((value) => value.setString(userName, name));
  }

  static getUserName() async {
    return await _preferences.then((value) => value.getString(userName));
  }

  static setStatus(String status) async {
    await _preferences.then((value) => value.setString(contactStatus, status));
  }

  static getStatus() async {
    return _preferences.then((value) => value.getString(contactStatus));
  }

  static addContactToPreference({@required String contact}) async {
    await SharedPreferences.getInstance()
        .then((value) => value.setString(contactNo, contact));
  }

  static getContactFromPreference() async {
    return _preferences.then((value) => value.getString(contactNo));
  }

  static setLastMessage(String message) async {
    await _preferences.then((value) => value.setString(lastMessage, message));
  }

  static getLastMessage() async {
    return _preferences.then((value) => value.getString(lastMessage));
  }

  // _exit the app
  static exitApp(context) {
    SystemNavigator.pop();
  }
}

class GetChanges extends ChangeNotifier {
  String userName, userStatus;
  String getUserName() => userName;
  String getUserStatus() => userStatus;
  int time = 30;
  int getUpdateTime() => time;

  int semaphoreForMainScreen = 0;
  int getSemaphoreForMainScreen() => semaphoreForMainScreen;
  int currentTime = 0;
  int getUpdatedTime() => currentTime;
  UserTile userTile;
  UserTile getUpdatedUserTile() => userTile;
  String btnText = 'request';
  String getbtnText() => btnText;
  Image userImage;
  Future<Image> getUserImage() async {
    userImage = Image.memory(
      base64Decode(await Utility.getImageFromPreferences()),
      fit: BoxFit.fill,
    );
    return userImage;
  }

  setUserImageToNull() {
    userImage = null;
    notifyListeners();
  }

  setUserImage() async {
    userImage = await getUserImage();
    notifyListeners();
  }

  updateUserName(String name) {
    userName = name;
    notifyListeners();
  }

  updateUserStatus(String status) {
    userStatus = status;
    notifyListeners();
  }

  updateSmsWaitingTime({Function cancelTimer}) {
    if (time == 0) {
      cancelTimer();
    } else {
      time--;
      notifyListeners();
    }
  }

  turnTimeTo30() {
    time = 30;
    notifyListeners();
  }

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

class DecorateText {
  static getDecoratedText(
      {String text,
      double height,
      Color color,
      FontWeight fontWeight,
      String little}) {
    return Text(
      text,
      style: GoogleFonts.muli(
        fontSize: little == null ? height / 44 : height / 56,
        color: color,
        fontWeight: fontWeight,
      ),
    );
  }

  static getDecoratedNumberStyle() {
    return GoogleFonts.muli(
        fontSize: 18, color: Colors.grey[700], fontWeight: FontWeight.w500);
  }

  static getDecoratedTextStyle(
      {@required double height,
      @required double fontSize,
      @required Color color}) {
    return GoogleFonts.muli(
        decoration: TextDecoration.none,
        fontSize: fontSize * (height / 800),
        color: color,
        fontWeight: FontWeight.w600);
  }

  static getMeDecoratedChatTextStyle() {
    return GoogleFonts.muli(
        decoration: TextDecoration.none,
        fontSize: 16,
        color: Colors.white,
        fontWeight: FontWeight.w600);
  }
}
