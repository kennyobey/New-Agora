// ignore_for_file: unnecessary_null_comparison, unused_field

import 'package:agora_care/app/model/cells_model.dart';
import 'package:agora_care/app/model/user_model.dart';
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

  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");
  final CollectionReference cellCollection =
      FirebaseFirestore.instance.collection("cells");
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  Rx<UserModel> liveUser = UserModel().obs;
  UserModel get users => liveUser.value;

  final Rx<List<CellModel>> _availableCell = Rx([]);
  List<CellModel> get allAvailableCell => _availableCell.value;

  FirebaseAuth auth = FirebaseAuth.instance;
  final _newCell = FirebaseFirestore.instance.collection("cells");
  final _cellsDoc = FirebaseFirestore.instance.collection("groups");

  @override
  void onInit() async {
    super.onInit();
    getCells();
    getAllCells();
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

        final newUser = await _authController
            .getUserByModel(FirebaseAuth.instance.currentUser!.uid);
        liveUser(newUser);
        if (kDebugMode) {
          print("user value gotten user ${liveUser.value.toJson()}");
        }
      }
    }
  }

  Future memberAdd(String memberId) async {
    if (kDebugMode) {
      print("member id is $memberId");
    }
    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.update(
        _cellsDoc.doc(memberId),
        {
          "members":
              FieldValue.arrayUnion([_authController.liveUser.value!.uid!]),
        },
      );
    });
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

  //all cells
  Stream<List<CellModel>> getCells() => FirebaseFirestore.instance
      .collection('cells')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => CellModel.fromJson(doc.data(), doc.id))
          .toList());

  // creating a group
  Future createGroup({
    required String email,
    required String admin,
    required String groupId,
    required String description,
    required String groupName,
    required String groupIcon,
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
        admin: admin,
        recentMessage: '',
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

  // function -> bool
  Future<bool> isUserJoined(
      String groupName, String groupId, String userName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid!.uid);
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
    DocumentReference userDocumentReference = userCollection.doc(uid!.uid);
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);

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

  // Stream<QuerySnapshot<Object?>> getAllCells() {
  //   final quotes = groupCollection.orderBy("createdAt").snapshots();
  //   return quotes;
  // }

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
            print('cell is:${cells.toJson()} ID is:');
          }
          _cellStatus(CellStatus.SUCCESS);
        }
        _availableCell(list);
      });
    } catch (ex) {
      //
    }
  }
}
