// ignore_for_file: constant_identifier_names, avoid_function_literals_in_foreach_calls

import 'dart:convert';

import 'package:agora_care/core/constant/colors.dart';
import 'package:agora_care/services/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

OutlineInputBorder appInputOutlineBorder() => OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(
        color: AppColor().primaryColor,
        width: 3.0,
      ),
    );

// Collections

CollectionReference userDb = FirebaseFirestore.instance.collection('users');
CollectionReference notificationsDb =
    FirebaseFirestore.instance.collection('notifications');

final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

kErrorSnakBar(String error, {String? title}) {
  Get.snackbar(
    title ?? 'Error!',
    error,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.red,
  );
}

kSuccessSnakBar(String msg, {String? title}) {
  Get.snackbar(
    title ?? 'Success!',
    msg,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.green,
  );
}

// LatLng getLatLngFromGeoPoint(Map<String, dynamic> doc) {
//   return LatLng(
//     doc['geopoint'].latitude,
//     doc['geopoint'].longitude,
//   );
// }

// String getDistance(LatLng start, LatLng end) {
//   return (Geolocator.distanceBetween(
//               start.latitude, start.longitude, end.latitude, end.longitude) /
//           1000)
//       .toStringAsFixed(1);
// }

Future sendHttpNotification(
    {String? token,
    required String? title,
    required String? body,
    Map<String, dynamic>? data}) async {
  try {
    http.Response response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':
            'key=BAQux8nHhR__PdT2OFr5Di_uK6s3Vbk4PNvRPVgNTOL1XVqF4pv_UzJ70vywnP9-bQk-sQVF9-xedek91sElqOE',
      },
      body: jsonEncode({
        'registration_ids': [firebaseMessaging.getToken()],
        'data': data,
        'notification': {
          'title': '$title',
          'body': '$body',
          "sound": "default"
        },
      }),
    );
    Logger().i(response.body);
  } catch (e) {
    rethrow;
  }
}

Future sendFirebaseNotification({
  required String avatar,
  required String message,
  required String userId,
  required String id,
}) async {
  try {
    await notificationsDb.doc().set({
      'user': userId,
      'avatar': avatar,
      'message': message,
      'id': id,
      'created_at': FieldValue.serverTimestamp(),
      'sender': AuthControllers.to.liveUser.value!.uid,
    });
  } catch (e) {
    rethrow;
  }
}
