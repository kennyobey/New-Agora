// ignore_for_file: unnecessary_null_comparison, unused_field

import 'package:agora_care/app/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../app/home/nav_screen.dart';
import '../helper/helper_function.dart';
import 'database_service.dart';

class AuthControllers extends GetxController {
  final bool isLoading = false;

  // DateTime? lastUpdated;
  // HelperFunction? sharePref;

  // Rx<String> streak = Rx("");
  // String get getStreak => streak.value;
  // FirebaseDatabase refDatabase = FirebaseDatabase.instance;

  Rx<UserModel> liveUser = UserModel().obs;
  UserModel get users => liveUser.value;

  FirebaseAuth auth = FirebaseAuth.instance;
  final _userDoc = FirebaseFirestore.instance.collection("users");

  @override
  void onInit() async {
    super.onInit();
    final now = DateTime.now();
    if (FirebaseAuth.instance.currentUser != null) {
      final newUser =
          await getUserByModel(FirebaseAuth.instance.currentUser!.uid);
      liveUser(newUser);

      if (newUser.lastLoginTime!.difference(now).inDays >= 1 &&
          newUser.weeklyLoginTime!.difference(now).inDays >= 1) {
        _userDoc.doc(FirebaseAuth.instance.currentUser!.uid).update({
          "weeks": FieldValue.increment(1),
          "streak": FieldValue.increment(1),
          "lastLoginTime": DateTime.now().toIso8601String(),
          "weeklyLoginTime": DateTime.now().toIso8601String(),
        });
        final newUser =
            await getUserByModel(FirebaseAuth.instance.currentUser!.uid);
        liveUser(newUser);
        if (kDebugMode) {
          print("user value gotten user ${liveUser.value.toJson()}");
        }
      }
    }
  }

  // _initialScreen(User? user) async {
  //   if (user == null) {
  //     if (kDebugMode) {
  //       print('login page');
  //     }
  //     Get.offAll(() => const LoginPage());
  //   } else {
  //     final userModel = await getUserByModel(user.uid);
  //     sharePref?.getUser(userModel.uid!);
  //     Get.offAll(() => const UserNavScreen(
  //         // email: user.email ?? "User email",
  //         // name: user.displayName ?? "User name",
  //         ));
  //   }
  // }

  //register
  Future registerUserWithEmailandPassword(String email, String password) async {
    try {
      User user = (await auth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        // call our database service to update the user data.
        await DatabaseService(uid: user.uid).savingUserData(email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

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
      final userModel = await getUserByModel(user.uid);
      if (userModel.lastLoginTime == null ||
          userModel.weeklyLoginTime == null) {
        userModel.updatedAt = now;
        userModel.lastLoginTime = now;
        userModel.weeklyLoginTime = now;

        _userDoc.doc(user.uid).update({
          "weeks": FieldValue.increment(1),
          "streak": FieldValue.increment(1),
          "weeklyLoginTime": DateTime.now().toIso8601String(),
          "lastLoginTime": DateTime.now().toIso8601String(),
        });
        final newUser = await getUserByModel(user.uid);
        liveUser(newUser);
      } else {
        if (userModel.lastLoginTime!.difference(now).inDays >= 1 &&
            userModel.weeklyLoginTime!.difference(now).inDays >= 1) {
          _userDoc.doc(user.uid).update({
            "weeks": FieldValue.increment(1),
            "streak": FieldValue.increment(1),
            "weeklyLoginTime": DateTime.now().toIso8601String(),
            "lastLoginTime": DateTime.now().toIso8601String(),
          });
          final newUser = await getUserByModel(user.uid);
          liveUser(newUser);
          if (kDebugMode) {
            print("user value gotten user ${liveUser.value.toJson()}");
          }
        }
      }
      Get.to(() => const UserNavScreen());
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //Update Profile
  Future userChanges(String username, String fullName, String gender,
      String address, String postalCode, String profilePic) async {
    try {
      if (kDebugMode) {
        print("user detail update profile ${liveUser.value.toJson()}");
      }
      if (liveUser.value.uid != null) {
        if (kDebugMode) {
          print('I reach here');
        }

        if (kDebugMode) {
          print('USER ID is: ${users.uid}');
        }
        _userDoc.doc(users.uid).update({
          'username': username,
          'fullName': fullName,
          'gender': gender,
          'address': address,
          'postalCode': postalCode,
          'profilePic': profilePic,
        });
        final newUser = await getUserByModel(users.uid!);
        liveUser(newUser);
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
    } catch (e) {
      return null;
    }
  }

  // Get Users Data by Id
  Future<UserModel> getUserByModel(String id) async {
    final result = await _userDoc.doc(id).get();
    final user = UserModel.fromJson(result.data()!);

    return user;
  }
}
