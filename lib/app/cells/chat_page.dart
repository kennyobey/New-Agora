// ignore_for_file: unused_field

import 'package:agora_care/app/home/navigation_bars/nav_screen.dart';
import 'package:agora_care/app/model/message_model.dart';
import 'package:agora_care/app/model/user_model.dart';
import 'package:agora_care/core/constant/colors.dart';
import 'package:agora_care/core/constant/message_tile.dart';
import 'package:agora_care/core/customWidgets.dart';
import 'package:agora_care/services/auth_controller.dart';
import 'package:agora_care/services/cell_controller.dart';
import 'package:agora_care/widget/bottom_modal.dart';
import 'package:agora_care/widget/loading_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_stack/flutter_image_stack.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../services/database_service.dart';
import 'group_info.dart';

class ChatPage extends StatefulWidget {
  final String? admin;
  final String groupId;
  final String groupName;
  final String userName;
  final String assetName;
  final List<String>? member;
  const ChatPage({
    Key? key,
    this.admin,
    this.member,
    required this.groupId,
    required this.userName,
    required this.groupName,
    required this.assetName,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? chats;
  Stream? members;
  final _cellController = Get.find<CellControllers>();
  final _authController = Get.find<AuthControllers>();

  TextEditingController messageController = TextEditingController();
  final ScrollController listScrollController = ScrollController();

  String admin = "";
  int _limit = 20;
  final int _limitIncrement = 20;
  bool _isLoading = false;

  bool isShowSticker = false;

  FocusNode focusNode = FocusNode();

  List<QueryDocumentSnapshot> listMessage = [];

  _scrollListener() {
    if (!listScrollController.hasClients) return;
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange &&
        _limit <= listMessage.length) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  @override
  void initState() {
    getChatandAdmin();
    listScrollController.addListener(_scrollListener);

    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  getChatandAdmin() {
    DatabaseService().getChats(widget.groupId).then((val) {
      setState(() {
        chats = val;
      });
    });
    DatabaseService().getGroupAdmin(widget.groupId).then((val) {
      setState(() {
        admin = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("member length is ${widget.member!.length}");
      print("this member name is ${widget.userName}");
    }

    // final MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor().whiteColor,
        centerTitle: true,
        elevation: 0,
        title: customTitleText(
          widget.groupName,
          fontWeight: FontWeight.bold,
          colors: AppColor().primaryColor,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(
                () => GroupInfo(
                  groupId: widget.groupId,
                  adminName: widget.admin!,
                  userName: widget.userName,
                  groupName: widget.groupName,
                ),
              );
            },
            icon: Icon(
              CupertinoIcons.info_circle,
              color: AppColor().primaryColor,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                headerWidget(),
                (widget.member!.contains(_authController.liveUser.value!.uid))
                    ? chatMessages()
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(child: customDescriptionText("No message")),
                          // Sticker
                        ],
                      ),
                // const SizedBox.shrink(),
                (_authController.liveUser.value!.role == 'consultant' ||
                        _authController.liveUser.value!.admin == true)
                    ? Container()
                    : buildInput(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: _isLoading ? const LoadingView() : const SizedBox.shrink(),
    );
  }

  Widget headerWidget() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColor().primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: FutureBuilder<List<UserModel>>(
                future: _authController.getUserByModelList(widget.member ?? []),
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FlutterImageStack(
                            // backgroundColor: Colors.black,
                            itemBorderColor: AppColor().whiteColor,
                            imageList: snapshot.data!
                                .map(
                                  (e) =>
                                      // e.profilePic ??
                                      "https://images.unsplash.com/photo-1593642532842-98d0fd5ebc1a?ixid=MXwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=2250&q=80",
                                )
                                .toList(),
                            showTotalCount: true,
                            totalCount: widget.member == null
                                ? 0
                                : widget.member!.length,
                            itemRadius: 50, // Radius of each images
                            itemCount: widget.member == null
                                ? 0
                                : widget.member!.length > 4
                                    ? 4
                                    : widget.member!
                                        .length, // Maximum number of images to be shown in stack
                            itemBorderWidth:
                                2, // Border width around the images
                          ),
                          const Gap(15),
                          customDescriptionText(
                            "You and ${widget.member!.length} users are in this cell",
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            colors: AppColor().whiteColor,
                          ),
                          const Gap(5),
                          customDescriptionText(
                            "Leave Cell",
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            colors: AppColor().errorColor,
                            decoration: TextDecoration.underline,
                            onTap: () {
                              // showModalBottomSheet(
                              //   isScrollControlled: true,
                              //   backgroundColor: AppColor().whiteColor,
                              //   shape: const RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.only(
                              //       topLeft: Radius.circular(25),
                              //       topRight: Radius.circular(25),
                              //     ),
                              //   ),
                              //   context: context,
                              //   builder: (context) => GlobalDialogue(
                              //     text1: 'You have joined this cell',
                              //     text2:
                              //         'Be gentle and choose your words carefully to avoid ban on your account. You can leave the cell at any point in time or report any user or message you deem inappropriate.',
                              //     asset: 'assets/svgs/success.svg',
                              //     action: () {
                              //       Get.close(1);
                              //     },
                              //   ),
                              // );
                              showModalBottomSheet(
                                isScrollControlled: true,
                                backgroundColor: AppColor().whiteColor,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(25),
                                    topRight: Radius.circular(25),
                                  ),
                                ),
                                context: context,
                                builder: (context) => GlobalDialogue(
                                  text1: 'Leave cell?',
                                  text2:
                                      'Leaving this cell takes away your access to the cell, conversations and everything. Sure you want to do this?',
                                  asset: 'assets/svgs/cancel.svg',
                                  dailogText: 'Yes, I want to leave',
                                  dialogColor: AppColor().errorColor,
                                  dialogBordColor: AppColor().errorColor,
                                  action: () async {
                                    EasyLoading.show();
                                    await Future.delayed(
                                      const Duration(milliseconds: 3000),
                                    );
                                    await _cellController
                                        .memberRemove(widget.groupId);
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    Get.offAll(() => UserNavScreen());
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          customDescriptionText(
                            "No member available",
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            colors: AppColor().whiteColor,
                          ),
                          const Gap(20),
                          customDescriptionText(
                            'start or join a conversation'.toUpperCase(),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            colors: AppColor().whiteColor.withOpacity(0.3),
                          )
                        ],
                      );
                    }
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColor().whiteColor,
                      ),
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }

  Widget chatMessages() {
    return Flexible(
      child: widget.groupId.isNotEmpty
          ? StreamBuilder<QuerySnapshot>(
              stream: chats,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  listMessage = snapshot.data!.docs;
                  if (listMessage.isNotEmpty) {
                    return ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemBuilder: (context, index) => MessageTile(
                        time: snapshot.data!.docs[index]['time'],
                        message: snapshot.data!.docs[index]['message'],
                        sender: snapshot.data!.docs[index]['sender'],
                        like: snapshot.data!.docs[index]['like'],
                        messageid: snapshot.data!.docs[index].id,
                        sentByMe: widget.userName ==
                            snapshot.data!.docs[index]['sender'],
                        groupId: widget.groupId,
                      ),
                      itemCount: snapshot.data?.docs.length,
                      reverse: false,
                      controller: listScrollController,
                    );
                  } else {
                    return const Center(child: Text("No message here yet..."));
                  }
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColor().primaryColor,
                    ),
                  );
                }
              },
            )
          : Center(
              child: CircularProgressIndicator(
                color: AppColor().primaryColor,
              ),
            ),
    );
  }

  // Widget buildInput() {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  //     alignment: Alignment.bottomCenter,
  //     height: 70,
  //     decoration: BoxDecoration(
  //       border: Border.all(width: 0.7),
  //       color: Colors.white,
  //     ),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         const Gap(5),
  //         (_authController.liveUser.value!.profilePic == null ||
  //                 _authController.liveUser.value!.profilePic == '')
  //             ? Container(
  //                 decoration: const BoxDecoration(
  //                   shape: BoxShape.circle,
  //                   image: DecorationImage(
  //                     image: AssetImage(
  //                       'assets/images/placeholder.png',
  //                     ),
  //                   ),
  //                 ),
  //               )
  //             : Container(
  //                 height: 50,
  //                 width: 50,
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(80),
  //                   image: DecorationImage(
  //                     image: CachedNetworkImageProvider(
  //                       _authController.liveUser.value!.profilePic!,
  //                     ),
  //                     fit: BoxFit.cover,
  //                   ),
  //                 ),
  //               ),
  //         const Gap(5),
  //         Expanded(
  //           child: Container(
  //             height: 60,
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(40),
  //               color: AppColor().chatBox,
  //             ),
  //             padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
  //             width: MediaQuery.of(context).size.width,
  //             child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: [
  //                   Expanded(
  //                     child: TextFormField(
  //                       focusNode: focusNode,
  //                       controller: messageController,
  //                       textInputAction: TextInputAction.send,
  //                       style: TextStyle(
  //                         color: AppColor().backgroundColor,
  //                       ),
  //                       decoration: InputDecoration(
  //                         hintText: "Say something...",
  //                         hintStyle: TextStyle(
  //                           fontSize: 14,
  //                           fontWeight: FontWeight.w400,
  //                           color: Colors.grey[700],
  //                         ),
  //                         border: InputBorder.none,
  //                       ),
  //                       onFieldSubmitted: (value) {
  //                         sendMessage();
  //                       },
  //                     ),
  //                   ),
  //                   const SizedBox(
  //                     width: 12,
  //                   ),
  //                   GestureDetector(
  //                     onTap: () {
  //                       sendMessage();
  //                     },
  //                     child: customDescriptionText(
  //                       'Post',
  //                       fontSize: 14,
  //                       fontWeight: FontWeight.w600,
  //                       colors: AppColor().primaryColor,
  //                     ),
  //                   )
  //                 ]),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  Widget buildInput() {
    return Container(
      width: double.infinity,
      height: 50,
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
          border:
              Border(top: BorderSide(color: AppColor().chatBox, width: 0.5)),
          color: Colors.white),
      child: Row(
        children: [
          // Button send image
          (_authController.liveUser.value!.profilePic == null ||
                  _authController.liveUser.value!.profilePic == '' ||
                  _authController.liveUser.value!.profilePic!.isEmpty)
              ? Image.asset(
                  'assets/images/placeholder.png',
                  height: 50,
                  width: 50,
                )
              : Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(80),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        _authController.liveUser.value!.profilePic!,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
          // Edit text
          Flexible(
            child: TextFormField(
              onFieldSubmitted: (value) {
                sendMessage();
              },
              style: TextStyle(color: AppColor().primaryColor, fontSize: 15),
              controller: messageController,
              decoration: InputDecoration.collapsed(
                hintText: 'Type your message...',
                hintStyle: TextStyle(color: AppColor().blueColor),
              ),
              focusNode: focusNode,
              autofocus: true,
            ),
          ),

          // Button send message
          Material(
            color: Colors.white,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () => sendMessage(),
                color: AppColor().primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      final chatMessageMap = MessageModel(
        message: messageController.text,
        sender: widget.userName,
        time: DateTime.now(),
        like: [],
        comment: [],
      );

      if (listScrollController.hasClients) {
        listScrollController.animateTo(0,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }

      DatabaseService().sendMessage(
        widget.groupId,
        chatMessageMap.toJson(),
      );
      setState(() {
        messageController.clear();
      });

      SystemChannels.textInput.invokeMethod('TextInput.hide');
    }
  }
}
