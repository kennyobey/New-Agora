// ignore_for_file: library_private_types_in_public_api

import 'package:agora_care/core/constant/colors.dart';
import 'package:agora_care/core/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({Key? key}) : super(key: key);

  @override
  _SupportPageState createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor().primaryColor,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: AppColor().primaryColor,
          image: const DecorationImage(
              image: AssetImage('assets/images/need_help.png'),
              fit: BoxFit.cover),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(20),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: AppColor().whiteColor,
                      ),
                    ),
                  ],
                ),
                const Gap(150),
                customTitleText(
                  'Need help?',
                  size: 32,
                  fontWeight: FontWeight.w700,
                  colors: AppColor().whiteColor,
                ),
                const Gap(10),
                Flexible(
                  child: customDescriptionText(
                    'We\'re here to help. Our support team are available between 9-5:30pm Monday-Friday.',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    colors: AppColor().whiteColor,
                  ),
                ),
                const Gap(30),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/svgs/streak.svg',
                      height: 16,
                      color: const Color(0xFF77E6B6),
                    ),
                    const Gap(10),
                    customDescriptionText(
                      'We aim to reply within few mins',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      colors: AppColor().whiteColor,
                    ),
                  ],
                ),
                const Gap(100),
                Divider(
                  thickness: 1,
                  color: AppColor().whiteColor,
                ),
                const Gap(100),
                customTitleText(
                  'Help center',
                  size: 18,
                  fontWeight: FontWeight.w700,
                  colors: const Color(0xFF77E6B6),
                ),
                const Gap(10),
                Row(
                  children: [
                    Expanded(
                      child: customDescriptionText(
                        'There’s a pretty good chance your question is among them, and it’s the fastest way to get answers',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        colors: AppColor().whiteColor,
                      ),
                    ),
                    const Gap(15),
                    GestureDetector(
                      onTap: () {
                        // Get.to(()=> const HelpCenter());
                      },
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: AppColor().whiteColor,
                        size: 16,
                      ),
                    ),
                  ],
                ),
                const Gap(50),
              ]),
        ),
      ),
    );
  }
}
