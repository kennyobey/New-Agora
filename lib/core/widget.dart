import 'package:flutter/material.dart';

void nextScreen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenReplace(context, page) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => page));
}

void showSnackbar(context, color, message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message ?? 'Successfully logged in',
        style: const TextStyle(fontSize: 14),
      ),
      backgroundColor: color,
      duration: const Duration(seconds: 4),
      action: SnackBarAction(
        label: "OK",
        onPressed: () {
          // Get.close(1)
        },
        textColor: Colors.white,
      ),
    ),
  );
}

// void showSnackbar(context, color, message) {
//   Get.snackbar(
//     'Alert',
//     message ?? 'Successfully logged in',
//     colorText: AppColor().whiteColor,
//     // backgroundColor: AppColor().whiteColor,
//     duration: const Duration(seconds: 4),
//   );
// }
