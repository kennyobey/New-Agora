// ignore_for_file: unnecessary_null_comparison, unused_field

import 'package:agora_care/app/authentication/login_page.dart';
import 'package:agora_care/app/model/cells_model.dart';
import 'package:agora_care/services/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../app/home/nav_screen.dart';
import '../helper/helper_function.dart';

class CellControllers extends GetxController {
  final _authController = Get.find<AuthControllers>();
  final bool isLoading = false;

  // DateTime? lastUpdated;
  // HelperFunction? sharePref;

  // Rx<String> streak = Rx("");
  // String get getStreak => streak.value;
  // FirebaseDatabase refDatabase = FirebaseDatabase.instance;

  Rx<CellModel> availableCell = CellModel().obs;
  CellModel get allCell => availableCell.value;

  FirebaseAuth auth = FirebaseAuth.instance;
  final _cellsDoc = FirebaseFirestore.instance.collection("groups");

  @override
  void onInit() async {
    super.onInit();
    final now = DateTime.now();
    if (FirebaseAuth.instance.currentUser != null) {
      final newUser =
          await getCellsByModel(FirebaseAuth.instance.currentUser!.uid);
      availableCell(newUser);

      if (newUser.recentMessageTime!.difference(now).inDays >= 1 &&
          newUser.weeklyLoginTime!.difference(now).inDays >= 1) {
        _cellsDoc.doc(FirebaseAuth.instance.currentUser!.uid).update({
          "weeks": FieldValue.increment(1),
          "streak": FieldValue.increment(1),
          "recentMessageTime": DateTime.now().toIso8601String(),
          "weeklyLoginTime": DateTime.now().toIso8601String(),
        });
        final newUser =
            await getCellsByModel(FirebaseAuth.instance.currentUser!.uid);
        availableCell(newUser);
        if (kDebugMode) {
          print("user value gotten user ${availableCell.value.toJson()}");
        }
      }
    }
  }

  //all cells
  Stream<List<CellModel>> getCells() => FirebaseFirestore.instance
      .collection('groups')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => CellModel.fromJson(doc.data())).toList());

  // login
  Future loginWithUserNameandPassword(String email, String password) async {
    try {
      User user = (await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user!;
      DateTime now = DateTime.now();
      if (user == null) {
        return;
      }
      final cellsModel = await getCellsByModel(user.uid);
      if (cellsModel.recentMessageTime == null ||
          cellsModel.weeklyLoginTime == null) {
        cellsModel.updatedAt = now;
        cellsModel.recentMessageTime = now;
        cellsModel.weeklyLoginTime = now;

        _cellsDoc.doc(user.uid).update({
          "weeks": FieldValue.increment(1),
          "streak": FieldValue.increment(1),
          "weeklyLoginTime": DateTime.now().toIso8601String(),
          "recentMessageTime": DateTime.now().toIso8601String(),
        });
        final newUser = await getCellsByModel(user.uid);
        availableCell(newUser);
      } else {
        if (cellsModel.recentMessageTime!.difference(now).inDays >= 1 &&
            cellsModel.weeklyLoginTime!.difference(now).inDays >= 1) {
          _cellsDoc.doc(user.uid).update({
            "weeks": FieldValue.increment(1),
            "streak": FieldValue.increment(1),
            "weeklyLoginTime": DateTime.now().toIso8601String(),
            "recentMessageTime": DateTime.now().toIso8601String(),
          });
          final newUser = await getCellsByModel(user.uid);
          availableCell(newUser);
          if (kDebugMode) {
            print("user value gotten user ${availableCell.value.toJson()}");
          }
        }
      }
      Get.to(() => UserNavScreen());
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //Update Profile
  Future cellsChanges(String username, String fullName, String gender,
      String address, String postalCode, String profilePic) async {
    try {
      if (kDebugMode) {
        print("user detail update profile ${availableCell.value.toJson()}");
      }
      if (availableCell.value.groupId != null) {
        if (kDebugMode) {
          print('I reach here');
        }

        if (kDebugMode) {
          print('USER ID is: ${allCell.groupId}');
        }
        _cellsDoc.doc(allCell.groupId).update({
          'username': username,
          'fullName': fullName,
          'gender': gender,
          'address': address,
          'postalCode': postalCode,
          'profilePic': profilePic,
        });
        final newUser = await getCellsByModel(allCell.groupId!);
        availableCell(newUser);
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Sign Out
  Future signOut() async {
    try {
      await HelperFunction.saveUserLoggedInStatus(false);
      await HelperFunction.saveUserEmailSF("");
      await auth.signOut();
      Get.offAll(() => const LoginPage());
    } catch (e) {
      return null;
    }
  }

  // Get Cells Data by Id
  Future<CellModel> getCellsByModel(String id) async {
    final result = await _cellsDoc.doc(id).get();
    final cells = CellModel.fromJson(result.data()!);

    return cells;
  }
}
