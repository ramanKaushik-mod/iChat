import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ichat/helperCode/helperClasses.dart';
import 'package:ichat/helperCode/helperFunctions.dart';
import 'package:ichat/models/activeContactModel.dart';
import 'package:ichat/models/contactModel.dart';
import 'package:ichat/models/messageModel.dart';
import 'package:ichat/models/userModel.dart';

class FirebaseFunctions {
  static verifyNumber(context, String phoneNumber) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await auth.signInWithCredential(credential);
            if (FirebaseAuth.instance.currentUser != null) {
              await Utility.addContactToPreference(contact: phoneNumber);
              Navigator.pushNamed(context, '/profileScreen');
            }
          },
          verificationFailed: (FirebaseAuthException e) {
            if (e.code == 'invalid-phone-number') {
              showBottomModal(context,
                  dialogCode: "The provided phone number is not valid.");
            } else {
              showBottomModal(context, dialogCode: e.code.toString());
            }
            // Handle other errors
          },
          codeSent: (String verificationId, int resendToken) {
            Navigator.pushNamed(context, '/verifySmsScreen', arguments: {
              'phoneNumber': phoneNumber,
              'resendToken': resendToken,
              'vefyID': verificationId
            });
          },
          codeAutoRetrievalTimeout: (String verificationId) {});
    } on FirebaseAuthException catch (e) {
      showBottomModal(context, dialogCode: e.code.toString());
    }
  }

  static signInUser(
    context, {
    String smsCode,
    String phoneNumber,
    String vefyId,
  }) async {
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: vefyId, smsCode: smsCode);
      showBottomModal(context, dialogCode: "Loading...");
      await FirebaseAuth.instance.signInWithCredential(credential);

      if (FirebaseAuth.instance.currentUser != null) {
        await Utility.addContactToPreference(contact: phoneNumber);
        Navigator.pushNamed(context, '/profileScreen');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        showBottomModal(context, dialogCode: "invalid code");
      } else {
        showBottomModal(context, dialogCode: 'something went wrong');
      }
    }
  }

  static logoutAndClearPreferences() async {
    await FirebaseAuth.instance.signOut();
    await Utility.clearPreferences();
  }
}

class HandlingFirebaseDB {
  final String contactID;

  final CollectionReference _userCollection =
          FirebaseFirestore.instance.collection('Users'),
      _chatCollection = FirebaseFirestore.instance.collection('Chats');

  HandlingFirebaseDB({@required this.contactID});

  //*******************REFERENCE FUNCTIONS**********************/

  DocumentReference getUserDoc() => _userCollection.doc(contactID);
  DocumentReference getUserDocOfOther({@required String otherContactId}) =>
      _userCollection.doc(otherContactId);

  //new db structure for chats collection
  DocumentReference getChatDoc({@required String otherContactId}) =>
      _chatCollection
          .doc(this.contactID)
          .collection('myChats')
          .doc(otherContactId);

  DocumentReference getChatDocOfOther({@required String friendContactID}) =>
      _chatCollection
          .doc(friendContactID)
          .collection('myChats')
          .doc(this.contactID);

  Future<String> newChatRef({@required String otherContactId}) async =>
      getChatDoc(otherContactId: otherContactId)
          .collection('messages')
          .doc()
          .id
          .toString();

  //*******************REFERENCE FUNCTIONS END**********************/

  //*******************STREAM FUNCTIONS**********************/

  //contact list stream
  Stream<QuerySnapshot> getContactListAsStream() =>
      getUserDoc().collection('Contacts').orderBy('name').snapshots();

  //(activated contact list is refered as myChats in db) as stream
  Stream<QuerySnapshot> getActivatedContactListAsStream() => _chatCollection
      .doc(this.contactID)
      .collection('myChats')
      .orderBy('lastMsgTime')
      .snapshots();

  //Chat messages from doc needs changes or modify this concept if possible
  Stream<QuerySnapshot> getChatMessagesAsStream(
          {@required String otherContactId}) =>
      getChatDoc(otherContactId: otherContactId)
          .collection('messages')
          .orderBy('createdAt')
          .snapshots();

  //Stream for pendingList
  Stream<QuerySnapshot> getPendingListAsStream() => getUserDoc()
      .collection('PendingList')
      .orderBy('name', descending: true)
      .snapshots();

  //Stream for ForApprovedList
  Stream<QuerySnapshot> getForApprovedListAsStream() => getUserDoc()
      .collection('ForApproveList')
      .orderBy('name', descending: true)
      .snapshots();

  Stream<DocumentSnapshot> getOtherContactCredentialsAsStream(
          {@required String otherContactId}) =>
      getUserDocOfOther(otherContactId: otherContactId).snapshots();

  //*******************STREAM FUNCTIONS END**********************/

  //*******************MESSAGE FUNCTIONS**********************/

  setChatDoc({@required String otherContactNo, @required bool val}) async {
    await _chatCollection
        .doc(this.contactID)
        .collection('myChats')
        .doc(otherContactNo)
        .set({'activeStatus': val});

    await _chatCollection
        .doc(otherContactNo)
        .collection('myChats')
        .doc(this.contactID)
        .set({'activeStatus': val});
  }

  Future<bool> getChatDocStatus({@required String otherContactId}) async {
    return getChatDoc(otherContactId: otherContactId).get().then((value) {
      Map<String, dynamic> map = value.data();
      return map['activeStatus'];
    });
  }

  doMessage({@required Message message}) async {
    // writing to current user
    await getChatDoc(otherContactId: message.contactNo)
        .collection('messages')
        .doc(message.messageId)
        .set(message.toJson());

    // writing to other user
    await getChatDocOfOther(friendContactID: message.contactNo)
        .collection('messages')
        .doc(message.messageId)
        .set(message.toJson());

    await _chatCollection
        .doc(this.contactID)
        .collection('myChats')
        .doc(message.contactNo)
        .get()
        .then((value) async {
      print("value as null :::: ${value.data()}");
      if (value.data()['activeStatus'] == false) {
        await addContactToActivatedList(otherContactId: message.contactNo);
      }
    });
  }

  deleteMessage({@required Message message}) async {
    // deleting message from current user's sharedDocument
    await getChatDoc(otherContactId: message.contactNo)
        .collection('messages')
        .doc(message.messageId)
        .delete();

    // deleting message from other user's sharedDocument
    await getChatDocOfOther(friendContactID: message.contactNo)
        .collection('messages')
        .doc(message.messageId)
        .delete();
  }

  updateLastMessage(
      {@required String otherContactId, @required String lastMessage}) async {
    await _chatCollection
        .doc(this.contactID)
        .collection('myChats')
        .doc(otherContactId)
        .update({'lastMessage': lastMessage, 'lastMsgTime': Timestamp.now()});
    await _chatCollection
        .doc(otherContactId)
        .collection('myChats')
        .doc(this.contactID)
        .update({'lastMessage': lastMessage, 'lastMsgTime': Timestamp.now()});
  }
  //*******************MESSAGE FUNCTIONS END**********************/

  //******************* USER INFORMATION UPDATE FUNCTIONS**********************/

  updateUserName({@required String name}) async =>
      await _userCollection.doc(this.contactID).update({'name': name});

  updateUserImage() async => await _userCollection
      .doc(this.contactID)
      .update({'imageStr': await Utility.getImageFromPreferences()});

  updateUserStatus({@required String userStatus}) async => await _userCollection
      .doc(this.contactID)
      .update({'contactStatus': userStatus});

  // get fresh User name, image, status

  //******************* USER INFORMATION UPDATE FUNCTIONS END**********************/

  //******************* SETTING UP USER FUNCTIONS**********************/

  addUserToUsers({@required UserModel userModel, Function nextPage}) async {
    await getUserDoc().get().then((value) async {
      if (value.exists) {
        await this.updateUserImage();
        await this.updateUserName(name: userModel.name);
      } else {
        getUserDoc().set(userModel.toJson());
      }
    });
    nextPage();
  }

  //******************* SETTING UP USER FUNCTIONS END**********************/

  //******************* List(contactList, ActivatedContactList, PendingList, RequestApprovalList) FUNCTIONS**********************/

  //Streams are covered in the STREAM section above

  //TODO Add function related to various lists

  //here, this user is requesting
  updateRequest({@required String otherContactId}) async {
    Map<String, dynamic> map = await findUser(otherContactId: otherContactId);
    await getUserDoc().collection('PendingList').doc(otherContactId).set(map);
    await getUserDocOfOther(otherContactId: otherContactId)
        .collection('ForApproveList')
        .doc(this.contactID)
        .set(await findUser(otherContactId: this.contactID));
  }

  //this user is deleting the request made by him
  cancelRequest({@required String otherContactId}) async {
    await getUserDoc().collection('PendingList').doc(otherContactId).delete();
    await getUserDocOfOther(otherContactId: otherContactId)
        .collection('ForApproveList')
        .doc(this.contactID)
        .delete();
  }

  //this user is denying the request
  removeRequestFromApprovalAndPendingList(
      {@required String otherContactId}) async {
    await getUserDoc()
        .collection('ForApproveList')
        .doc(otherContactId)
        .delete();
    await getUserDocOfOther(otherContactId: otherContactId)
        .collection('PendingList')
        .doc(this.contactID)
        .delete();
  }

  addContactToContactList({@required String otherContactId}) async {
    await getUserDoc()
        .collection('ForApproveList')
        .doc(otherContactId)
        .delete();

    await getUserDoc().collection('Contacts').doc(otherContactId).set(
        ContactModel(
                contactNo: otherContactId,
                alignmentSemaphore: 0,
                name: await getUserDocOfOther(otherContactId: otherContactId)
                    .get()
                    .then((value) {
                  Map<String, dynamic> map = value.data();
                  return map['name'];
                }))
            .toJson());

    await getUserDocOfOther(otherContactId: otherContactId)
        .collection('Contacts')
        .doc(this.contactID)
        .set(ContactModel(
                contactNo: this.contactID,
                alignmentSemaphore: 1,
                name: await Utility.getUserName())
            .toJson());
    await getUserDocOfOther(otherContactId: otherContactId)
        .collection('PendingList')
        .doc(this.contactID)
        .delete();
    await setChatDoc(otherContactNo: otherContactId, val: false);
  }

  addContactToActivatedList({@required String otherContactId}) async {
    // activatedlist is as myChats in chats collection now
    ActiveContactModel acm2,
        acm1 = ActiveContactModel.fromMap(await getUserDoc()
            .collection('Contacts')
            .doc(otherContactId)
            .get()
            .then((value) => value.data()));
    acm1.lastMsgTime = Timestamp.now();
    acm1.activeStatus = true;
    acm2 = ActiveContactModel.fromMap(
        await getUserDocOfOther(otherContactId: otherContactId)
            .collection('Contacts')
            .doc(this.contactID)
            .get()
            .then((value) => value.data()));
    acm2.lastMsgTime = Timestamp.now();
    acm2.activeStatus = true;
    await _chatCollection
        .doc(this.contactID)
        .collection('myChats')
        .doc(otherContactId)
        .set(acm1.toJson());

    await _chatCollection
        .doc(otherContactId)
        .collection('myChats')
        .doc(this.contactID)
        .set(acm2.toJson());
  }

  //******************* List(contactList, ActivatedContactList, PendingList, RequestApprovalList) FUNCTIONS END**********************/

  //******************* OTHER UTILITY FUNCTIONS**********************/

  // check the otherContactId in the User Collection
  Future<Map<String, dynamic>> findUser(
      {@required String otherContactId}) async {
    Map<String, dynamic> map = {};
    await getUserDocOfOther(otherContactId: otherContactId).get().then((value) {
      if (value.exists) {
        map = value.data();
      }
    });

    return map;
  }

  // check the otherContactId in the contactList & ApprovedList

  Future<bool> presentInCollectionsOrNot(
      {@required String otherContactId,
      @required String collectionName}) async {
    bool presentOrNot = false;
    await getUserDoc()
        .collection(collectionName)
        .doc(otherContactId)
        .get()
        .then((value) {
      if (value.exists) {
        presentOrNot = true;
      }
    });
    return presentOrNot;
  }

  getOrSetUpdateOtherNameInContacts(
      {@required QueryDocumentSnapshot element}) async {
    Map<String, dynamic> map = element.data();
    DocumentReference docRef =
        await getUserDocOfOther(otherContactId: map['contactNo']);
    String name = await docRef.get().then((value) {
      Map<String, dynamic> map = value.data();
      return map['name'];
    });
    if (map['name'] != name) {
      await getUserDoc()
          .collection('Contacts')
          .doc(map['contactNo'])
          .update({'name': name});
    }
  }

  changeContactChatStatus({@required bool status}) async {
    await getUserDoc().update({'contactChatStatus': status});
  }

  //******************* OTHER UTILITY FUNCTIONS END**********************/

}
