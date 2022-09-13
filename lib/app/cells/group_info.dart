import 'package:agora_care/app/home/navigation_bars/nav_screen.dart';
import 'package:agora_care/core/constant/colors.dart';
import 'package:agora_care/core/customWidgets.dart';
import 'package:agora_care/services/auth_controller.dart';
import 'package:agora_care/services/cell_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../services/database_service.dart';

class GroupInfo extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String adminName;
  final String userName;
  final List<String>? member;
  final List<String>? memberName;

  const GroupInfo(
      {Key? key,
      required this.adminName,
      required this.groupName,
      required this.groupId,
      this.memberName,
      required this.userName,
      this.member})
      : super(key: key);

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  final _authController = Get.find<AuthControllers>();
  final _cellController = Get.find<CellControllers>();
  Stream? members;
  int? memberslen;
  @override
  void initState() {
    getMembers();
    //  members= _cellController.getGroupMembers(widget.groupId);
    super.initState();
  }

  getMembers() async {
    if (kDebugMode) {
      print('members is ${widget.groupId}');
      print('members is number is ${widget.groupId.length}');
    }
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupMembers(widget.groupId)
        .then((val) {
      setState(() {
        members = val;
      });
    });
  }

  String getName(String r) {
    return r.substring(r.indexOf("_") + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD:lib/app/group_screen/group_info.dart
=======
    if (kDebugMode) {
      print("memeber length is for info ${widget.member}");
    }
>>>>>>> new_cell:lib/app/cells/group_info.dart
    if (kDebugMode) {
      print('members numbers is $memberslen');
    }
    if (kDebugMode) {
      print("memeber name is ${widget.userName}");
      print("memeber length is for info ${widget.member?.length}");
    }
    membersLenght();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColor().whiteColor,
        title: customTitleText(
          "Cell Info",
          colors: AppColor().primaryColor,
        ),
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       showDialog(
        //           barrierDismissible: false,
        //           context: context,
        //           builder: (context) {
        //             return AlertDialog(
        //               title: customDescriptionText("Exit"),
        //               content: customDescriptionText(
        //                   "Are you sure you exit the group? "),
        //               actions: [
        //                 IconButton(
        //                   onPressed: () {
        //                     Navigator.pop(context);
        //                   },
        //                   icon: const Icon(
        //                     Icons.cancel,
        //                     color: Colors.red,
        //                   ),
        //                 ),
        //                 //Leave Chat
        //                 IconButton(
        //                   onPressed: () async {
        //                     DatabaseService(
        //                             uid: FirebaseAuth.instance.currentUser!.uid)
        //                         .toggleGroupJoin(widget.groupId,
        //                             getName(widget.adminName), widget.groupName)
        //                         .whenComplete(() {
        //                       nextScreenReplace(context, const HomeScreen());
        //                     });
        //                   },
        //                   icon: const Icon(
        //                     Icons.done,
        //                     color: Colors.green,
        //                   ),
        //                 ),
        //               ],
        //             );
        //           });
        //     },
        //     icon: Icon(
        //       Icons.exit_to_app,
        //       color: AppColor().primaryColor,
        //     ),
        //   )
        // ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColor().primaryColor.withOpacity(0.2),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: AppColor().primaryColor,
                    child: Text(
                      widget.groupName.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          customTitleText(
                            "Cell:",
                            size: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          const Gap(5),
                          customTitleText(
                            widget.groupName,
                            size: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          customDescriptionText(
                            "Admin:",
                            fontWeight: FontWeight.bold,
                            colors: AppColor().blackColor,
                          ),
                          const Gap(5),
                          customDescriptionText(
                            _authController.liveUser.value!.admin == true
                                ? getName(widget.adminName)
                                : widget.adminName,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  customDescriptionText(
                    'Leave Cell',
                    fontWeight: FontWeight.bold,
                    colors: AppColor().errorColor,
                    decoration: TextDecoration.underline,
                    onTap: () {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: customDescriptionText(
                                "Exit",
                                fontWeight: FontWeight.bold,
                                colors: AppColor().blackColor,
                              ),
                              content: customDescriptionText(
                                  "Are you sure you exit the group? "),
                              actions: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                  ),
                                ),
                                //Leave Chat
                                IconButton(
                                  onPressed: () async {
                                    DatabaseService(
                                            uid: FirebaseAuth
                                                .instance.currentUser!.uid)
                                        .toggleGroupJoin(
                                            widget.groupId,
                                            getName(widget.adminName),
                                            widget.groupName)
                                        .whenComplete(() {
                                      Get.offAll(() => UserNavScreen());
                                      Get.snackbar("Alert",
                                          'Successfully left the ${widget.groupName}');
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.done,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            );
                          });
                    },
                  ),
                ],
              ),
            ),
            // ListView.builder(
            //     itemCount: 5,
            //     itemBuilder: (BuildContext context, int index) {
            //       return ListTile(
            //           leading: const Icon(Icons.list),
            //           trailing: const Text(
            //             "GFG",
            //             style: TextStyle(color: Colors.green, fontSize: 15),
            //           ),
            //           title: Text("List item $index"));
            //     }),
          ],
        ),
      ),
    );
  }

  memberList() {
    return StreamBuilder(
      stream: members,
      // stream: _cellController.getGroupMembers(widget.groupId),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            if (snapshot.data!.length != 0) {
              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 10),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor: AppColor().primaryColor,
                          child: customTitleText(
                            // getName(snapshot.data.docs.data()!['members']
                            //         [index])
                            //     .substring(0, 1)
                            //     .toUpperCase(),
                            'data',

                            size: 15,
                            fontWeight: FontWeight.bold,
                            colors: AppColor().whiteColor,
                          ),
                        ),
                        title: customDescriptionText('anananna'),
                        // title: Text(getName(snapshot.data['members'][index])),
                        // subtitle: Text(getId(snapshot.data['members'][index])),
                      ),
                    );
                  },
                ),
              );
            } else {
              return const Center(
                child: Text("NO MEMBERS"),
              );
            }
          } else {
            return const Center(
              child: Text("NO MEMBERS"),
            );
          }
        } else {
          return Center(
              child: CircularProgressIndicator(
            color: AppColor().primaryColor,
          ));
        }
      },
    );
  }

  Future membersLenght() async {
    // print("Mem ---> ${members?.length}");
    return memberslen = await members?.length;
  }
}
