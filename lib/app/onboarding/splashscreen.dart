// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:agora_care/app/onboarding/onboarding.dart';
import 'package:agora_care/core/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../helper/helper_function.dart';
import '../home/home_screen.dart';

// ignore: use_key_in_widget_constructors
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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
      Get.off(() => Onboarding());
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
                  ],
                ),
              ),
            ),
    );
  }
}
