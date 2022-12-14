// ignore_for_file: unnecessary_null_comparison, unused_field, prefer_function_declarations_over_variables, unused_local_variable, avoid_function_literals_in_foreach_calls

import 'dart:io';

import 'package:agora_care/app/authentication/%20verify_email_page.dart';
import 'package:agora_care/app/authentication/login_page.dart';
import 'package:agora_care/app/authentication/welcome_page.dart';
import 'package:agora_care/app/home/navigation_bars/admin_nav_screen.dart';
import 'package:agora_care/app/home/navigation_bars/consultant_nav_screen.dart';
import 'package:agora_care/app/model/user_list_model.dart';
import 'package:agora_care/app/model/user_model.dart';
import 'package:agora_care/core/constants.dart';
import 'package:agora_care/helper/helper_function.dart';
import 'package:agora_care/helper/sharedpreference.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../app/home/navigation_bars/nav_screen.dart';
import 'database_service.dart';

class AuthControllers extends GetxController {
  static AuthControllers to = Get.find();
  final bool isLoading = false;
  bool isEmailVerified = false;
  SharePref? pref;

  final signupPhonenumberController = TextEditingController();

  RxString phone = ''.obs;
  RxString countryCode = '+1'.obs;
  final RxString _verificationId = ''.obs;
  Rx<File?> image = Rx(null);

  final CollectionReference quotesCollection =
      FirebaseFirestore.instance.collection("quotes");
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  Rx<UserModel?> liveUser = Rx(null);
  UserModel? get users => liveUser.value;

  UserModel? user;

  FirebaseAuth auth = FirebaseAuth.instance;
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final _userDoc = FirebaseFirestore.instance.collection("users");

  final _newQuote = FirebaseFirestore.instance.collection("quotes");

  @override
  void onInit() async {
    super.onInit();
    // FirebaseAuth.instance.signOut();
    final now = DateTime.now();
    pref = SharePref();
    await pref!.inits();
    if (pref!.getFirstTimeButtonOpen()) {
      if (kDebugMode) {
        print("My First Time Using this app");
      }
    } else {
      if (kDebugMode) {
        print("Not my First Time Using this app");
      }
      if (pref!.getUser() != null) {
        user = pref!.getUser();
        liveUser(user);
      }
    }

    if (FirebaseAuth.instance.currentUser != null) {
      final newUser =
          await getUserByModel(FirebaseAuth.instance.currentUser!.uid);
      if (kDebugMode) {
        print("new user value is ${newUser.toJson()}");
      }
      liveUser(newUser);

      if (newUser.lastLoginTime!.difference(now).inDays >= 1 &&
          newUser.weeklyLoginTime!.difference(now).inDays >= 7) {
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
          print("user value gotten user ${liveUser.value!.toJson()}");
        }
      }
    }
  }

  void setFirstTimeButtonOpen(bool value) {
    pref!.setFirstTimeButtonOpen(value);
  }

  //
  Future<void> updateDataFirestore(
      String path, Map<String, String> dataNeedUpdate) async {
    return _userDoc.doc(path).update(dataNeedUpdate);
  }

  //Register
  Future registerUserWithEmailandPassword(String email, String password) async {
    try {
      User user = (await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user!;

      if (user != null) {
        // call our database service to update the user data.
        await DatabaseService(uid: user.uid).savingUserData(email);
        return true;
      }

      DateTime now = DateTime.now();
      final userModel = await getUserByModel(user.uid);
      if (userModel.lastLoginTime == null ||
          userModel.weeklyLoginTime == null) {
        userModel.updatedAt = now;
        userModel.lastLoginTime = now;
        userModel.weeklyLoginTime = now;

        _userDoc.doc(user.uid).update({
          "admin": false,
          "role": "user",
          "weeks": FieldValue.increment(1),
          "streak": FieldValue.increment(1),
          "weeklyLoginTime": DateTime.now().toIso8601String(),
          "lastLoginTime": DateTime.now().toIso8601String(),
        });
        final newUser = await getUserByModel(user.uid);
        liveUser(newUser);
      } else {
        if (userModel.lastLoginTime!.difference(now).inDays >= 1 &&
            userModel.weeklyLoginTime!.difference(now).inDays >= 7) {
          _userDoc.doc(user.uid).update({
            "admin": false,
            "role": "user",
            "weeks": FieldValue.increment(1),
            "streak": FieldValue.increment(1),
            "weeklyLoginTime": DateTime.now().toIso8601String(),
            "lastLoginTime": DateTime.now().toIso8601String(),
          });
          final newUser = await getUserByModel(user.uid);
          liveUser(newUser);
          if (kDebugMode) {
            print("user value gotten user ${liveUser.value!.toJson()}");
          }
        }
      }
      if (user.emailVerified == isEmailVerified) {
        Get.to(() => const WelComePage());
      } else {
        Get.to(() => const VerifyEmailLinkPage());
      }
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e);
      }
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
        Get.snackbar("Error", "Invalid Login details");
        return;
      }

      final userModel = await getUserByModel(user.uid);
      if (kDebugMode) {
        print("user json is ${userModel.toJson()}");
      }
      liveUser(userModel);

      if (user.emailVerified == !isEmailVerified) {
        if (userModel.admin == true) {
          Get.offAll(() => AdminNavScreen());
        } else if (userModel.role == 'consultant') {
          Get.offAll(() => ConsultantNavScreen());
        } else {
          Get.offAll(() => UserNavScreen());
        }
      } else {
        Get.offAll(() => const VerifyEmailLinkPage());
      }
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
            userModel.weeklyLoginTime!.difference(now).inDays >= 7) {
          _userDoc.doc(user.uid).update({
            "weeks": FieldValue.increment(1),
            "streak": FieldValue.increment(1),
            "weeklyLoginTime": DateTime.now().toIso8601String(),
            "lastLoginTime": DateTime.now().toIso8601String(),
          });
          final newUser = await getUserByModel(user.uid);
          liveUser(newUser);
          if (kDebugMode) {
            print("user value gotten user ${liveUser.value!.toJson()}");
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return Get.snackbar('Alert', e.message!);
    }
  }

  //send email verification
  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e.message;
    }
  }

  // Send Verification Code
  Future<void> sendVerificationCodes(String? phoneNum) async {
    // phone(countryCode.value + phoneNum!);
    // phone(phoneNum!);
    if (kDebugMode) {
      print("PHONE IS $phoneNum");
    }
    final void Function(String verId, int? forceCodeResend) smsOTPSent =
        (String verId, int? forceCodeResend) {
      if (kDebugMode) {
        print("verification id $verId");
      }
      _verificationId(verId);
      EasyLoading.dismiss();
      Get.to(
        () => VerifyEmailPage(
          passedPhone: phoneNum!,
        ),
      );
    };

    await auth.verifyPhoneNumber(
      phoneNumber: phoneNum,
      codeAutoRetrievalTimeout: (String verId) {
        _verificationId(verId);
      },
      codeSent: smsOTPSent,
      timeout: const Duration(
        seconds: 120,
      ),
      verificationCompleted: (AuthCredential phoneAuthCredential) {
        Get.to(() => const WelComePage());
      },
      verificationFailed: (FirebaseAuthException exception) {
        kErrorSnakBar(exception.message!);
        if (kDebugMode) {
          print("message is phone error ${exception.message}");
        }
      },
    );
  }

  //Update Profile
  Future userChanges(
    String username,
    String fullName,
    String phoneNumber,
    String address,
    String postalCode,
    String profilePic,
    String nextOfKin,
    String nexKinPhone,
  ) async {
    try {
      if (kDebugMode) {
        print(
            "user detail update profile ${FirebaseAuth.instance.currentUser!.uid} ");
      }
      final userDocQuote =
          FirebaseFirestore.instance.collection("quotes").doc("dailyQuotes");
      if (FirebaseAuth.instance.currentUser == null) {
        if (kDebugMode) {
          print('I reach here');
          return;
        }
      }
      final up = {
        'username': username,
        'fullName': fullName,
        'phoneNumber': phoneNumber,
        'address': address,
        'postalCode': postalCode,
        'profilePic': profilePic,
        'dailyQuote': userDocQuote,
        'nextOfKin': nextOfKin,
        'nexKinPhone': nexKinPhone,
        'cellsJoined': [],
      };
      if (kDebugMode) {
        print("value of changes is $up");
      }
      await _userDoc.doc(FirebaseAuth.instance.currentUser!.uid).update(up);

      final newUser =
          await getUserByModel(FirebaseAuth.instance.currentUser!.uid);
      liveUser(newUser);
      if (kDebugMode) {
        print("new user update is ${newUser.toJson()}");
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future welcomeUserChanges(
    String username,
    String fullName,
    String phoneNumber,
    String address,
    String postalCode,
    String profilePic,
    String nextOfKin,
    String nexKinPhone,
    String role,
    bool admin,
  ) async {
    try {
      if (kDebugMode) {
        print(
            "user detail update profile ${FirebaseAuth.instance.currentUser!.uid} ");
      }
      final userDocQuote =
          FirebaseFirestore.instance.collection("quotes").doc("dailyQuotes");
      if (FirebaseAuth.instance.currentUser == null) {
        if (kDebugMode) {
          print('I reach here');
          return;
        }
      }
      final up = {
        'username': username,
        'fullName': fullName,
        'phoneNumber': phoneNumber,
        'address': address,
        'role': role,
        'admin': admin,
        'postalCode': postalCode,
        'profilePic': profilePic,
        'dailyQuote': userDocQuote,
        'nextOfKin': nextOfKin,
        'nexKinPhone': nexKinPhone,
        'cellsJoined': [],
      };
      if (kDebugMode) {
        print("value of changes is $up");
      }
      await _userDoc.doc(FirebaseAuth.instance.currentUser!.uid).update(up);

      final newUser =
          await getUserByModel(FirebaseAuth.instance.currentUser!.uid);
      liveUser(newUser);
      if (kDebugMode) {
        print("new user update is ${newUser.toJson()}");
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future changeConsultant(
    String uid,
    String role,
  ) async {
    try {
      if (kDebugMode) {
        print("consultant data $uid ");
      }
      final patchData = {
        'uid': uid,
        'role': role,
      };
      if (kDebugMode) {
        print("value of changes is $patchData");
      }
      await _userDoc.doc(uid).update(patchData);
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> verifyMobileOTP(String otp, BuildContext context) async {
    try {
      if (kDebugMode) {
        print("get veri id is ${_verificationId.value} ");
      }
      EasyLoading.show(status: 'Verifying');
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId.value,
        smsCode: otp,
      );
      Get.to(() => const WelComePage());
    } catch (e) {
      kErrorSnakBar('$e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  //Verify Phone Number
  Future<void> verifyPhoneNumber(
      String phoneNumber, BuildContext context, Function setData) async {
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      showSnackBar(context, "Verification Completed");
    };
    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException exception) {
      showSnackBar(context, exception.toString());
    };
    PhoneCodeSent codeSent =
        (String verificationID, [int? forceResnedingtoken]) {
      showSnackBar(context, "Verification Code sent on the phone number");
      setData(verificationID);
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationID) {
      showSnackBar(context, "Time out");
    };
    try {
      await auth.verifyPhoneNumber(
          timeout: const Duration(seconds: 60),
          phoneNumber: phoneNumber,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // Snackbar
  void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Upload File
  Future<String?> uploadFile(File file) async {
    try {
      String name =
          "${DateTime.now().microsecondsSinceEpoch}.${file.path.split('.').last}";
      // Reference ref = FirebaseStorage.instance.ref().child(name);
      firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instance.ref('images/').child(name);

      firebase_storage.UploadTask task = ref.putFile(file);
      await task.whenComplete(() => null);
      return await ref.getDownloadURL();
    } catch (error) {
      // kErrorSnakBar(error);
    }
    return null;
  }

  // Update Avatar
  Future updateAvatar(File file) async {
    try {
      EasyLoading.show(status: 'uploading');
      String? image = await uploadFile(file);
      await userDb.doc(liveUser.value!.uid).update({'profilePic': image});
    } catch (e) {
      kErrorSnakBar('$e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  // Uploding User Avatar
  Future uploadImageFiles(
    String filePath,
    String fileName,
  ) async {
    File file = File(filePath);
    try {
      EasyLoading.show(status: 'uploading');
      await storage.ref('images/$fileName').putFile(file);
      await userDb.doc(liveUser.value!.uid).update({'profilePic': image});
    } catch (e) {
      kErrorSnakBar('$e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  // Getting User Avatar
  Future<void> listImageFiles() async {
    firebase_storage.ListResult result = await storage.ref('images').listAll();
    return result.items.forEach((firebase_storage.Reference ref) {
      debugPrint("Find file: $ref");
    });
  }

  // Getting Avatar Url
  Future<String> downloadUrl(String imageName) async {
    String downloadUrl =
        await storage.ref('images/$imageName').getDownloadURL();
    return downloadUrl;
  }

  // Get Users Data by Id
  Future<UserModel> getUserByModel(String id) async {
    // print(object)
    final result = await _userDoc.doc(id).get();
    if (kDebugMode) {
      print("user json ${result.data()}");
    }
    final user = UserModel.fromJson(result.data()!);

    return user;
  }

  Future<List<UserModel>> getUserByModelList(List<String> ids) async {
    List<UserModel> list = [];
    await Future.forEach<String>(ids, (element) async {
      final result = await _userDoc.doc(element).get();
      final user = UserModel.fromJson(result.data()!);
      if (kDebugMode) {
        print("member detail is ${user.toJson()}");
        print("member fullname is ${user.fullName}");
      }
      list.add(user);
    });

    return list;
  }

  // Get Users List
  Stream<List<UserList>> readUserList() => FirebaseFirestore.instance
      .collection('users')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => UserList.fromJson(doc.data())).toList());

  // Sign Out
  Future signOut() async {
    try {
      liveUser(null);
      await HelperFunction.saveUserLoggedInStatus(false);
      await HelperFunction.saveUserEmailSF("");
      await auth.signOut();
      pref!.logout();
      Get.offAll(() => const LoginPage());
    } catch (e) {
      return null;
    }
  }

  //Delete User Account
  Future deleteUserAccount(String userId) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      liveUser(null);
      await HelperFunction.saveUserLoggedInStatus(false);
      await HelperFunction.saveUserEmailSF("");
      await auth.signOut();
      await user?.delete();
      pref!.logout();
      final users = _userDoc.doc(userId).delete();
      // .then(
      //       (value) => Get.offAll(() => const LoginPage()),
      //     );
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e.message;
    }
  }

  String? getUserFirebaseId() {
    return getUserByModel(FirebaseAuth.instance.currentUser!.uid).toString();
  }

  Stream<List<UserList>> getStreamFireStore(
      int limit, String? textSearch, String? role) {
    if (textSearch?.isNotEmpty == true) {
      return _userDoc
          .limit(limit)
          .where("role", isEqualTo: role)
          .where(liveUser.value!.username!, isEqualTo: textSearch)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => UserList.fromJson(doc.data()))
              .toList());
    } else {
      if (kDebugMode) {
        print("USER-ROLE IS $role");
      }
      return _userDoc
          .limit(limit)
          .where("role", isEqualTo: role)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => UserList.fromJson(doc.data()))
              .toList());
    }
  }
}
