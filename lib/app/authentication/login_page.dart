import 'package:agora_care/app/home/nav_screen.dart';
import 'package:agora_care/core/constant/colors.dart';
import 'package:agora_care/core/customWidgets.dart';
import 'package:agora_care/core/custom_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor().whiteColor,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () => Get.back(),
              icon: Icon(
                CupertinoIcons.back,
                color: AppColor().filledTextField,
              ),
            ),
            const Gap(10),
            customTitleText(
              'Welcome! 👋',
              size: 32,
              spacing: -0.1,
              fontWeight: FontWeight.w800,
              colors: AppColor().filledTextField,
            ),
            const Gap(10),
            customDescriptionText(
              'Login to your account to proceed',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              colors: AppColor().lightTextColor,
            ),
            const Gap(20),
            CustomTextField(
              label: 'Email Address',
              hint: 'Enter email address',
              keyType: TextInputType.emailAddress,
              validatorText: '** Field cannot be empty',
              color: AppColor().lightTextColor,
            ),
            const Gap(20),
            CustomPassWord(
              label: 'Password',
              hint: 'Enter password',
              keyType: TextInputType.text,
              validatorText: '** Field cannot be empty',
              color: AppColor().lightTextColor,
            ),
            const Expanded(child: SizedBox()),
            CustomFillButton(
              buttonText: 'Proceed',
              textColor: AppColor().button1Color,
              buttonColor: AppColor().primaryColor,
              onTap: () {
                Get.to(() => const UserNavScreen());
              },
            ),
            const Gap(50),
          ],
        ),
      ),
    );
  }
}
