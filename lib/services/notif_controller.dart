// ignore_for_file: unnecessary_null_comparison, unused_field

import 'dart:io';

import 'package:agora_care/core/constant/colors.dart';
import 'package:agora_care/services/auth_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'cell_controller.dart';
import 'quote_controller.dart';

// ignore: constant_identifier_names
enum NotifStatus { LOADING, ERROR, EMPTY, SUCCESS, AVAILABLE, NOTAVAILABLE }

class NotifControllers extends GetxController {
  final cellController = Get.find<CellControllers>();
  final _authController = Get.find<AuthControllers>();
  final _quoteContoller = Get.find<QuoteControllers>();

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void onInit() async {
    super.onInit();
    _authController.liveUser.listen(
      (p0) async {
        if (p0 != null) {
          registerNotification();
          configLocalNotification();
        }
      },
    );
  }

  Future<void> registerNotification() async {
    await firebaseMessaging.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('onMessage: $message');
      }
      if (message.notification != null) {
        showNotification(message.notification!);
      }
      return;
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      // FCMService().processNotification(event.data);
    });

    await firebaseMessaging.getToken().then((token) {
      if (kDebugMode) {
        print('fcm_token: $token');
      }
      if (token != null) {
        _authController.updateDataFirestore(
            _authController.liveUser.value!.uid!, {'fcm_token': token});
      }
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
    });
  }

  Future<void> configLocalNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');
    IOSInitializationSettings initializationSettingsIOS =
        const IOSInitializationSettings();
    InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(RemoteNotification remoteNotification) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      Platform.isAndroid ? 'com.agoracare.app' : 'com.agoracare.app',
      'Agora Care',
      playSound: true,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
    );
    IOSNotificationDetails iOSPlatformChannelSpecifics =
        const IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    if (kDebugMode) {
      print(remoteNotification);
    }

    await flutterLocalNotificationsPlugin.show(
      0,
      remoteNotification.title,
      remoteNotification.body,
      platformChannelSpecifics,
      payload: null,
    );
  }

  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true,
  );

  Future<void> showSentNotification(String title, String body) async {
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(channel.id, channel.name,
            importance: Importance.high,
            color: AppColor().primaryColor,
            playSound: true,
            icon: '@mipmap/ic_launcher'),
      ),
    );
  }
}
