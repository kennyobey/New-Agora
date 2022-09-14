// ignore_for_file: unused_field, unnecessary_null_comparison

import 'dart:math';

import 'package:agora_care/app/cells/chat_page.dart';
import 'package:agora_care/core/constant/colors.dart';
import 'package:agora_care/core/customWidgets.dart';
import 'package:agora_care/helper/helper_function.dart';
import 'package:agora_care/services/auth_controller.dart';
import 'package:agora_care/services/cell_controller.dart';
import 'package:agora_care/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CellInfo extends StatefulWidget {
  final DateTime time;
  final String admin;
  final String cellQuote;
  final String groupId;
  final String userName;
  final String groupName;
  final String assetName;
  final List<String> tags;
  final String description;
  final List<String> memberList;
  const CellInfo({
    Key? key,
    required this.tags,
    required this.time,
    required this.admin,
    required this.groupId,
    required this.cellQuote,
    required this.groupName,
    required this.userName,
    required this.assetName,
    required this.memberList,
    required this.description,
  }) : super(key: key);

  @override
  State<CellInfo> createState() => _CellInfoState();
}

class _CellInfoState extends State<CellInfo> {
  final _cellController = Get.find<CellControllers>();
  final _authController = Get.find<AuthControllers>();
  String userName = "";
  String email = "";
  String groupName = "";
  Stream? groups;
  final bool _isLoading = false;
  late List<Widget> _screens;
  int tabIndex = 1;
  final int _selectedIndex = 1;
  final _scaffoldState = GlobalKey();
  final List<Color> colorList = <Color>[
    AppColor().pinkColor,
    AppColor().blueColor,
    AppColor().backgroundColor,
    AppColor().primaryColor,
    AppColor().pinkColor,
    AppColor().blueColor,
    AppColor().backgroundColor,
    AppColor().primaryColor,
    AppColor().pinkColor,
    AppColor().blueColor,
    AppColor().backgroundColor,
    AppColor().primaryColor,
  ];

  final List<String> imageName = <String>[
    'assets/images/image1.png',
    'assets/images/image2.png',
    'assets/images/image1.png',
    'assets/images/image2.png',
  ];

  // string manipulation

  gettingUserData() async {
    await HelperFunction.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    // getting the list of snapshots in our stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor().whiteColor,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: Container(
        color: AppColor().boxColor,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(20),
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.arrow_back_ios,
                color: AppColor().blackColor,
              ),
            ),
            const Gap(80),
            Center(
              child: Column(
                children: [
                  SvgPicture.asset(
                    'assets/svgs/circularbank.svg',
                  ),
                  customTitleText(
                    widget.groupName,
                    size: 32,
                    spacing: -0.1,
                    fontWeight: FontWeight.w700,
                    colors: AppColor().filledTextField,
                  ),
                ],
              ),
            ),
            const Gap(30),
            customDescriptionText(
              'About',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              colors: AppColor().filledTextField,
            ),
            customDescriptionText(
              widget.description,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              colors: AppColor().filledTextField,
            ),
            const Gap(30),
            customDescriptionText(
              'Members',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              colors: AppColor().filledTextField,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                customDescriptionText(
                  widget.memberList != null
                      ? '${widget.memberList.length}'
                      : '0 member',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  colors: AppColor().filledTextField,
                ),
                customDescriptionText(
                  widget.time == null
                      ? 'Not available'
                      : 'Last activity: ${DateFormat('MMM dd yyy').format(DateTime.parse(widget.time.toString()))}',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  colors: AppColor().lastActivity,
                ),
              ],
            ),
            const Gap(30),
            customDescriptionText(
              'Tags',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              colors: AppColor().filledTextField,
            ),
            const Gap(10),
            Obx(() {
              if (_cellController.cellStatus == CellStatus.LOADING) {
                return Center(
                  child: CircularProgressIndicator(
                    color: AppColor().primaryColor,
                  ),
                );
              } else if (_cellController.cellStatus != CellStatus.LOADING) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                  child: ListView.builder(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.horizontal,
                      itemCount:
                          widget.tags.length > 4 ? 4 : widget.tags.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = widget.tags[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColor().tagButton,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: customDescriptionText(
                              item,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              colors: AppColor().filledTextField,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }),
                );
              } else {
                return Center(
                  child: customDescriptionText('No Tags Available'),
                );
              }
            }),
            const Gap(30),
            CustomFillButton(
              buttonText: (_authController.liveUser.value!.admin == true ||
                      _authController.liveUser.value!.role == 'consultant')
                  ? 'View Cells'
                  : 'Join Cells',
              textColor: AppColor().button1Color,
              buttonColor: AppColor().primaryColor,
              isLoading: _isLoading,
              onTap: () async {
                if (kDebugMode) {
                  print(
                      '${widget.userName} is Joining ${widget.groupName} Cell with ID ${widget.groupId}');
                }
                if (_authController.liveUser.value!.cellsJoined!
                    .contains(widget.groupId)) {
                  Get.snackbar('Alert', 'You are already in a cell');
                } else {
                  (_authController.liveUser.value!.admin == true ||
                          _authController.liveUser.value!.role == 'consultant')
                      ? _cellController.memberCellAdd(widget.groupId)
                      : null;
                  (_authController.liveUser.value!.admin != true ||
                          _authController.liveUser.value!.role != 'consultant')
                      ? _cellController.memberAdd(widget.groupId)
                      : null;
                  Get.to(
                    () => ChatPage(
                      admin: widget.admin,
                      groupId: widget.groupId,
                      userName: widget.userName,
                      member: widget.memberList,
                      groupName: widget.groupName,
                      assetName: widget.assetName,
                      cellQuote: widget.cellQuote,
                    ),
                  );
                }
              },
            ),
            const Gap(30),
            Row(
              children: [
                customDescriptionText(
                  'Other Cells'.toUpperCase(),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  colors: AppColor().filledTextField,
                ),
                const Gap(5),
                SvgPicture.asset(
                  'assets/svgs/arrow_right.svg',
                ),
              ],
            ),
            const Gap(20),
            Obx(() {
              if (_cellController.cellStatus == CellStatus.LOADING) {
                return customDescriptionText(
                  'No Available  Cell',
                );
              } else {
                return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.horizontal,
                      itemCount: _cellController.allAvailableCell.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = _cellController.allAvailableCell[index];
                        // if (kDebugMode) {
                        //   print('Cell is now ${item.groupName!.length}');
                        //   print("group id for cell is ${item.groupId}");
                        // }
                        final random = Random();
                        return recommendedCells(
                          tags: item.tags,
                          admin: item.admin,
                          time: item.createdAt,
                          groupId: item.groupId,
                          cellQuote: item.cellQuote,
                          groupName: item.groupName,
                          description: item.description,
                          memberId: item.members,
                          assetName: 'assets/svgs/bank.svg',
                          colors: colorList[random.nextInt(colorList.length)],
                          userName: _authController.liveUser.value!.username!,
                        );
                      },
                    ));
              }
            }),
            const Gap(30),
          ],
        ),
      ),
    );
  }

  GestureDetector recommendedCells({
    Color? colors,
    String? admin,
    DateTime? time,
    String? groupId,
    String? groupName,
    String? assetName,
    String? userName,
    String? cellQuote,
    String? description,
    List<String>? tags,
    List<String>? memberId,
  }) {
    return GestureDetector(
      onTap: () {
        if (kDebugMode) {
          print('${widget.userName} is entering ${widget.groupName} cell');
        }
        // Get.to(
        //   () => ChatPage(
        //     admin: admin!,
        //     groupId: groupId!,
        //     groupName: groupName!,
        //     userName: userName!,
        //     assetName: assetName!,
        //     member: widget.memberList,
        //   ),
        // );
        // Get.to(
        //   () => CellInfo(
        //     tags: tags!,
        //     time: time!,
        //     admin: admin!,
        //     groupId: groupId!,
        //     userName: userName!,
        //     groupName: groupName!,
        //     assetName: assetName!,
        //     memberList: widget.memberList,
        //     description: description!,
        //   ),
        // );

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => CellInfo(
                      tags: tags!,
                      time: time!,
                      admin: admin!,
                      cellQuote: cellQuote!,
                      groupId: groupId!,
                      userName: userName!,
                      groupName: groupName!,
                      assetName: assetName!,
                      memberList: widget.memberList,
                      description: description!,
                    )));
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 10, bottom: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.height * 0.2,
          decoration: BoxDecoration(
            color: AppColor().whiteColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: colors,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SvgPicture.asset(
                  assetName!,
                  height: 20,
                  color: AppColor().whiteColor,
                ),
              ),
              const Gap(10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  customTitleText(
                    groupName!,
                    size: 12,
                    textAlign: TextAlign.left,
                    colors: AppColor().blackColor,
                    textOverflow: TextOverflow.clip,
                  ),
                  const Gap(5),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/svgs/people.svg',
                        height: 16,
                        color: AppColor().textColor,
                      ),
                      const Gap(5),
                      customTitleText(
                        widget.memberList != null
                            ? "${widget.memberList.length}"
                            : "0",
                        textAlign: TextAlign.left,
                        size: 12,
                        colors: AppColor().textColor,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector otherCells({
    Color? colors,
    String? groupId,
    String? admin,
    String? groupName,
    String? assetName,
    String? userName,
    String? assetName2,
  }) {
    return GestureDetector(
      onTap: () {
        if (kDebugMode) {
          print('entering ${widget.memberList} Cell');
        }
        Get.to(
          () => ChatPage(
            admin: admin!,
            groupId: groupId!,
            groupName: groupName!,
            userName: userName!,
            assetName: assetName!,
            member: widget.memberList,
            cellQuote: widget.cellQuote,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 10, bottom: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
            color: AppColor().whiteColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                decoration: BoxDecoration(
                  color: colors,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      assetName!,
                      height: 24,
                      color: AppColor().whiteColor,
                    ),
                  ],
                ),
              ),
              const Gap(5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 80,
                    child: customTitleText(
                      groupName!,
                      textAlign: TextAlign.left,
                      colors: AppColor().textColor,
                      size: 16,
                    ),
                  ),
                  const Gap(5),
                  Row(
                    children: [
                      SvgPicture.asset(
                        assetName2!,
                        height: 16,
                        color: AppColor().textColor,
                      ),
                      const Gap(5),
                      customTitleText(
                        '14,000',
                        textAlign: TextAlign.left,
                        size: 12,
                        colors: AppColor().textColor,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
