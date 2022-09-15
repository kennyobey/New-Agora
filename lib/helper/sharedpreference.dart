// ignore_for_file: prefer_if_null_operators

import 'dart:convert';
import 'dart:core';

import 'package:agora_care/app/model/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharePref {
  static String isLogin = "App is Login";
  static String firstTimeAppOpen = "Have I pressed the button";
  static SharedPreferences? _preferences;
  SharePref() {
    init();
  }
  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  UserModel? getUser() {
    var user = _preferences!.getString(isLogin);
    if (kDebugMode) {
      print("user value $user");
    }
    if (user != null && user.isNotEmpty) {
      var json = jsonDecode(user);
      UserModel uservalue = UserModel.fromJson(json);
      return uservalue;
    } else {
      return null;
    }
  }

  Future inits() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // bool getFirstTimeOpen() {
  //   var value = _preferences!.getBool(firstTimeAppOpen);
  //   if (kDebugMode) {
  //     print("Am I a new User?  $value");
  //   }
  //   // return value ?? true;
  //   return value == null ? true : value;
  // }

  Future<void> setFirstTimeButtonOpen(bool value) async {
    _preferences!.setBool(firstTimeAppOpen, value);
    if (kDebugMode) {
      print("Trying to press the button?  $value");
    }
  }

  void logout() {
    _preferences!.setString(isLogin, "");
  }

  bool getFirstTimeButtonOpen() {
    var value = _preferences!.getBool(firstTimeAppOpen);
    if (kDebugMode) {
      print("Have I pressed The button?  $value");
    }
    return value ?? true;
  }
}
