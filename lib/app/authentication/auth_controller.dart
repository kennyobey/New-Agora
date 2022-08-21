import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'email_page.dart';
import 'welcome_page.dart';

class AuthContoller extends GetxController {
  // Authconroller.instance
  static AuthContoller instance = Get.find();

  //email password name....
  late Rx<User?> _user;

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(auth.currentUser);
    // our user would be notified
    _user.bindStream(auth.userChanges());
    ever(_user, _initialScreen);
  }

  _initialScreen(User? user) {
    if (user == null) {
      print('login page');
      Get.offAll(() => const EmailPage());
    } else {
      Get.offAll(() => WelComePage(
          // email: user.email ?? "User email",
          // name: user.displayName ?? "User name",
          ));
    }
  }

  void register(
    String email,
    String password,
  ) async {
    print("sign up");
    try {
      final userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      print(userCredential);
    } on FirebaseAuthException catch (e) {
      print(e.runtimeType);
      print(e);
      if (e.code == "weak-password") {
        Get.snackbar("About", "weak password",
            backgroundColor: Colors.redAccent,
            snackPosition: SnackPosition.BOTTOM,
            titleText: const Text(
              "weak password",
              style: TextStyle(color: Colors.white),
            ),
            messageText: Text(
              e.toString(),
              style: const TextStyle(color: Colors.white),
            ));
      }
      ;
      Get.snackbar("About", "User Message",
          backgroundColor: Colors.redAccent,
          snackPosition: SnackPosition.BOTTOM,
          titleText: const Text(
            "Account creation failed",
            style: TextStyle(color: Colors.white),
          ),
          messageText: Text(
            e.toString(),
            style: const TextStyle(color: Colors.white),
          ));
    }
  }

  void login(String email, String password) async {
    print("login");
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      Get.snackbar("About Login", "Login Message",
          backgroundColor: Colors.redAccent,
          snackPosition: SnackPosition.BOTTOM,
          titleText: const Text(
            "Login failed",
            style: TextStyle(color: Colors.white),
          ),
          messageText: Text(
            e.toString(),
            style: const TextStyle(color: Colors.white),
          ));
    }
  }

  void logOut() async {
    await auth.signOut();
  }
}
