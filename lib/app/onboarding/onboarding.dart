// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:agora_care/app/authentication/email_page.dart';
import 'package:agora_care/app/authentication/login_page.dart';
import 'package:agora_care/core/constant/colors.dart';
import 'package:agora_care/core/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../helper/helper_function.dart';
import '../home/home_screen.dart';

// ignore: use_key_in_widget_constructors
class Onboarding extends StatefulWidget {
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  // ignore: unused_field
  Timer? _timer;
  // final controller = Get.find<AuthServices>();
  bool isSignedIn = false;

  @override
  void initState() {
    _timer = Timer(const Duration(milliseconds: 3000), () {
      // if (controller.status == Status.IsFirstTime) {
      //   Get.off(() => OnboardAuth(locations, context));
      // } else if (controller.status == Status.Authenticated) {
      //   Get.off(() => const UserNavScreen());
      // } else {
      //   _save('0');
      // Get.off(() => const SignIn());
      //   }
    });
    getUserLogggedInStatus();
    super.initState();
  }

  getUserLogggedInStatus() async {
    await HelperFunction.getUserLogggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          isSignedIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor().primaryColor,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: isSignedIn
          ? const HomeScreen()
          : Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: AppColor().primaryColor,
                image: const DecorationImage(
                    image: AssetImage('assets/images/Onboarding-home.png'),
                    fit: BoxFit.cover),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Expanded(child: SizedBox()),
                    Container(
                      decoration: BoxDecoration(
                          color: AppColor().primaryColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(
                          "assets/svgs/logo.svg",
                        ),
                      ),
                    ),
                    customDescriptionText(
                      '“Emotions are a big part of',
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      colors: AppColor().whiteColor,
                    ),
                    customDescriptionText(
                      'what makes us human.”',
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      colors: AppColor().whiteColor,
                    ),
                    const Expanded(child: SizedBox()),
                    CustomFillButton(
                      buttonText: 'Create an account',
                      textColor: AppColor().primaryColor,
                      buttonColor: AppColor().button1Color,
                      borderRadius: BorderRadius.circular(50),
                      width: MediaQuery.of(context).size.width * 0.6,
                      onTap: () {
                        Get.to(() => const EmailPage());
                      },
                    ),
                    const Gap(20),
                    CustomFillButton(
                      buttonText: 'Login',
                      textColor: AppColor().whiteColor,
                      buttonColor: AppColor().button2Color,
                      borderRadius: BorderRadius.circular(50),
                      width: MediaQuery.of(context).size.width * 0.6,
                      onTap: () {
                        Get.to(() => const LoginPage());
                      },
                    ),
                    const Gap(50),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text:
                              'By tapping Create an account and using Agora, ',
                          style: TextStyle(
                            fontFamily: 'HK GROTESK',
                            color: AppColor().whiteColor,
                            fontSize: 14,
                          ),
                          children: [
                            TextSpan(
                              text: 'you agree to our ',
                              style: TextStyle(
                                fontFamily: 'HK GROTESK',
                                color: AppColor().whiteColor,
                                fontSize: 14,
                              ),
                            ),
                            TextSpan(
                              text: 'Terms ',
                              style: TextStyle(
                                fontFamily: 'HK GROTESK',
                                color: AppColor().whiteColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: 'and ',
                              style: TextStyle(
                                fontFamily: 'HK GROTESK',
                                color: AppColor().whiteColor,
                                fontSize: 14,
                              ),
                            ),
                            TextSpan(
                              text: 'Privacy Policy.',
                              style: TextStyle(
                                fontFamily: 'HK GROTESK',
                                color: AppColor().whiteColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ]),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
