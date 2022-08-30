// ignore_for_file: unnecessary_null_comparison

import 'package:agora_care/app/home/quote_details.dart';
import 'package:agora_care/core/constant/cells.dart';
import 'package:agora_care/core/constant/colors.dart';
import 'package:agora_care/core/constant/members.dart';
import 'package:agora_care/core/customWidgets.dart';
import 'package:agora_care/services/auth_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen>
    with TickerProviderStateMixin {
  ScrollController? _scrollController;
  TabController? _tabController;
  final _authContoller = Get.find<AuthControllers>();
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
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;

    if (kDebugMode) {
      print("testing user is ${_authContoller.liveUser.value.toJson()}");
    }
    return Scaffold(
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(30),
          ),
          color: AppColor().addCellColor,
        ),
        width: 150,
        height: 60,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.add),
              color: Colors.white,
              iconSize: 30,
            ),
            customDescriptionText(
              "Add Cell",
              fontSize: 14,
              fontWeight: FontWeight.w700,
              colors: AppColor().whiteColor,
            ),
          ],
        ),
      ),
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
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(20),
              Center(
                child: Obx(() {
                  return customTitleText(
                    'Good afternoon, ${_authContoller.liveUser.value.fullName}',
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
                    return customDescriptionText(
                      // '5',
                      _authContoller.liveUser.value.streak == null
                          ? '0'
                          : _authContoller.liveUser.value.streak.toString(),
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
                  customDescriptionText(
                    '20',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    colors: AppColor().textColor,
                  ),
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
                        Get.to(
                          () => const QuoteDetails(),
                          transition: Transition.downToUp,
                        );
                      },
                      child: SvgPicture.asset(
                        'assets/svgs/quote.svg',
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 60,
                    left: 70,
                    right: 70,
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          'assets/svgs/fluent_tap-single-48-filled.svg',
                          // height: MediaQuery.of(context).size.height * 0.2,
                          // width: MediaQuery.of(context).size.width,
                        ),
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
                  customDescriptionText(
                    '14,000',
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
                    '400',
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
                    '40',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    colors: AppColor().textColor,
                  ),
                ],
              ),
              const Gap(20),
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
                        child: Container(
                            margin: const EdgeInsets.only(bottom: 0, left: 0),
                            child: TabBar(
                              indicatorPadding: const EdgeInsets.all(0),
                              indicatorSize: TabBarIndicatorSize.label,
                              labelPadding: const EdgeInsets.only(right: 20),
                              controller: _tabController,
                              isScrollable: true,
                              // indicator: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(10),
                              //     boxShadow: [
                              //       BoxShadow(
                              //           color: Colors.grey.withOpacity(0.2),
                              //           blurRadius: 7,
                              //           offset: const Offset(0, 0))
                              //     ]),
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
                            )),
                      ),
                    )
                  ];
                },
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    ListView.builder(
                        // itemCount: books == null ? 0 : books!.length,
                        itemBuilder: (_, i) {
                      return Container(
                        margin: const EdgeInsets.only(
                            left: 0, right: 0, top: 10, bottom: 10),
                        child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Row(children: [
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: const [
                                  Cells(
                                      title: "Cephas",
                                      members: "3000 members",
                                      time: "Last activity: 7th May 2022"),
                                ],
                              )
                            ])),
                      );
                    }),
                    ListView.builder(
                        // itemCount: books == null ? 0 : books!.length,
                        itemBuilder: (_, i) {
                      return Container(
                        margin: const EdgeInsets.only(
                            left: 0, right: 0, top: 10, bottom: 10),
                        child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Row(children: [
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: const [
                                  Members(
                                      title: "Kehinde",
                                      active: "Active 19hrs ago",
                                      streak: "16 streak",
                                      weeks: "4 weeks")
                                ],
                              )
                            ])),
                      );
                    }),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.20,
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      (orientation == Orientation.landscape)
                                          ? 2
                                          : 2),
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.horizontal,
                          itemCount: imageName.length,
                          itemBuilder: (BuildContext context, int index) {
                            return recentQuotes(
                              assetName: imageName[index],
                              views: '14,000',
                              messages: '400',
                              shares: '40',
                            );
                          },
                        )),
                  ],
                ),
              ))
              // Row(
              //   children: [
              //     customDescriptionText(
              //       'Popular cells'.toUpperCase(),
              //       fontSize: 12,
              //       fontWeight: FontWeight.w700,
              //       colors: AppColor().filledTextField,
              //     ),
              //     const Gap(5),
              //     SvgPicture.asset(
              //       'assets/svgs/arrow_right.svg',
              //     ),
              //   ],
              // ),
              // const Gap(20),
              // SizedBox(
              //   height: MediaQuery.of(context).size.height * 0.1,
              //   child: ListView.builder(
              //     padding: EdgeInsets.zero,
              //     scrollDirection: Axis.horizontal,
              //     itemCount: colorList.length,
              //     itemBuilder: (BuildContext context, int index) {
              //       return recommendedCells(
              //         colors: colorList[index],
              //         title: 'Cephas',
              //         assetName: 'assets/svgs/bank.svg',
              //       );
              //     },
              //   ),
              // ),
              // const Gap(30),
              // Row(
              //   children: [
              //     customDescriptionText(
              //       'Recent quotes'.toUpperCase(),
              //       fontSize: 12,
              //       fontWeight: FontWeight.w700,
              //       colors: AppColor().filledTextField,
              //     ),
              //     const Gap(5),
              //     SvgPicture.asset(
              //       'assets/svgs/arrow_right.svg',
              //     ),
              //   ],
              // ),
              // SizedBox(
              //   height: MediaQuery.of(context).size.height * 0.25,
              //   child: ListView.builder(
              //     padding: EdgeInsets.zero,
              //     scrollDirection: Axis.horizontal,
              //     itemCount: imageName.length,
              //     itemBuilder: (BuildContext context, int index) {
              //       return recentQuotes(
              //         assetName: imageName[index],
              //         views: '14,000',
              //         messages: '400',
              //         shares: '40',
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

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
    String? views,
    String? shares,
    String? messages,
    String? assetName,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.25,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(assetName!),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10),
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
                  views!,
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
                  messages!,
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
                  shares!,
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
