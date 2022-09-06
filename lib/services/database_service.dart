import 'package:agora_care/services/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  // reference for our collections
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference cellsCollection =
      FirebaseFirestore.instance.collection("cells");
  final CollectionReference quoteCollection =
      FirebaseFirestore.instance.collection("quote");

  final _authController = Get.find<AuthControllers>();

  // saving the userdata
  Future savingUserData(String email) async {
    return await userCollection.doc(uid).set({
      "email": email,
      "groups": [],
      "profilePic": "",
      "uid": uid,
    });
  }

  // getting user data
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  // get user groups
  getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }

  // creating a group
  // Future createGroup(String email, String id, String groupName) async {
  //   DocumentReference groupDocumentReference = await cellsCollection.add({
  //     "groupName": groupName,
  //     "groupIcon": "",
  //     // "admin": "${id}_$email",
  //     "admin": _authController.liveUser.value!.role,
  //     "members": [],
  //     "groupId": "",
  //     "recentMessage": "",
  //     "recentMessageSender": "",
  //   });
  //   // update the members
  //   await groupDocumentReference.update({
  //     "members": FieldValue.arrayUnion(["${uid}_$email"]),
  //     "groupId": groupDocumentReference.id,
  //   });
  //   if (kDebugMode) {
  //     print(" The group name$groupName");
  //   }
  //   DocumentReference userDocumentReference = userCollection.doc(uid);
  //   return await userDocumentReference.update({
  //     "groups":
  //         FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
  //   });
  // }

  // getting the chats
  getChats(String groupId) async {
    return cellsCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  // getting the chats
  getComment(String groupId) async {
    return quoteCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  Future getGroupAdmin(String groupId) async {
    DocumentReference d = cellsCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }

  Future getQuoteAdmin(String groupId) async {
    DocumentReference d = quoteCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }

  // get group members
  getGroupMembers(groupId) async {
    return cellsCollection.doc(groupId).snapshots();
  }

  // search
  searchByName(String groupName) {
    return cellsCollection.where("groupName", isEqualTo: groupName).get();
  }

  // function -> bool
  Future<bool> isUserJoined(
      String groupName, String groupId, String userName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> groups = await documentSnapshot['groups'];
    if (groups.contains("${groupId}_$groupName")) {
      return true;
    } else {
      return false;
    }
  }

  // toggling the group join/exit
  Future toggleGroupJoin(
      String groupId, String userEmail, String groupName) async {
    // doc reference
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = cellsCollection.doc(groupId);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];

    // if user has our groups -> then remove then or also in other part re join
    if (groups.contains("${groupId}_$groupName")) {
      await userDocumentReference.update({
        "groups": FieldValue.arrayRemove(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayRemove(["${uid}_$userEmail"])
      });
    } else {
      await userDocumentReference.update({
        "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayUnion(["${uid}_$userEmail"])
      });
    }
  }

  // send message
  sendMessage(String groupId, Map<String, dynamic> chatMessageData) async {
    if (kDebugMode) {
      print("the group id is $groupId");
    }
    cellsCollection.doc(groupId).collection("messages").add(chatMessageData);
    cellsCollection.doc(groupId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString(),
    });
  }

  sendComment(String groupId, Map<String, dynamic> chatMessageData) async {
    if (kDebugMode) {
      print("the group id is $groupId");
    }
    quoteCollection.doc(groupId).collection("messages").add(chatMessageData);
    quoteCollection.doc(groupId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString(),
    });
  }
}
