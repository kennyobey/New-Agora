// ignore_for_file: override_on_non_overriding_member, use_build_context_synchronously

import 'package:agora_care/app/authentication/%20verify_email_page.dart';
import 'package:agora_care/app/authentication/welcome_page.dart';
import 'package:agora_care/app/home/home_screen.dart';
import 'package:agora_care/core/constant/colors.dart';
import 'package:agora_care/core/customWidgets.dart';
import 'package:agora_care/core/custom_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../core/widget.dart';
import '../../helper/helper_function.dart';
import '../../services/auth_controller.dart';
import 'login_page.dart';

class EmailPage extends StatefulWidget {
  const EmailPage({Key? key}) : super(key: key);

  @override
  State<EmailPage> createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  final AuthController _authContoller = AuthController();
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
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
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppColor().whiteColor,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : Form(
              key: formKey,
              child: Container(
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
                      onChanged: (val) {
                        setState(() {
                          email = val;
                        });
                      },
                    ),
                    const Gap(20),
                    CustomPassWord(
                      textEditingController: _passworController,
                      label: 'Enter Password',
                      hint: 'Enter password',
                      keyType: TextInputType.emailAddress,
                      validatorText: '** Field cannot be empty',
                      color: AppColor().lightTextColor,
                      onChanged: (val) {
                        setState(() {
                          password = val;
                        });
                      },
                      obscureText: true,
                    ),
                    const Gap(20),
                    Text.rich(TextSpan(
                      text: "Already have an account? ",
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                      children: <TextSpan>[
                        TextSpan(
                            text: "Sign In",
                            style: const TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                nextScreen(context, const LoginPage());
                              }),
                      ],
                    )),
                    const Expanded(child: SizedBox()),
                    CustomFillButton(
                      buttonText: 'Send code',
                      textColor: AppColor().button1Color,
                      buttonColor: AppColor().primaryColor,
                      onTap: () async {
                        register();

                        print("sign up");

                        //Get.to(() => const VerifyEmailPage());
                      },
                    ),
                    const Gap(50),
                  ],
                ),
              ),
            ),
    );
  }

  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      final userCredential = AuthController.instance
          .registerUserWithEmailandPassword(
        _emailController.text.trim(),
        _passworController.text.trim(),
      )
          .then((value) async {
        if (value == true) {
          print(UserCredential);
          // saving the shared preference
          await HelperFunction.saveUserLoggedInStatus(true);
          await HelperFunction.saveUserEmailSF(email);
          //await HelperFunction.saveUserNameSF(fullName);
          nextScreenReplace(context, const WelComePage());
        } else {
          showSnackbar(context, Colors.red, value);
        }
      });
    }
  }
}
