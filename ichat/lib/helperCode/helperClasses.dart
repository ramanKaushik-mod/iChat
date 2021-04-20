

import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';


final String loginStatusKey = "LOGIN_STATUS_KEY";
final String userName = "USER_NAME";
final String imgKey = 'IMAGE_KEY';

class Utility{

  static addLoginStatus() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt(loginStatusKey, 0);
  }
  static getLoginStatus() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt(loginStatusKey);
  }
  static clearPreferences()async{
    await SharedPreferences.getInstance().then((value) => value.clear());
  }

  static Future<bool> saveImageToPreferences(String value) async{
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(imgKey, value);
  }

  static Future<String> getImageFromPreferences() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(imgKey);
  }

  static String base64String(Uint8List data){
    return base64Encode(data);
  }

  static Image imageFromBase64String(String base64String){
    return Image.memory(
      base64Decode(base64String), fit: BoxFit.fill,
    );
  }

  // User Info
  static addUserName(String name)async{
    await SharedPreferences.getInstance()
        .then((value) => value.setString(userName, name));
  }


  // _exit the app
  static exitApp(context){
    SystemNavigator.pop();
  }
}


class FirebaseUtility{
  static logout() async{
    await FirebaseAuth.instance.signOut();
  }
}


class DialogUtility {

  static int status = 0;

  static showLoadingDialog(BuildContext context, String e) {
    final width = MediaQuery.of(context).size.width;
    return showDialog(
        context: context,
        builder: (BuildContext c){
          if(status != 0){
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
                          SizedBox(width: 20,),
                          Text(
                            e,
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w500,
                              fontSize: width/24,
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

class ForAnimation extends ChangeNotifier
{
  var widthForContainer = 30.0;
  double getWidthOfContainer() => widthForContainer;

  changeWidthOfContainer(){
    widthForContainer = 60;
    notifyListeners();
    Future.delayed(Duration(seconds: 4),(){
      shrinkWidth();
    });
  }

  shrinkWidth(){
    widthForContainer = 30;
    notifyListeners();
  }

}
