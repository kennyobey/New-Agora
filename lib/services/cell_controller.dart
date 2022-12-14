// ignore_for_file: unnecessary_null_comparison, unused_field

import 'package:agora_care/app/model/cells_model.dart';
import 'package:agora_care/app/model/message_model.dart';
import 'package:agora_care/app/model/user_model.dart';
import 'package:agora_care/core/constants.dart';
import 'package:agora_care/helper/helper_function.dart';
import 'package:agora_care/services/auth_controller.dart';
import 'package:agora_care/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

// ignore: constant_identifier_names
enum CellStatus { LOADING, ERROR, EMPTY, SUCCESS, AVAILABLE, NOTAVAILABLE }

class CellControllers extends GetxController {
  final _authController = Get.find<AuthControllers>();
  DatabaseService? uid;
  DocumentReference? groupDocumentReference;

  final Rx<CellStatus> _cellStatus = Rx(CellStatus.EMPTY);
  CellStatus get cellStatus => _cellStatus.value;

  final CollectionReference cellCollection =
      FirebaseFirestore.instance.collection("cells");
  final CollectionReference messagesCollection = FirebaseFirestore.instance
      .collection("cells")
      .doc()
      .collection('messages');
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  Rx<UserModel> liveUser = UserModel().obs;
  UserModel get users => liveUser.value;

  final Rx<List<CellModel>> _availableCell = Rx([]);
  List<CellModel> get allAvailableCell => _availableCell.value;

  final Rx<List<MessageModel>> _messageList = Rx([]);
  List<MessageModel> get allMessages => _messageList.value;

  FirebaseAuth auth = FirebaseAuth.instance;
  final _newCell = FirebaseFirestore.instance.collection("cells");
  final _newMessage = FirebaseFirestore.instance
      .collection("cells")
      .doc()
      .collection('messages');
  final _cellDoc = FirebaseFirestore.instance.collection("cells");

  final _userDoc = FirebaseFirestore.instance.collection("users");

  @override
  void onInit() async {
    super.onInit();
    _authController.liveUser.listen(((p0) async {
      if (p0 != null) {
        getCells();
        getAllCells();
        getMessages();
        getChats(cellCollection.id);

        final now = DateTime.now();
        if (FirebaseAuth.instance.currentUser != null) {
          final newUser = await _authController
              .getUserByModel(FirebaseAuth.instance.currentUser!.uid);
          liveUser(newUser);

          if (newUser.lastLoginTime!.difference(now).inDays >= 1 &&
              newUser.weeklyLoginTime!.difference(now).inDays >= 1) {
            _newCell.doc(cellCollection.id).update({
              "members": memberAdd(cellCollection.id),
            });
            _userDoc.doc(userCollection.id).update({
              "cellsJoined": memberCellAdd(userCollection.id),
            });
            _newMessage.doc(messagesCollection.id).update({
              "like": likePost(cellCollection.id, messagesCollection.id),
              "comment": comment(cellCollection.id, messagesCollection.id),
            });

            final newUser = await _authController
                .getUserByModel(FirebaseAuth.instance.currentUser!.uid);
            liveUser(newUser);
            if (kDebugMode) {
              print("user value gotten user ${liveUser.value.toJson()}");
            }
          }
        }
      }
    }));
  }

  Future memberAdd(String groupId) async {
    if (kDebugMode) {
      print("member id is $groupId");
    }
    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.update(_cellDoc.doc(groupId), {
        "members":
            FieldValue.arrayUnion([_authController.liveUser.value!.uid!]),
      });
    });
  }

  Future memberRemove(String groupId) async {
    if (kDebugMode) {
      print("member id is $groupId");
    }
    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.update(_cellDoc.doc(groupId), {
        "members":
            FieldValue.arrayRemove([_authController.liveUser.value!.uid!]),
      });
    });
  }

  Future memberCellAdd(String groupId) async {
    if (kDebugMode) {
      print("group id to add is $groupId");
    }
    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.update(_userDoc.doc(_authController.liveUser.value!.uid), {
        "cellsJoined": FieldValue.arrayUnion([groupId]),
      });
    });
  }

  Future memberCellRemove(String groupId) async {
    if (kDebugMode) {
      print("group id to remove is $groupId");
    }
    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.update(_userDoc.doc(groupId), {
        "cellsJoined": FieldValue.arrayRemove([groupId]),
      });
    });
  }

  Future likePost(String cellId, String messageId) async {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction
          .update(_newCell.doc(cellId).collection('messages').doc(messageId), {
        "like": FieldValue.arrayUnion([_authController.liveUser.value!.uid!])
      });
    });
  }

  Future unLikePost(String cellId, String messageId) async {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction
          .update(_newCell.doc(cellId).collection('messages').doc(messageId), {
        "like": FieldValue.arrayRemove([_authController.liveUser.value!.uid!])
      });
    });
  }

  Future comment(String cellId, String messageId) async {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction
          .update(_newCell.doc(cellId).collection("messages").doc(messageId), {
        "comment": FieldValue.arrayUnion([_authController.liveUser.value!.uid!])
      });
    });
  }

  Future getMessages() async {
    _cellStatus(CellStatus.LOADING);
    try {
      messagesCollection.orderBy("createdAt").snapshots().listen((event) {
        List<MessageModel> list = [];
        for (var element in event.docs) {
          final quote = MessageModel.fromJson(element.data()!, element.id);
          list.add(quote);
          if (kDebugMode) {
            print('ID is: ${element.id}');
            print('message is:${quote.toJson()}');
          }
          _cellStatus(CellStatus.SUCCESS);
        }
        _messageList(list);
      });
    } catch (ex) {
      //
    }
  }

  getChats(String groupId) async {
    return cellCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  Future getGroupAdmin(String groupId) async {
    DocumentReference d = cellCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }

  // Stream getGroupMembers(String groupId) {
  //   final members = cellCollection.doc(groupId).snapshots();
  //   if (kDebugMode) {
  //     print('This is members list $members');
  //   }
  //   return members;
  // }

  //all cells
  Stream<List<CellModel>> getCells() => FirebaseFirestore.instance
      .collection('cells')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => CellModel.fromJson(doc.data(), doc.id))
          .toList());

  // creating a group
  Future createCell({
    required String email,
    required String admin,
    required String groupId,
    required String description,
    required String groupName,
    required String groupIcon,
    required List<String> tags,
  }) async {
    try {
      final cellDocs = FirebaseFirestore.instance.collection("cells");

      final cell = CellModel(
        groupId: groupId,
        groupIcon: groupIcon,
        groupName: groupName,
        description: description,
        email: email,
        members: [],
        tags: tags,
        admin: admin,
        recentMessage: '',
        cellQuote: '',
        recentMessageSender: '',
        createdAt: DateTime.now(),
      );

      if (kDebugMode) {
        print(" The group name: $groupName");
      }
      final json = cell.toJson();

      await cellDocs.add(json);

      await groupDocumentReference!.update({
        "members": FieldValue.arrayUnion(["${uid!}_$email"]),
        "groupId": groupDocumentReference!.id,
      });

      DocumentReference userDocumentReference = userCollection.doc(uid!.uid);
      return await userDocumentReference.update({
        "groups":
            FieldValue.arrayUnion(["${groupDocumentReference!.id}_$groupName"])
      });
    } catch (ex) {
      //
    }
  }

  // Function -> bool
  Future<bool> isUserJoined(
    String groupName,
    String groupId,
    String userName,
  ) async {
    DocumentReference userDocumentReference = userCollection.doc(uid!.uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> groups = await documentSnapshot['groups'];
    if (groups.contains("${groupId}_$groupName")) {
      return true;
    } else {
      return false;
    }
  }

  joinedOrNot(
    String userName,
    String groupId,
    String groupname,
  ) async {
    await DatabaseService(uid: _authController.liveUser.value!.uid)
        .isUserJoined(groupname, groupId, userName)
        .then((value) {
      update();
    });
  }

  gettingUserData() async {
    await HelperFunction.getUserEmailFromSF().then((value) {});
    // getting the list of snapshots in our stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {});
  }

  Future getAllCells() async {
    _cellStatus(CellStatus.LOADING);
    try {
      cellCollection.orderBy("createdAt").snapshots().listen((event) {
        List<CellModel> list = [];
        for (var element in event.docs) {
          final cells = CellModel.fromJson(element.data()!, element.id);
          list.add(cells);
          if (kDebugMode) {
            print('CELL ID is: ${element.id}');
            print('cell is:${cells.toJson()}');
          }
          gettingUserData();
          _cellStatus(CellStatus.SUCCESS);
        }
        _availableCell(list);
      });
    } catch (ex) {
      //
    }
  }

  // Create Quotes
  Future createCellQuote({
    required String cellId,
    required String cellQuote,
  }) async {
    // _quoteStatus(QuoteStatus.LOADING);
    try {
      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.update(_cellDoc.doc(cellId), {
          "cellQuote": cellQuote,
        });
      });

      await sendHttpNotification(
          title: 'Agora Care', body: 'Todays Quote Has Been Posted');

      await sendFirebaseNotification(
        avatar:
            "https://images.unsplash.com/photo-1593642532842-98d0fd5ebc1a?ixid=MXwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=2250&q=80",
        message: 'Todays Quote has been posted',
        id: cellCollection.id,
        userId: _authController.liveUser.value!.uid!,
      );
    } catch (ex) {
      //
    }
  }
}
