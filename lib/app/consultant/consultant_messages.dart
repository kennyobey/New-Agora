// ignore_for_file: unnecessary_null_comparison, avoid_unnecessary_containers

import 'dart:async';
import 'dart:io';

import 'package:agora_care/app/consultant/consultant_chat_page.dart';
import 'package:agora_care/app/model/user_list_model.dart';
import 'package:agora_care/core/constant/colors.dart';
import 'package:agora_care/core/customWidgets.dart';
import 'package:agora_care/core/debouncer.dart';
import 'package:agora_care/core/utilities.dart';
import 'package:agora_care/services/auth_controller.dart';
import 'package:agora_care/services/fcm_controller.dart';
import 'package:agora_care/widget/loading_view.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ConsultantMessage extends StatefulWidget {
  const ConsultantMessage({Key? key}) : super(key: key);

  @override
  State createState() => ConsultantMessageState();
}

class ConsultantMessageState extends State<ConsultantMessage> {
  final _authController = Get.find<AuthControllers>();

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final ScrollController listScrollController = ScrollController();

  int _limit = 20;
  final int _limitIncrement = 20;
  String _textSearch = "";
  final String _role = "user";
  bool isLoading = false;
  late String currentUserId;

  Debouncer searchDebouncer = Debouncer(milliseconds: 300);
  StreamController<bool> btnClearController = StreamController<bool>();
  TextEditingController searchBarTec = TextEditingController();

  @override
  void initState() {
    super.initState();

    registerNotification();
    configLocalNotification();
    listScrollController.addListener(scrollListener);

    if (_authController.getUserFirebaseId()?.isNotEmpty == true) {
      currentUserId = _authController.getUserFirebaseId()!;
    } else {
      Center(child: customDescriptionText('Not available'));
    }
  }

  @override
  void dispose() {
    super.dispose();
    btnClearController.close();
  }

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

  void scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  void showNotification(RemoteNotification remoteNotification) async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor().whiteColor,
        title: customTitleText(
          'Ticket List',
          colors: AppColor().primaryColor,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // List
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: buildSearchBar(),
                ),
                StreamBuilder<List<UserList>>(
                  stream: _authController.getStreamFireStore(
                    _limit,
                    _textSearch,
                    _role,
                  ),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      if ((snapshot.data!.length ?? 0) > 0) {
                        return Expanded(
                          child: ListView.builder(
                            controller: listScrollController,
                            itemCount: snapshot.data!.length,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: buildItem(
                                context,
                                snapshot.data![index],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Gap(50),
                            Center(
                              child: customDescriptionText(
                                'No User Available',
                              ),
                            ),
                          ],
                        );
                      }
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColor().primaryColor,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
            // Loading
            Positioned(
              child: isLoading ? const LoadingView() : const SizedBox.shrink(),
            )
          ],
        ),
      ),
    );
  }

  Widget buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 1,
          color: AppColor().primaryColor,
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 15,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.search,
            color: AppColor().primaryColor,
            size: 25,
          ),
          const SizedBox(width: 5),
          Expanded(
            child: TextFormField(
              cursorColor: AppColor().primaryColor2,
              textInputAction: TextInputAction.search,
              controller: searchBarTec,
              onChanged: (value) {
                searchDebouncer.run(() {
                  if (value.isNotEmpty) {
                    btnClearController.add(true);
                    setState(() {
                      _textSearch = value;
                    });
                  } else {
                    btnClearController.add(false);
                    setState(() {
                      _textSearch = "";
                    });
                  }
                });
              },
              decoration: InputDecoration.collapsed(
                hintText: 'Search email (you have to type exact string)',
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: AppColor().primaryColor,
                ),
              ),
              style: const TextStyle(fontSize: 13),
            ),
          ),
          StreamBuilder<bool>(
            stream: btnClearController.stream,
            builder: (context, snapshot) {
              return snapshot.data == true
                  ? GestureDetector(
                      onTap: () {
                        searchBarTec.clear();
                        btnClearController.add(false);
                        setState(() {
                          _textSearch = "";
                        });
                      },
                      child: Icon(
                        Icons.clear_rounded,
                        color: AppColor().primaryColor2,
                        size: 20,
                      ),
                    )
                  : const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget buildItem(BuildContext context, UserList? document) {
    if (document != null) {
      if (document.uid == currentUserId) {
        return const SizedBox.shrink();
      } else {
        return Container(
          child: TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                AppColor().primaryColor.withOpacity(0.2),
              ),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
            ),
            onPressed: () {
              if (Utilities.isKeyboardShowing()) {
                Utilities.closeKeyboard(context);
              }
              Get.to(
                () => ConsultChatPage(
                  arguments: ConsultChatPageArguments(
                    peerId: document.uid!,
                    peerAvatar: document.profilePic!,
                    peerNickname: document.username!,
                  ),
                ),
              );
            },
            child: Row(
              children: [
                Material(
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                  clipBehavior: Clip.hardEdge,
                  child: document != null
                      ? Image.network(
                          document.profilePic!,
                          fit: BoxFit.cover,
                          width: 50,
                          height: 50,
                          loadingBuilder: (
                            BuildContext context,
                            Widget child,
                            ImageChunkEvent? loadingProgress,
                          ) {
                            if (loadingProgress == null) return child;
                            return SizedBox(
                              width: 50,
                              height: 50,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColor().primaryColor,
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, object, stackTrace) {
                            return Icon(
                              Icons.account_circle,
                              size: 50,
                              color: AppColor().primaryColor,
                            );
                          },
                        )
                      : Icon(
                          Icons.account_circle,
                          size: 50,
                          color: AppColor().primaryColor,
                        ),
                ),
                Flexible(
                  child: Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.fromLTRB(10, 0, 0, 5),
                          child: Text(
                            'Username: ${document.username}',
                            maxLines: 1,
                            style: TextStyle(color: AppColor().primaryColor),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Text(
                            'User Email: ${document.email}',
                            maxLines: 1,
                            style: TextStyle(color: AppColor().primaryColor),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }
}
