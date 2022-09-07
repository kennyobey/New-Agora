// ignore_for_file: constant_identifier_names, avoid_function_literals_in_foreach_calls

import 'dart:convert';

import 'package:agora_care/core/constant/colors.dart';
import 'package:agora_care/services/auth_controller.dart';
import 'package:agora_care/services/quote_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

const String FWPublicKey = 'FLWPUBK-c609afd20eaa92830893fc89408d2fbf-X';
const String FWSecretKey = 'FLWSECK-77a670d7c734149c075f3421cbc8042e-X';
const String FWEncryptionKey = '77a670d7c734f4bdb2afa66d';

OutlineInputBorder appInputOutlineBorder() => OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(
        color: AppColor().primaryColor,
        width: 3.0,
      ),
    );

// Collections

CollectionReference userDb = FirebaseFirestore.instance.collection('users');
CollectionReference ordersDb = FirebaseFirestore.instance.collection('orders');
CollectionReference? qutationsDb =
    FirebaseFirestore.instance.collection('qutation');
CollectionReference walletDB = FirebaseFirestore.instance.collection('wallet');
CollectionReference notificationsDb =
    FirebaseFirestore.instance.collection('notifications');

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
    String? title,
    String? body,
    Map<String, dynamic>? data}) async {
  try {
    http.Response response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':
            'key=AAAAu7SwJSU:APA91bHVVOEWKIG-mm06w75dSvO4hUc_I4aJ9TAGF2IXynK-_uxuNxOml_x-Za5ysyjPYpwUqcl-UGO-VDwVMsztwpjwsZRTHJxXld9JgsAwZQAfRcEZ_2oWb_i1kgUYC5h5qrpJ_Wa5',
      },
      body: jsonEncode({
        'registration_ids': [token],
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

Future sendFirebaseNotification(
    String avatar, String message, String userId, String type,
    [String? id]) async {
  try {
    await notificationsDb.doc().set({
      'user': userId,
      'avatar': avatar,
      'message': message,
      'id': id ?? '',
      'created_at': FieldValue.serverTimestamp(),
      'sender': AuthControllers.to.liveUser.value!.uid,
    });
  } catch (e) {
    rethrow;
  }
}
