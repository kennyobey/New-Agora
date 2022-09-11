import 'dart:io';

import 'package:agora_care/app/onboarding/splashscreen.dart';
import 'package:agora_care/binding/appbinding.dart';
import 'package:agora_care/core/constant/app_palette.dart';
import 'package:agora_care/core/constant/colors.dart';
import 'package:agora_care/services/auth_controller.dart';
import 'package:agora_care/services/fcm_controller.dart';
// import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'routes/app_router.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   await SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//   ]);
//   runApp(
//     DevicePreview(
//       enabled: true,
//       builder: (BuildContext context) => const AgoraCare(),
//     ),
//   );
// }

final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final _authController = Get.find<AuthControllers>();

void registerNotification() {
  firebaseMessaging.requestPermission();

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
    FCMService().processNotification(event.data);
  });

  firebaseMessaging.getToken().then((token) {
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

void configLocalNotification() {
  AndroidInitializationSettings initializationSettingsAndroid =
      const AndroidInitializationSettings('app_icon');
  IOSInitializationSettings initializationSettingsIOS =
      const IOSInitializationSettings();
  InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage remotemessage) async {
  await Firebase.initializeApp();
  if (kDebugMode) {
    print('remote message ID ${remotemessage.messageId}');
  }
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

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.high,
  playSound: true,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

//Background Notification
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  //Channel Notification Listner
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  //Foreground Notification
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  EasyLoading.init();
  runApp(const AgoraCare());
}

class AgoraCare extends StatelessWidget {
  const AgoraCare({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerUp: (_) {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          currentFocus.focusedChild?.unfocus();
        }
      },
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialBinding: AppBinding(),
        title: 'Agora Care Mobile App',
        darkTheme: Get.isDarkMode ? ThemeData.dark() : ThemeData.light(),

        theme: ThemeData(
          fontFamily: 'HK GROTESK',
          primarySwatch: Palette.primaryColor,
          primaryColor: AppColor().primaryColor,
        ),
        onGenerateRoute: generateRoute,
        home: SplashScreen(),
        // home: const VerifyMobile(),
      ),
    );
  }
}
