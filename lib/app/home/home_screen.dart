// ignore_for_file: unnecessary_null_comparison

import 'package:agora_care/app/cells/cell_screen.dart';
import 'package:agora_care/app/quote/quote_details.dart';
import 'package:agora_care/core/constant/colors.dart';
import 'package:agora_care/core/customWidgets.dart';
import 'package:agora_care/services/auth_controller.dart';
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
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("testing user is ${_authContoller.liveUser.value.toJson()}");
      print("testing user admin is ${_authContoller.liveUser.value.admin}");
    }
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
                  Obx(() {
                    return customDescriptionText(
                      // '20',
                      _authContoller.liveUser.value.weeks == null
                          ? '0'
                          : _authContoller.liveUser.value.weeks.toString(),
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
                        customDescriptionText(
                          '“Be yourself everyone else is already taken.”',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          textAlign: TextAlign.center,
                          colors: AppColor().whiteColor,
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
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.horizontal,
                  itemCount: colorList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return recommendedCells(
                      colors: colorList[index],
                      title: 'Cephas',
                      assetName: 'assets/svgs/bank.svg',
                    );
                  },
                ),
              ),
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
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                child: ListView.builder(
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
                ),
              ),
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
