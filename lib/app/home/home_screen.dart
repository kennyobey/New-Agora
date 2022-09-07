// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously

import 'dart:math';

import 'package:agora_care/app/cells/cell_screen.dart';
import 'package:agora_care/app/group_screen/chat_page.dart';
import 'package:agora_care/app/model/quote_model.dart';
import 'package:agora_care/app/quote/quote_details.dart';
import 'package:agora_care/app/quote/selected_quote_detail.dart';
import 'package:agora_care/core/constant/colors.dart';
import 'package:agora_care/core/customWidgets.dart';
import 'package:agora_care/helper/helper_function.dart';
import 'package:agora_care/services/auth_controller.dart';
import 'package:agora_care/services/cell_controller.dart';
import 'package:agora_care/services/database_service.dart';
import 'package:agora_care/services/quote_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _authController = Get.find<AuthControllers>();
  final cellContoller = Get.find<CellControllers>();
  final _quoteContoller = Get.find<QuoteControllers>();

  String userName = "";
  String email = "";
  String groupName = "";
  Stream? groups;
  bool isJoined = false;

  final List<Color> colorList = <Color>[
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
    _quoteContoller.getQuotes();
  }

  // string manipulation
  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

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
    // if (kDebugMode) {
    //   print("testing user is ${_authController.liveUser.value!.toJson()}");
    //   print("testing user admin is ${_authController.liveUser.value!.admin}");
    // }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor().whiteColor,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: AppColor().whiteColor,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(20),
              Center(
                child: Obx(() {
                  return (_authController.liveUser.value == null)
                      ? CircularProgressIndicator(
                          color: AppColor().filledTextField,
                        )
                      : customTitleText(
                          'Good afternoon, ${_authController.liveUser.value!.fullName}',
                          size: 20,
                          spacing: -0.1,
                          fontWeight: FontWeight.w700,
                          colors: AppColor().filledTextField,
                        );
                }),
              ),
              const Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/svgs/streak.svg',
                  ),
                  const Gap(5),
                  Obx(() {
                    return _authController.liveUser.value == null
                        ? CircularProgressIndicator(
                            color: AppColor().filledTextField,
                          )
                        : customDescriptionText(
                            // '5',
                            _authController.liveUser.value!.streak == null
                                ? '0'
                                : _authController.liveUser.value!.streak
                                    .toString(),
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            colors: AppColor().textColor,
                          );
                  }),
                  const Gap(5),
                  customDescriptionText(
                    'Streak',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    colors: AppColor().lightTextColor,
                  ),
                  const Gap(10),
                  /////
                  Container(
                    height: 15,
                    width: 1.5,
                    color: AppColor().lightTextColor,
                  ),
                  /////
                  const Gap(10),
                  SvgPicture.asset(
                    'assets/svgs/calender.svg',
                  ),
                  const Gap(5),
                  Obx(() {
                    return _authController.liveUser.value == null
                        ? Container()
                        : customDescriptionText(
                            // '20',
                            _authController.liveUser.value!.weeks == null
                                ? '0'
                                : _authController.liveUser.value!.weeks
                                    .toString(),
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            colors: AppColor().textColor,
                          );
                  }),
                  const Gap(5),
                  customDescriptionText(
                    'Weeks',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    colors: AppColor().lightTextColor,
                  ),
                ],
              ),
              const Gap(20),
              Stack(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: GestureDetector(
                      onTap: () {
                        if (kDebugMode) {
                          print('Clicking quote');
                          print(
                              'quote id is ${_quoteContoller.allQuotes.last.id!}');
                        }
                        _quoteContoller.joinedOrNot(
                          _authController.liveUser.value!.username!,
                          _quoteContoller.allQuotes.last.groupId!,
                          _quoteContoller.allQuotes.last.dailyQuote!,
                        );
                        _quoteContoller
                            .viewPost(_quoteContoller.allQuotes.last.id!);
                        Get.to(
                          () => QuoteDetails(
                            groupId: _quoteContoller.allQuotes.last.groupId!,
                            groupName:
                                _quoteContoller.allQuotes.last.dailyQuote!,
                            userName: _authController.liveUser.value!.username!,
                            userImage:
                                _authController.liveUser.value!.profilePic!,
                            assetName: _authController
                                        .liveUser.value!.profilePic ==
                                    null
                                ? 'assets/images/placeholder.png'
                                : _authController.liveUser.value!.profilePic!,
                          ),
                          // transition: Transition.downToUp,
                        );
                      },
                      child: Hero(
                        tag: "img",
                        child: SvgPicture.asset(
                          'assets/svgs/quote.svg',
                          height: MediaQuery.of(context).size.height * 0.2,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 30,
                    left: 70,
                    right: 70,
                    child: Column(
                      children: [
                        StreamBuilder(
                            stream: _quoteContoller.getDailyQuote(),
                            builder: (context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data != null) {
                                  return Center(
                                    child: customDescriptionText(
                                      snapshot.data!.docs.last
                                          .data()!['dailyQuote']
                                          .toString(),
                                      // snapshot.hasData.toString(),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      textAlign: TextAlign.center,
                                      colors: AppColor().whiteColor,
                                    ),
                                  );
                                } else if (snapshot.data == null) {
                                  return SvgPicture.asset(
                                    'assets/svgs/fluent_tap-single-48-filled.svg',
                                  );
                                } else {
                                  return customDescriptionText(
                                    'No Quote Today',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    textAlign: TextAlign.center,
                                    colors: AppColor().whiteColor,
                                  );
                                }
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(
                                      color: AppColor().primaryColor),
                                );
                              }
                            }),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/svgs/eye.svg',
                  ),
                  const Gap(5),
                  Obx(() {
                    return customDescriptionText(
                      _quoteContoller.allQuotes.isNotEmpty &&
                              _quoteContoller.allQuotes.last.views != null
                          ? _quoteContoller.allQuotes.last.views!.length
                              .toString()
                          : "0",
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      colors: AppColor().textColor,
                    );
                  }),
                  const Gap(10),
                  SvgPicture.asset(
                    'assets/svgs/messages.svg',
                  ),
                  const Gap(5),
                  customDescriptionText(
                    _quoteContoller.allQuotes.isNotEmpty &&
                            _quoteContoller.allQuotes.last.reply != null
                        ? _quoteContoller.allQuotes.last.reply!.length
                            .toString()
                        : "0",
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    colors: AppColor().textColor,
                  ),
                  const Gap(10),
                  SvgPicture.asset(
                    'assets/svgs/share.svg',
                  ),
                  const Gap(5),
                  Obx(() {
                    return customDescriptionText(
                      _quoteContoller.allQuotes.isNotEmpty &&
                              _quoteContoller.allQuotes.last.share != null
                          ? _quoteContoller.allQuotes.last.share!.length
                              .toString()
                          : "0",
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      colors: AppColor().textColor,
                    );
                  }),
                ],
              ),
              const Gap(20),
              Divider(
                thickness: 1,
                indent: 50,
                endIndent: 50,
                color: AppColor().lightTextColor.withOpacity(0.3),
              ),
              const Gap(20),
              GestureDetector(
                onTap: () => Get.to(() => const CellsScreen()),
                child: Row(
                  children: [
                    customDescriptionText(
                      'Popular cells'.toUpperCase(),
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
              ),
              const Gap(20),
              Obx(() {
                if (cellContoller.cellStatus == CellStatus.LOADING) {
                  return customDescriptionText('No Available  Cell');
                } else {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.horizontal,
                      // itemCount: imageName.length,
                      itemCount: cellContoller.allAvailableCell.length > 4
                          ? 4
                          : cellContoller.allAvailableCell.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = cellContoller.allAvailableCell[index];
                        if (kDebugMode) {
                          print('Cell is now ${item.groupName!.length}');
                          print("group id for cell is ${item.groupId}");
                          print(
                              "memeber lenght for cell is ${item.members!.length}");
                        }
                        return recommendedCells(
                          groupId: item.groupId,
                          groupName: item.groupName,
                          admin: item.admin,
                          colors: colorList[index],
                          assetName: item.profilePic == null
                              ? 'assets/svgs/bank.svg'
                              : item.profilePic!,
                          userName: _authController.liveUser.value!.username!,
                          memberId: item.members,
                        );
                      },
                    ),
                  );
                }
              }),
              const Gap(30),
              Row(
                children: [
                  customDescriptionText(
                    'Recent quotes'.toUpperCase(),
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
                return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      itemCount: _quoteContoller.allQuotes.length > 4
                          ? 4
                          : _quoteContoller.allQuotes.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = _quoteContoller.allQuotes[index];
                        if (kDebugMode) {
                          print('Like is now ${item.likes!.length}');
                        }
                        return recentQuotes(
                          assetName: imageName[index],
                          quoteModel: item,
                        );
                      },
                    ));
                // }
              }),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector recommendedCells({
    Color? colors,
    String? groupId,
    String? admin,
    String? groupName,
    String? assetName,
    String? userName,
    List<String>? memberId,
  }) {
    cellContoller.joinedOrNot(
      userName!,
      groupId!,
      groupName!,
    );

    return GestureDetector(
      onTap: () async {
        if (kDebugMode) {
          print('Joining Group');
        }

        cellContoller.memberAdd(groupId);

        Get.to(
          () => ChatPage(
            groupId: groupId,
            groupName: groupName,
            userName: userName,
            member: memberId!,
            admin: admin!,
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
                groupName,
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

  GestureDetector recentQuotes({
    QuoteModel? quoteModel,
    String? assetName,
    String? userImage,
  }) {
    final random = Random();
    return GestureDetector(
      onTap: () {
        if (kDebugMode) {
          print('selected quote id is ${_quoteContoller.allQuotes.last.id!}');
          print('Joining Quote Chat');
        }

        _quoteContoller.joinedOrNot(
          _authController.liveUser.value!.username!,
          quoteModel!.groupId!,
          quoteModel.dailyQuote!,
        );

        // View Quote Count
        _quoteContoller.viewPost(quoteModel.id!);

        Get.to(
          () => SelectedQuoteDetails(
            quoteId: quoteModel.id!,
            groupId: quoteModel.groupId!,
            quoteText: quoteModel.dailyQuote!,
            userName: _authController.liveUser.value!.username!,
            userImage: _authController.liveUser.value!.profilePic!,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.25,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: MediaQuery.of(context).size.height * 0.2,
                decoration: BoxDecoration(
                  color: colorList[random.nextInt(colorList.length)],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: customTitleText(
                    quoteModel!.dailyQuote!,
                    size: 16,
                    textOverflow: TextOverflow.clip,
                    colors: AppColor().whiteColor,
                  ),
                ),
              ),
              const Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Gap(5),
                  SvgPicture.asset(
                    'assets/svgs/eye.svg',
                  ),
                  const Gap(5),
                  customDescriptionText(
                    quoteModel.views!.length == null
                        ? '0'
                        : quoteModel.views!.length.toString(),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    colors: AppColor().textColor,
                  ),
                  const Gap(10),
                  SvgPicture.asset(
                    'assets/svgs/messages.svg',
                  ),
                  const Gap(5),
                  customDescriptionText(
                    quoteModel.reply!.length == null
                        ? '0'
                        : quoteModel.reply!.length.toString(),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    colors: AppColor().textColor,
                  ),
                  const Gap(10),
                  SvgPicture.asset(
                    'assets/svgs/share.svg',
                  ),
                  const Gap(5),
                  customDescriptionText(
                    quoteModel.share!.length == null
                        ? '0'
                        : quoteModel.share!.length.toString(),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    colors: AppColor().textColor,
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
