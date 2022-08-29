// ignore_for_file: use_build_context_synchronously, unused_local_variable, override_on_non_overriding_member, unused_field

import 'package:agora_care/app/authentication/email_page.dart';
import 'package:agora_care/app/home/nav_screen.dart';
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
import '../../services/database_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final AuthController _authContoller = AuthController();
  bool _isLoading = false;

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
      body: Form(
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
                obscureText: true,
                label: 'Password',
                hint: 'Enter password',
                keyType: TextInputType.text,
                validatorText: '** Field cannot be empty',
                color: AppColor().lightTextColor,
                onChanged: (val) {
                  setState(() {
                    password = val;
                  });
                },
              ),
              const Gap(20),
              Text.rich(TextSpan(
                text: "Don't have an account? ",
                style:
                    TextStyle(color: AppColor().lightTextColor, fontSize: 14),
                children: <TextSpan>[
                  TextSpan(
                      text: "Sign Up",
                      style: TextStyle(
                          color: AppColor().lightTextColor,
                          decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          nextScreen(context, const EmailPage());
                        }),
                ],
              )),
              const Expanded(child: SizedBox()),
              CustomFillButton(
                buttonText: 'Proceed',
                textColor: AppColor().button1Color,
                buttonColor: AppColor().primaryColor,
                onTap: () async {
                  if (kDebugMode) {
                    print("The email is $email");
                  }
                  final user = FirebaseAuth.instance.currentUser;
                  if (kDebugMode) {
                    print("The Use details are$user");
                  }
                  if (user!.emailVerified == true) {
                    return login();
                  } else {
                    Get.snackbar(
                        "Email Verification", "Go and verify your mail",
                        duration: const Duration(seconds: 5));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      final userCredential = AuthController.instance
          .loginWithUserNameandPassword(
        _emailController.text.trim(),
        _passworController.text.trim(),
      )
          .then((value) async {
        if (value == true) {
          await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
              .gettingUserData(email);
          if (kDebugMode) {
            print('User Email: $email');
          }

          // saving the values to our shared preferences
          await HelperFunction.saveUserLoggedInStatus(true);
          await HelperFunction.saveUserEmailSF(email);
          //await HelperFunction.saveUserNameSF(snapshot.docs[0]['fullName']);
          nextScreenReplace(context, const UserNavScreen());
        } else {
          showSnackbar(context, Colors.red, value);
        }
      });
    }
  }
}
