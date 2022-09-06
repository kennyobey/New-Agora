import 'package:agora_care/app/group_screen/message.dart';
import 'package:agora_care/app/model/user_model.dart';
import 'package:agora_care/core/constant/colors.dart';
import 'package:agora_care/core/customWidgets.dart';
import 'package:agora_care/services/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_stack/flutter_image_stack.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../core/constant/message_tile.dart';
import '../../services/cell_controller.dart';
import '../../services/database_service.dart';
import 'group_info.dart';

class ChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;
  final List<String>? member;
  const ChatPage({
    Key? key,
    required this.groupId,
    required this.groupName,
    required this.userName,
    this.member,
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
  String admin = "";

  @override
  void initState() {
    getChatandAdmin();

    // members = _cellController.getGroupMembers(widget.groupId);
    super.initState();
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
    print("memeber id is ${widget.member}");
    return Scaffold(
      backgroundColor: AppColor().whiteColor,
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
                  groupName: widget.groupName,
                  adminName: admin,
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
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.2,
            // padding: const EdgeInsets.all(10.0),
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
                      future: _authController
                          .getUserByModelList(widget.member ?? []),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                          return FlutterImageStack(
                            // backgroundColor: Colors.black,
                            itemBorderColor: AppColor().whiteColor,
                            imageList: snapshot.data!
                                .map((e) =>
                                    e.profilePic ??
                                    "https://images.unsplash.com/photo-1593642532842-98d0fd5ebc1a?ixid=MXwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=2250&q=80")
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
                          );
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator(
                            color: AppColor().primaryColor,
                          );
                        } else {
                          return customDescriptionText("No member available ");
                        }
                      }),
                ),
                const SizedBox(
                  height: 10,
                ),
                customDescriptionText(
                    widget.member != null ? "${widget.member!.length}" : "0",
                    colors: AppColor().whiteColor)
                // StreamBuilder(
                //     stream: members,
                //     builder: (context, AsyncSnapshot snapshot) {
                //       if (snapshot.hasData) {
                //         return Text(
                //           "${snapshot.data!.length} members",
                //           style: const TextStyle(
                //               color: Colors.white, fontSize: 20),
                //         );
                //       } else {
                //         return Container();
                //       }
                //     })
              ],
            ),
          ),
          Expanded(
            child:
                // chat messages here
                chatMessages(),
          ),
          Container(
            padding: const EdgeInsets.all(5),
            alignment: Alignment.bottomCenter,
            height: 70,
            decoration: BoxDecoration(
              border: Border.all(width: 0.7),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset(
                  'assets/svgs/bankofspain.svg',
                  height: 50,
                  width: 50,
                ),
                const Gap(5),
                Expanded(
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: AppColor().chatBox,
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: messageController,
                              textInputAction: TextInputAction.send,
                              style: TextStyle(
                                color: AppColor().backgroundColor,
                              ),
                              decoration: InputDecoration(
                                hintText: "Say something...",
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey[700],
                                ),
                                border: InputBorder.none,
                              ),
                              onFieldSubmitted: (value) {
                                sendMessage();
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          GestureDetector(
                            onTap: () {
                              sendMessage();
                            },
                            child: customDescriptionText(
                              'Post',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              colors: AppColor().backgroundColor,
                            ),
                          )
                        ]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                    message: snapshot.data.docs[index]['message'],
                    sender: snapshot.data.docs[index]['sender'],
                    like: snapshot.data.docs[index]['like'],
                    messageid: snapshot.data.docs[index].id,
                    sentByMe:
                        widget.userName == snapshot.data.docs[index]['sender'],
                    groupId: widget.groupId,
                  );
                },
              )
            : Container();
      },
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

      DatabaseService().sendMessage(
        widget.groupId,
        chatMessageMap.toJson(),
      );
      setState(() {
        messageController.clear();
      });
    }
  }
}
