// ignore_for_file: unnecessary_null_comparison, unused_field

import 'package:agora_care/app/authentication/login_page.dart';
import 'package:agora_care/app/model/user_list_model.dart';
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

  final CollectionReference quotesCollection =
      FirebaseFirestore.instance.collection("quotes");

  Rx<UserModel> liveUser = UserModel().obs;
  UserModel get users => liveUser.value;

  FirebaseAuth auth = FirebaseAuth.instance;
  final _userDoc = FirebaseFirestore.instance.collection("users");

  final _newQuote = FirebaseFirestore.instance.collection("quotes");

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
        // _userDocQuote
        //     .collection('dailyQuote')
        //     .doc(FirebaseAuth.instance.currentUser!.uid)
        //     .update({
        //   "weeks": FieldValue.increment(1),
        //   "streak": FieldValue.increment(1),
        //   "lastLoginTime": DateTime.now().toIso8601String(),
        //   "weeklyLoginTime": DateTime.now().toIso8601String(),
        // });

        final newUser =
            await getUserByModel(FirebaseAuth.instance.currentUser!.uid);
        liveUser(newUser);
        if (kDebugMode) {
          print("user value gotten user ${liveUser.value.toJson()}");
        }
      }
    }
  }

  //Register
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

  // Login
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
      Get.to(() => UserNavScreen());
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //Fetch  Stream dailyQuote
  Stream getDailyQuote() {
    // final quotes = FirebaseFirestore.instance
    //     .collection('quotes')
    //     .snapshots()
    //     .map((snapshot) => snapshot.docs.map((doc) => doc.data()));
    final quotes = quotesCollection.doc('dailyQuotes').snapshots();

    return quotes;
  }

  //Fetch Once dailyQuote
  Future getQuote() async {
    final result = await quotesCollection.doc("dailyQuotes").get();
    if (kDebugMode) {
      print("Result of quote is: ${result.data()}");
    }
    return result.data();
  }

  //Update Profile
  Future userChanges(String username, String fullName, String gender,
      String address, String postalCode, String profilePic) async {
    try {
      if (kDebugMode) {
        print("user detail update profile ${liveUser.value.toJson()}");
      }
      final userDocQuote =
          FirebaseFirestore.instance.collection("quotes").doc("dailyQuotes");
      if (liveUser.value.uid != null) {
        if (kDebugMode) {
          print('I reach here');
        }

        if (kDebugMode) {
          print('USER ID is: ${users.uid}');
        }
        userDocQuote.get().toString();
        _userDoc.doc(users.uid).update({
          'username': username,
          'fullName': fullName,
          'gender': gender,
          'address': address,
          'postalCode': postalCode,
          'profilePic': profilePic,
          'dailyQuote': userDocQuote,
        });

        final newUser = await getUserByModel(users.uid!);
        liveUser(newUser);
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Create Quotes
  Future creatQuote({required String dailyQuote}) async {
    final docUser =
        FirebaseFirestore.instance.collection("quotes").doc('dailyQuotes');

    // Saving to model
    // final user = UserModel(
    //   dailyQuote: dailyQuote,
    // );
    // final json = user.toJson();

    // Direct Saving
    final json = {
      "dailyQuotes": dailyQuote,
    };

    // Create reference and write data to Firebase
    await docUser.set(json);
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

  // Get Users Data by Id
  Future<UserModel> getUserByModel(String id) async {
    final result = await _userDoc.doc(id).get();
    final user = UserModel.fromJson(result.data()!);

    return user;
  }

  // Get Users Data by Id

  Stream<List<UserList>> readtUserList() => FirebaseFirestore.instance
      .collection('users')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => UserList.fromJson(doc.data())).toList());
}
