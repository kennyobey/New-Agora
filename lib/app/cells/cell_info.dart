// ignore_for_file: unused_field

import 'dart:math';

import 'package:agora_care/app/group_screen/chat_page.dart';
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

class CellInfo extends StatefulWidget {
  const CellInfo({Key? key}) : super(key: key);

  @override
  State<CellInfo> createState() => _CellInfoState();
}

class _CellInfoState extends State<CellInfo> {
  final _cellContoller = Get.find<CellControllers>();
  final _authContoller = Get.find<AuthControllers>();
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
            const Gap(80),

            Center(
              child: Column(
                children: [
                  SvgPicture.asset(
                    'assets/svgs/circularbank.svg',
                  ),
                  customTitleText(
                    'Chephas cells',
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
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Et magna egestas senectus tellus est, mauris. Consequat eget non sapien a fermentum, pellentesque erat.',
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
                  '14,000',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  colors: AppColor().filledTextField,
                ),
                customDescriptionText(
                  'Last activity: Jan 4, 2022',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 35,
                  width: 70,
                  decoration: BoxDecoration(color: AppColor().tagButton),
                  alignment: Alignment.center,
                  child: customDescriptionText(
                    'Health',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    colors: AppColor().filledTextField,
                    textAlign: TextAlign.center,
                  ),
                ),
                const Gap(10),
                Container(
                  height: 35,
                  width: 70,
                  decoration: BoxDecoration(color: AppColor().tagButton),
                  alignment: Alignment.center,
                  child: customDescriptionText(
                    'Sex',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    colors: AppColor().filledTextField,
                    textAlign: TextAlign.center,
                  ),
                ),
                const Gap(10),
                Container(
                  height: 35,
                  width: 70,
                  decoration: BoxDecoration(color: AppColor().tagButton),
                  alignment: Alignment.center,
                  child: customDescriptionText(
                    'Sexual',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    colors: AppColor().filledTextField,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const Gap(30),
            CustomFillButton(
              buttonText: 'Join Cells',
              textColor: AppColor().button1Color,
              buttonColor: AppColor().primaryColor,
              isLoading: _isLoading,
              onTap: () async {},
            ),
            const Gap(30),
            Row(
              children: [
                customDescriptionText(
                  'Similar Cells'.toUpperCase(),
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
            // SizedBox(
            //   height: MediaQuery.of(context).size.height * 0.1,
            //   child: StreamBuilder(
            //       stream: groups,
            //       builder: (context, AsyncSnapshot snapshot) {
            //         if (snapshot.hasData) {
            //           if (snapshot.data['groups'] != null) {
            //             if (snapshot.data['groups'].length != 0) {
            //               return ListView.builder(
            //                 padding: EdgeInsets.zero,
            //                 scrollDirection: Axis.horizontal,
            //                 // itemCount: colorList.length,
            //                 itemCount: snapshot.data['groups'].length,
            //                 itemBuilder: (BuildContext context, int index) {
            //                   int reverseIndex =
            //                       snapshot.data['groups'].length - index - 1;

            //                   return recommendedCells(
            //                     groupId: getId(
            //                         snapshot.data['groups'][reverseIndex]),
            //                     colors: colorList[index],
            //                     groupName: getName(
            //                         snapshot.data['groups'][reverseIndex]),
            //                     assetName: 'assets/svgs/bank.svg',
            //                     userName:
            //                         _authContoller.liveUser.value!.username!,
            //                   );
            //                 },
            //               );
            //             } else {
            //               return customDescriptionText(
            //                   'No Available Cell to join');
            //             }
            //           } else {
            //             return customDescriptionText(
            //                 'No Available Cell to join');
            //           }
            //         } else {
            //           return Center(
            //             child: CircularProgressIndicator(
            //                 color: Theme.of(context).primaryColor),
            //           );
            //         }
            //       }),
            // ),
            Obx(() {
              if (_cellContoller.cellStatus == CellStatus.LOADING) {
                return customDescriptionText('No Available  Cell');
              } else {
                return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.horizontal,
                      // itemCount: imageName.length,
                      itemCount: _cellContoller.allAvailableCell.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = _cellContoller.allAvailableCell[index];
                        if (kDebugMode) {
                          print('Cell is now ${item.groupName!.length}');
                          print("group id for cell is ${item.groupId}");
                        }
                        final random = Random();
                        return recommendedCells(
                          groupId: item.groupId,
                          groupName: item.groupName,
                          colors: colorList[random.nextInt(colorList.length)],
                          assetName:
                              _authContoller.liveUser.value!.profilePic == null
                                  ? 'assets/svgs/bank.svg'
                                  : _authContoller.liveUser.value!.profilePic!,
                          userName: _authContoller.liveUser.value!.username!,
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
    String? groupId,
    String? groupName,
    String? assetName,
    String? userName,
  }) {
    return GestureDetector(
      onTap: () {
        if (kDebugMode) {
          print('$userName is Joining Group');
        }
        Get.to(
          () => ChatPage(
            groupId: groupId!,
            groupName: groupName!,
            userName: userName!,
            assetName: assetName!,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 10, bottom: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
          width: MediaQuery.of(context).size.width * 0.35,
          height: MediaQuery.of(context).size.height * 0.2,
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
                height: 30,
                color: AppColor().whiteColor,
              ),
              const Gap(10),
              customTitleText(
                groupName!,
                textAlign: TextAlign.left,
                colors: AppColor().whiteColor,
                size: 16,
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
    String? groupName,
    String? assetName,
    String? userName,
    String? assetName2,
  }) {
    return GestureDetector(
      onTap: () {
        if (kDebugMode) {
          print('Joining Group');
        }
        Get.to(
          () => ChatPage(
            groupId: groupId!,
            groupName: groupName!,
            userName: userName!,
            assetName: assetName!,
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
