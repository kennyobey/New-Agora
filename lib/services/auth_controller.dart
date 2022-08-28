// ignore_for_file: unnecessary_null_comparison

import 'package:agora_care/app/authentication/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../app/home/nav_screen.dart';
import '../helper/helper_function.dart';
import 'database_service.dart';

class AuthController extends GetxController {
  // Authconroller.instance
  static AuthController instance = Get.find();

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
      if (kDebugMode) {
        print('login page');
      }
      Get.offAll(() => const LoginPage());
    } else {
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
              email: email, password: password))
          .user!;

      if (user != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // void login(String email, String password) async {
  //   if (kDebugMode) {
  //     print("login");
  //   }
  //   try {
  //     await auth.signInWithEmailAndPassword(email: email, password: password);
  //   } catch (e) {
  //     Get.snackbar("About Login", "Login Message",
  //         backgroundColor: Colors.redAccent,
  //         snackPosition: SnackPosition.BOTTOM,
  //         titleText: const Text(
  //           "Login failed",
  //           style: TextStyle(color: Colors.white),
  //         ),
  //         messageText: Text(
  //           e.toString(),
  //           style: const TextStyle(color: Colors.white),
  //         ));
  //   }
  // }

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

  // void logOut() async {
  //   await auth.signOut();
  // }
}
