// ignore_for_file: unused_field

import 'dart:math';

import 'package:agora_care/app/cells/cell_info.dart';
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

import '../home/home_screen.dart';
import '../home/nav_screen.dart';
import '../profile/profile_screen.dart';

class CellsScreen extends StatefulWidget {
  const CellsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CellsScreen> createState() => _CellsScreenState();
}

class _CellsScreenState extends State<CellsScreen> {
  final _cellController = Get.find<CellControllers>();
  final _authController = Get.find<AuthControllers>();
  final _scaffoldState = GlobalKey();

  String userName = "";
  String email = "";
  String groupName = "";
  Stream? groups;

  final bool _isLoading = false;
  late List<Widget> _screens;

  int tabIndex = 1;
  int _selectedIndex = 1;

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

  @override
  void initState() {
    super.initState();
    // gettingUserData();
    _screens = [
      //Home Screen
      const HomeScreen(),

      // Cells Screens
      const CellsScreen(),

      // Profile Screen
      const ProfileScreen(),
    ];
  }

  // string manipulation
  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  gettingUserDatas() async {
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
      bottomNavigationBar: BottomNavigationBar(
        landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
        onTap: (newIndex) async => {
          if (newIndex == 1)
            {}
          else
            {
              setState(
                () {
                  setState(() {
                    tabIndex = newIndex;
                    _selectedIndex = tabIndex;
                    // _selectPage;
                  });
                  Get.off(
                    () => UserNavScreen(
                      tabIndex: newIndex,
                    ),
                  );
                },
              ),
            }
        },
        backgroundColor: AppColor().whiteColor,
        currentIndex: _selectedIndex,
        elevation: 20,
        key: _scaffoldState,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).bottomAppBarColor,
            icon: SvgPicture.asset(
              'assets/svgs/home.svg',
            ),
            label: '',
            tooltip: 'Home',
            activeIcon: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                SvgPicture.asset('assets/svgs/home_filled.svg'),
                SvgPicture.asset('assets/svgs/home.svg'),
              ],
            ),
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).bottomAppBarColor,
            icon: SvgPicture.asset('assets/svgs/people.svg'),
            label: '',
            tooltip: 'Cells',
            activeIcon: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                SvgPicture.asset('assets/svgs/people_filled.svg'),
                SvgPicture.asset('assets/svgs/people.svg'),
              ],
            ),
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).bottomAppBarColor,
            label: '',
            tooltip: 'Users',
            icon: SvgPicture.asset('assets/svgs/user-tag.svg'),
            activeIcon: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                SvgPicture.asset('assets/svgs/user-tag_filled.svg'),
                SvgPicture.asset('assets/svgs/user-tag.svg'),
              ],
            ),
          ),
        ],
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
            customTitleText(
              'Cells',
              size: 32,
              spacing: -0.1,
              fontWeight: FontWeight.w800,
              colors: AppColor().filledTextField,
            ),
            const Gap(20),
            Row(
              children: [
                customDescriptionText(
                  'Most common'.toUpperCase(),
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
                return customDescriptionText('No Available  Cell');
              } else {
                return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.horizontal,
                      // itemCount: imageName.length,
                      itemCount: _cellController.allAvailableCell.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = _cellController.allAvailableCell[index];
                        // if (kDebugMode) {
                        //   print('Cell is now ${item.groupName!.length}');
                        //   print("group id for cell is ${item.groupId}");
                        // }
                        final random = Random();
                        return recommendedCells(
                          admin: item.admin,
                          time: item.createdAt,
                          groupId: item.groupId,
                          groupName: item.groupName,
                          memberList: item.members!,
                          description: item.description,
                          assetName: 'assets/svgs/bank.svg',
                          colors: colorList[random.nextInt(colorList.length)],
                          userName:
                              _authController.liveUser.value!.username == null
                                  ? 'No Username'
                                  : _authController.liveUser.value!.username!,
                        );
                      },
                    ));
              }
            }),
            const Gap(30),
            Row(
              children: [
                customDescriptionText(
                  'Other cells'.toUpperCase(),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  colors: AppColor().filledTextField,
                ),
                // ListView(),
                const Gap(5),
                SvgPicture.asset(
                  'assets/svgs/arrow_right.svg',
                ),
              ],
            ),
            const Gap(10),
            Expanded(
              child: Obx(() {
                if (_cellController.cellStatus == CellStatus.LOADING) {
                  return Center(
                    child: CircularProgressIndicator(
                        color: AppColor().primaryColor),
                  );
                } else if (_cellController.cellStatus != CellStatus.LOADING) {
                  return GridView.builder(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.vertical,
                      itemCount: _cellController.allAvailableCell.length,
                      // itemCount: colorList.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 5 / 3.7, crossAxisCount: 2),
                      itemBuilder: (BuildContext context, int index) {
                        // int reverseIndex =
                        //     _cellController.allAvailableCell.length - index - 1;
                        final random = Random();
                        final item = _cellController.allAvailableCell[index];
                        return otherCells(
                          colors: colorList[random.nextInt(colorList.length)],
                          groupId: item.groupId,
                          groupName: item.groupName,
                          assetName: 'assets/svgs/bank.svg',
                          assetName2: 'assets/svgs/people.svg',
                          memberLength: item.members!,
                          time: item.createdAt!,
                          admin: item.admin!,
                          description: item.description!,
                          userName:
                              _authController.liveUser.value!.username == null
                                  ? 'No Username'
                                  : _authController.liveUser.value!.username!,
                        );
                      });
                } else if (_cellController.cellStatus == CellStatus.EMPTY) {
                  return customDescriptionText('No Available Cell to join');
                } else {
                  return customDescriptionText('No Available Cell to join');
                }
                // } else {
                //   return Center(
                //     child: CircularProgressIndicator(
                //         color: Theme.of(context).primaryColor),
                // );
              }),
            ),
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
    String? userName,
    String? groupName,
    String? assetName,
    String? description,
    List<String>? memberList,
  }) {
    return GestureDetector(
      onTap: () {
        // Get.to(
        //   () => ChatPage(
        //     groupId: groupId!,
        //     groupName: groupName!,
        //     userName: userName!,
        //     assetName: assetName!,
        //   ),
        // );
        Get.to(() => CellInfo(
              admin: admin!,
              time: time!,
              groupId: groupId!,
              groupName: groupName!,
              userName: userName!,
              assetName: assetName!,
              memberList: memberList!,
              description: description!,
            ));
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
    DateTime? time,
    String? admin,
    String? groupId,
    String? groupName,
    String? assetName,
    String? userName,
    String? assetName2,
    String? description,
    List<String>? memberLength,
  }) {
    return GestureDetector(
      onTap: () {
        if (kDebugMode) {
          print('Joining Group');
        }
        Get.to(() => CellInfo(
              admin: admin!,
              time: time!,
              groupId: groupId!,
              groupName: groupName!,
              userName: userName!,
              assetName: assetName!,
              memberList: memberLength!,
              description: description!,
            ));
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 10, bottom: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          decoration: BoxDecoration(
            color: AppColor().whiteColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              // Container(
              //   width: MediaQuery.of(context).size.width * 0.1,
              //   padding:
              //       const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              //   margin: const EdgeInsets.only(top: 10, bottom: 10),
              //   decoration: BoxDecoration(
              //     color: colors,
              //     borderRadius: BorderRadius.circular(10),
              //   ),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     children: [
              //       SvgPicture.asset(
              //         assetName!,
              //         height: 18,
              //         color: AppColor().whiteColor,
              //       ),
              //     ],
              //   ),
              // ),
              const Gap(5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.15,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
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
                          height: 18,
                          color: AppColor().whiteColor,
                        ),
                      ],
                    ),
                  ),
                  const Gap(10),
                  customTitleText(
                    groupName!,
                    size: 14,
                    textAlign: TextAlign.left,
                    colors: AppColor().textColor,
                    // textOverflow: TextOverflow.clip,
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
                        memberLength != null ? "${memberLength.length}" : "0",
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
