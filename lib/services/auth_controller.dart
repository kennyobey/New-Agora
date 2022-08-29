// ignore_for_file: unnecessary_null_comparison

import 'package:agora_care/app/authentication/login_page.dart';
import 'package:agora_care/app/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../app/home/nav_screen.dart';
import '../helper/helper_function.dart';
import 'database_service.dart';

class AuthController extends GetxController {
  // Authconroller.instance
  static AuthController instance = Get.find();
  DateTime? lastUpdated;
  HelperFunction? sharePref;

  Rx<String> streak = Rx("");
  String get getStreak => streak.value;
  //email password name....
  late Rx<User?> _user;

  Rx<UserModel> liveUser = UserModel().obs;
  UserModel get users => liveUser.value;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseDatabase refDatabase = FirebaseDatabase.instance;
  final _userDoc = FirebaseFirestore.instance.collection("users");

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(auth.currentUser);
    // our user would be notified
    _user.bindStream(auth.userChanges());
    ever(_user, _initialScreen);
  }

  _initialScreen(User? user) async {
    if (user == null) {
      if (kDebugMode) {
        print('login page');
      }
      Get.offAll(() => const LoginPage());
    } else {
      final userModel = await getUserByModel(user.uid);
      sharePref?.getUser(userModel.uid!);
      Get.offAll(() => const UserNavScreen(
          // email: user.email ?? "User email",
          // name: user.displayName ?? "User name",
          ));
    }
  }

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

  // void register(
  //   String email,
  //   String password,
  // ) async {
  //   if (kDebugMode) {
  //     print("sign up");
  //   }
  //   try {
  //     final userCredential = await auth.createUserWithEmailAndPassword(
  //         email: email, password: password);
  //     print(userCredential);
  //   } on FirebaseAuthException catch (e) {
  //     print(e.runtimeType);
  //     print(e);
  //     if (e.code == "weak-password") {
  //       Get.snackbar("About", "weak password",
  //           backgroundColor: Colors.redAccent,
  //           snackPosition: SnackPosition.BOTTOM,
  //           titleText: const Text(
  //             "weak password",
  //             style: TextStyle(color: Colors.white),
  //           ),
  //           messageText: Text(
  //             e.toString(),
  //             style: const TextStyle(color: Colors.white),
  //           ));
  //     }
  //     ;
  //     Get.snackbar("About", "User Message",
  //         backgroundColor: Colors.redAccent,
  //         snackPosition: SnackPosition.BOTTOM,
  //         titleText: const Text(
  //           "Account creation failed",
  //           style: TextStyle(color: Colors.white),
  //         ),
  //         messageText: Text(
  //           e.toString(),
  //           style: const TextStyle(color: Colors.white),
  //         ));
  //   }
  // }
  // login
  Future loginWithUserNameandPassword(String email, String password) async {
    try {
      User user = (await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user!;
      DateTime now = DateTime.now();
      if (user != null) {
        final userModel = await getUserByModel(user.uid);
        if (userModel.lastLoginTime == null) {
          userModel.lastLoginTime = now;
          userModel.updatedAt = now;
          _userDoc.doc(user.uid).update(userModel.toJson());
        } else {
          if (userModel.lastLoginTime!.difference(now).inDays >= 1) {
            userModel.lastLoginTime = now;
            userModel.updatedAt = now;
            _userDoc.doc(user.uid).update(userModel.toJson());
          }
        }
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future userChanges(String username, String fullName, String gender,
      String address, String postalCode, String profilePics) async {
    try {
      User users = (await auth.signInWithEmailAndPassword(
        email: username,
        password: fullName,
      ))
          .user!;
      // User? users;
      if (users != null) {
        if (kDebugMode) {
          print('I reach here');
        }
        final userModel = await getUserByModel(users.uid);
        if (kDebugMode) {
          print('USER ID is: ${users.uid}');
        }
        FirebaseDatabase.instance.ref().child('users').child(users.uid).update({
          'username': username,
          'fullName': fullName,
          'gender': gender,
          'address': address,
          'postalCode': postalCode,
          'profilePics': profilePics,
        });
        _userDoc.doc(users.uid).update(userModel.toJson());
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future signOut() async {
    try {
      await HelperFunction.saveUserLoggedInStatus(false);
      await HelperFunction.saveUserEmailSF("");
      //await HelperFunction.saveUserNameSF("");
      await auth.signOut();
    } catch (e) {
      return null;
    }
  }

  Future<UserModel> getUserByModel(String id) async {
    final result = await _userDoc.doc(id).get();
    final user = UserModel.fromJson(result.data()!);

    return user;
  }
}
