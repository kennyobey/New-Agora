// ignore_for_file: override_on_non_overriding_member

import 'package:agora_care/app/authentication/%20verify_email_page.dart';
import 'package:agora_care/core/constant/colors.dart';
import 'package:agora_care/core/customWidgets.dart';
import 'package:agora_care/core/custom_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'auth_controller.dart';

class EmailPage extends StatefulWidget {
  const EmailPage({Key? key}) : super(key: key);

  @override
  State<EmailPage> createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passworController = TextEditingController();
  @override
  void iniState() {
    //_emailController = TextEditingController();
    // _passworController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passworController.dispose();
    super.dispose();
  }

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
              'What’s your email address',
              size: 20,
              spacing: -0.1,
              fontWeight: FontWeight.w800,
              colors: AppColor().filledTextField,
            ),
            const Gap(10),
            customDescriptionText(
              'We’ll send you a verification code so make',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              colors: AppColor().lightTextColor,
            ),
            customDescriptionText(
              'sure it’s a valid email',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              colors: AppColor().lightTextColor,
            ),
            const Gap(20),
            CustomTextField(
              textEditingController: _emailController,
              label: 'Email Address',
              hint: 'Enter email address',
              keyType: TextInputType.emailAddress,
              validatorText: '** Field cannot be empty',
              color: AppColor().lightTextColor,
            ),
            const Gap(20),
            CustomTextField(
              textEditingController: _passworController,
              label: 'Enter Password',
              hint: 'Enter password',
              keyType: TextInputType.emailAddress,
              validatorText: '** Field cannot be empty',
              color: AppColor().lightTextColor,
            ),
            const Expanded(child: SizedBox()),
            CustomFillButton(
              buttonText: 'Send code',
              textColor: AppColor().button1Color,
              buttonColor: AppColor().primaryColor,
              onTap: () async {
                // final email = _emailController.text.trim();
                // final password = _passworController.text.trim();
                // await FirebaseAuth.instance.createUserWithEmailAndPassword(
                //     email: email, password: password);

                print("sign up");

                final userCredential = AuthContoller.instance.register(
                  _emailController.text.trim(),
                  _passworController.text.trim(),
                );

                // if (kDebugMode); {
                //   print("sign up");
                // };
                // AuthContoller.instance.register
                //   _emailController.text.trim(),
                //   _passworController.text.trim(),
                // );

                Get.to(() => const VerifyEmailPage());
              },
            ),
            const Gap(50),
          ],
        ),
      ),
    );
  }
}
