import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction {
  //keys
  static String userLoggedInkey = "";
  static String userNamekey = "";
  static String userEmailkey = "";

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

  // static Future<String?> getUserNameFromSF() async {
  //   SharedPreferences sf = await SharedPreferences.getInstance();
  //   return sf.getString(userNameKey);
  // }

  static Future<bool?> getUserLogggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInkey);
  }
}
