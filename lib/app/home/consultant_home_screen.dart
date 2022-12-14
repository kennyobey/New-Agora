// ignore_for_file: unnecessary_null_comparison

import 'dart:math';

import 'package:agora_care/app/model/user_list_model.dart';
import 'package:agora_care/app/quote/quote_details.dart';
import 'package:agora_care/core/constant/cells.dart';
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
import 'package:intl/intl.dart';

class ConsultantHome extends StatefulWidget {
  const ConsultantHome({Key? key}) : super(key: key);

  @override
  State<ConsultantHome> createState() => _ConsultantHomeState();
}

class _ConsultantHomeState extends State<ConsultantHome>
    with TickerProviderStateMixin {
  final _authController = Get.find<AuthControllers>();
  final cellController = Get.find<CellControllers>();

  final _quoteContoller = Get.find<QuoteControllers>();

  String userName = "";
  String email = "";
  String groupName = "";
  Stream? groups;
  Stream? members;

  ScrollController? _scrollController;
  TabController? _tabController;
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
    // _authController.readUserList();
    _quoteContoller.getQuotes();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController();
  }

  // string manipulation
  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  gettingUserData() async {
    HelperFunction.getUserEmailFromSF().then((value) {
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

  String greeting() {
    final greetTime = DateTime.now().hour;
    if (greetTime < 12) {
      return 'Morning';
    }
    if (greetTime < 17) {
      return 'Afternoon';
    }
    return 'Evening';
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;

    if (kDebugMode) {
      print("testing user is ${_authController.liveUser.value!.toJson()}");
      print("testing consultant is ${_authController.liveUser.value!.role}");
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor().whiteColor,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: Container(
        color: AppColor().whiteColor,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(20),
            Center(
              child: Obx(() {
                return (_authController.liveUser.value!.role == null)
                    ? customTitleText(
                        'No Name Yet',
                        size: 20,
                        spacing: -0.1,
                        fontWeight: FontWeight.w700,
                        colors: AppColor().filledTextField,
                      )
                    : Row(
                        children: [
                          customTitleText(
                            'Good ${greeting()},',
                            size: 20,
                            spacing: -0.1,
                            fontWeight: FontWeight.w700,
                            colors: AppColor().filledTextField,
                          ),
                          const Gap(5),
                          customTitleText(
                            '${_authController.liveUser.value!.fullName}',
                            size: 20,
                            spacing: -0.1,
                            fontWeight: FontWeight.w700,
                            colors: AppColor().filledTextField,
                            width: MediaQuery.of(context).size.width * 0.5,
                            textOverflow: TextOverflow.ellipsis,
                          ),
                        ],
                      );
              }),
            ),
            const Gap(20),
            InkWell(
              onTap: () {
                if (kDebugMode) {
                  print("post quote card");
                }
                Get.to(
                  () => QuoteDetails(
                    dailyQuote: _quoteContoller.allQuotes.last.dailyQuote!,
                    groupId: _quoteContoller.allQuotes.last.groupId!,
                    groupName: _quoteContoller.allQuotes.last.dailyQuote!,
                    userName: _authController.liveUser.value!.username!,
                    userImage: _authController.liveUser.value!.profilePic!,
                    assetName:
                        _authController.liveUser.value!.profilePic == null
                            ? 'assets/images/placeholder.png'
                            : _authController.liveUser.value!.profilePic!,
                  ),
                  // transition: Transition.downToUp,
                );
              },
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.2,
                    decoration: BoxDecoration(
                      color: AppColor().primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        StreamBuilder(
                          stream: _quoteContoller.getDailyQuote(),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data != null &&
                                  snapshot.data!.docs.isNotEmpty) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    customDescriptionText(
                                      snapshot.data!.docs.last
                                          .data()!['dailyQuote']
                                          .toString(),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      textAlign: TextAlign.center,
                                      colors: AppColor().whiteColor,
                                    ),
                                    const Gap(20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/svgs/fluent_tap-single-48-filled.svg',
                                          height: 10,
                                        ),
                                        const Gap(5),
                                        customDescriptionText(
                                          'TAP to join the conversation'
                                              .toUpperCase(),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          textAlign: TextAlign.center,
                                          colors: AppColor()
                                              .whiteColor
                                              .withOpacity(0.4),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              } else {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    customDescriptionText(
                                      'No Quote Today',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      textAlign: TextAlign.center,
                                      colors: AppColor().whiteColor,
                                    ),
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
                          },
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 30,
                    child: SvgPicture.asset('assets/svgs/quoteTag.svg'),
                  ),
                ],
              ),
            ),
            const Gap(10),
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
                Obx(() {
                  return customDescriptionText(
                    _quoteContoller.allQuotes.isNotEmpty &&
                            _quoteContoller.allQuotes.last.reply != null
                        ? _quoteContoller.allQuotes.last.reply!.toString()
                        : "0",
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    colors: AppColor().textColor,
                  );
                }),
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
            const Gap(5),
            Divider(
              thickness: 1,
              indent: 50,
              endIndent: 50,
              color: AppColor().lightTextColor.withOpacity(0.3),
            ),
            Expanded(
              child: NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder: (BuildContext context, bool isScroll) {
                  return [
                    SliverAppBar(
                      stretch: true,
                      pinned: true,
                      automaticallyImplyLeading: false,
                      backgroundColor: Colors.white,
                      bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(10),
                        child: TabBar(
                          padding: const EdgeInsets.only(bottom: 10),
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorColor: AppColor().primaryColor,
                          controller: _tabController,
                          isScrollable: true,
                          tabs: [
                            customDescriptionText(
                              "Cells",
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              colors: AppColor().lightTextColor,
                            ),
                            customDescriptionText(
                              "Members",
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              colors: AppColor().lightTextColor,
                            ),
                            customDescriptionText(
                              "Qoutes",
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              colors: AppColor().lightTextColor,
                            ),
                          ],
                        ),
                      ),
                    )
                  ];
                },
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    //CELLS LIST
                    Obx(() {
                      if (cellController.cellStatus == CellStatus.LOADING) {
                        return customDescriptionText('No Available  Cell');
                      } else {
                        return SizedBox(
                          child: ListView.builder(
                              itemCount: cellController.allAvailableCell.length,
                              itemBuilder: (BuildContext context, int index) {
                                final item =
                                    cellController.allAvailableCell[index];
                                final member = _quoteContoller.allQuotes.length;
                                return Container(
                                  margin: const EdgeInsets.only(
                                      left: 0, right: 0, top: 10, bottom: 10),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Cells(
                                              cellQuote: item.cellQuote!,
                                              members: member == null
                                                  ? 'No members yet'
                                                  : member.toString(),
                                              // time:
                                              //     "Last activity: 7th May 2022",
                                              time: DateFormat('MMM dd yyy')
                                                  .format(DateTime.parse(item
                                                      .createdAt
                                                      .toString())),
                                              groupId: item.groupId,
                                              groupName: item.groupName,
                                              memberId: item.members,
                                              userName: _authController
                                                  .liveUser.value!.username!,
                                              assetName: 'assets/svgs/bank.svg',
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        );
                      }
                    }),
                    //MEMBER LIST
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: StreamBuilder<List<UserList>>(
                          stream: _authController.readUserList(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return customDescriptionText('Error');
                            } else if (snapshot.hasData) {
                              if (snapshot.data != null ||
                                  snapshot.data!.isNotEmpty) {
                                final myuser = snapshot.data!;
                                return ListView(
                                  children: myuser.map(buildUser).toList(),
                                );
                              } else {
                                return customDescriptionText('No members yet');
                              }
                            } else {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: AppColor().primaryColor,
                                ),
                              );
                            }
                          }),
                    ),
                    //QUOTE LIST
                    Obx(() {
                      return GridView.builder(
                        padding: EdgeInsets.zero,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                (orientation == Orientation.landscape) ? 2 : 2),
                        scrollDirection: Axis.vertical,
                        // itemCount: imageName.length,
                        itemCount: _quoteContoller.allQuotes.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = _quoteContoller.allQuotes[index];
                          return recentQuotes(
                            quote: item.dailyQuote,
                            assetName: imageName[index],
                            views: item.likes!.length.toString(),
                            messages: item.reply!.toString(),
                            shares: item.share!.length.toString(),
                          );
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildUser(UserList user) => ListTile(
        leading: Image.asset(
          'assets/images/chatPic.png',
          height: 50,
          width: 50,
        ),
        title: customTitleText(
          (user.username == null || user.username!.isEmpty)
              ? 'No username yet'
              : user.username!,
          size: 14,
          fontWeight: FontWeight.w700,
          colors: AppColor().lightTextColor,
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            customDescriptionText(
              'active',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              colors: AppColor().lightTextColor,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SvgPicture.asset(
                  'assets/svgs/streak.svg',
                ),
                const Gap(5),
                customDescriptionText(
                  user.streak == null
                      ? 'No streaks yet'
                      : '${user.streak!.toString()} streak',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  colors: AppColor().lightTextColor,
                ),
                const Gap(10),
                SvgPicture.asset(
                  'assets/svgs/calender.svg',
                ),
                const Gap(5),
                customDescriptionText(
                  user.weeks == null
                      ? 'User hasn\'t used a week'
                      : '${user.weeks!.toString()} weeks',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  colors: AppColor().lightTextColor,
                ),
              ],
            ),
          ],
        ),
      );

  GestureDetector recommendedCells({
    Color? colors,
    String? title,
    String? assetName,
  }) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                title!,
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

  Padding recentQuotes({
    String? quote,
    String? views,
    String? shares,
    String? messages,
    String? assetName,
  }) {
    final random = Random();
    return Padding(
      padding: const EdgeInsets.only(
        right: 10,
        bottom: 10,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.25,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              height: MediaQuery.of(context).size.height * 0.18,
              decoration: BoxDecoration(
                color: colorList[random.nextInt(colorList.length)],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: customTitleText(
                  quote!,
                  size: 16,
                  textAlign: TextAlign.center,
                  colors: AppColor().whiteColor,
                  textOverflow: TextOverflow.clip,
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
                  "$views",
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
                  "$messages",
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
                  "$shares",
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  colors: AppColor().textColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
