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

import '../home/home_screen.dart';
import '../home/nav_screen.dart';
import '../profile/profile_screen.dart';

class CellsScreen extends StatefulWidget {
  const CellsScreen({Key? key}) : super(key: key);

  @override
  State<CellsScreen> createState() => _CellsScreenState();
}

class _CellsScreenState extends State<CellsScreen> {
  final _cellContoller = Get.find<CellControllers>();
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
            //                         _authController.liveUser.value!.username!,
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
                          assetName: 'assets/svgs/bank.svg',
                          userName: _authController.liveUser.value!.username!,
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
            // Expanded(
            //   child: StreamBuilder(
            //       stream: groups,
            //       builder: (context, AsyncSnapshot snapshot) {
            //         if (snapshot.hasData) {
            //           if (snapshot.data['groups'] != null) {
            //             if (snapshot.data['groups'].length != 0) {
            //               return GridView.builder(
            //                 padding: EdgeInsets.zero,
            //                 scrollDirection: Axis.vertical,
            //                 itemCount: snapshot.data['groups'].length,
            //                 // itemCount: colorList.length,
            //                 gridDelegate:
            //                     const SliverGridDelegateWithFixedCrossAxisCount(
            //                         childAspectRatio: 5 / 3, crossAxisCount: 2),
            //                 itemBuilder: (BuildContext context, int index) {
            //                   int reverseIndex =
            //                       snapshot.data['groups'].length - index - 1;
            //                   final random = Random();
            //                   return otherCells(
            //                     colors:
            //                         colorList[random.nextInt(colorList.length)],
            //                     groupId: getId(
            //                         snapshot.data['groups'][reverseIndex]),
            //                     groupName: getName(
            //                         snapshot.data['groups'][reverseIndex]),
            //                     assetName: 'assets/svgs/bank.svg',
            //                     assetName2: 'assets/svgs/people.svg',
            //                     userName:
            //                         _authController.liveUser.value!.username!,
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
            Expanded(
              child: Obx(() {
                if (_cellContoller.cellStatus == CellStatus.LOADING) {
                  return Center(
                    child: CircularProgressIndicator(
                        color: AppColor().primaryColor),
                  );
                } else if (_cellContoller.cellStatus != CellStatus.LOADING) {
                  return GridView.builder(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.vertical,
                      itemCount: _cellContoller.allAvailableCell.length,
                      // itemCount: colorList.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 5 / 3, crossAxisCount: 2),
                      itemBuilder: (BuildContext context, int index) {
                        // int reverseIndex =
                        //     _cellContoller.allAvailableCell.length - index - 1;
                        final random = Random();
                        final item = _cellContoller.allAvailableCell[index];
                        return otherCells(
                          colors: colorList[random.nextInt(colorList.length)],
                          groupId: item.groupId,
                          groupName: item.groupName,
                          assetName: 'assets/svgs/bank.svg',
                          assetName2: 'assets/svgs/people.svg',
                          userName: _authController.liveUser.value!.username!,
                        );
                      });
                } else if (_cellContoller.cellStatus == CellStatus.EMPTY) {
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
