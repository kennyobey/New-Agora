import 'package:agora_care/app/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction {
  //keys
  static String userLoggedInkey = "";
  static String userNamekey = "";
  static String userEmailkey = "";

  final _userDoc = FirebaseFirestore.instance.collection("users");

  // saving the data to SF

  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userLoggedInkey, isUserLoggedIn);
  }

  // static Future<bool> saveUserNameSF(String userName) async {
  //   SharedPreferences sf = await SharedPreferences.getInstance();
  //   return await sf.setString(userNameKey, userName);
  // }

  static Future<bool> saveUserEmailSF(String userEmail) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userEmailkey, userEmail);
  }

  // getting the data from SF

  static Future<String?> getUserEmailFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userEmailkey);
  }

  Future<UserModel?> getUser(String uid) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    var users = sf.getString(uid);
    if (kDebugMode) {
      print("users value $users");
    }
    if (users != null && users.isNotEmpty) {
      final json = await _userDoc.doc(uid).get();

      UserModel usersvalue = UserModel.fromJson(json.data()!);
      return usersvalue;
    } else {
      return null;
    }
  }

  // static Future<String?> getUserNameFromSF() async {
  //   SharedPreferences sf = await SharedPreferences.getInstance();
  //   return sf.getString(userNameKey);
  // }

  static Future<bool?> getUserLogggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInkey);
  }
}
