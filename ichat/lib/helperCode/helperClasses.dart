

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


final String loginStatusKey = "LOGIN_STATUS_KEY";
final String userName = "USER_NAME";

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

  // User Info
  static addUserName(String name)async{
    await SharedPreferences.getInstance()
        .then((value) => value.setString(userName, name));
  }
}


class FirebaseUtility{
  static logout() async{
    await FirebaseAuth.instance.signOut();
  }
}


class DialogUtility{

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