import 'dart:async';

import 'package:flutter/material.dart';

showDialogue(BuildContext context, String e) {
  return showDialog(
      context: context,
      builder: (BuildContext c){
        Future.delayed(Duration(seconds: 3),(){
          Navigator.of(context).pop(true);
        });
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
                      child: Text(
                        e,
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
      });
}




showLoadingDialog(BuildContext context, String e) {
  final width = MediaQuery.of(context).size.width;
  return showDialog(
      context: context,
      builder: (BuildContext c){
        Future.delayed(Duration(seconds: 2),(){
          Navigator.of(context).pop();
        });
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

