// ignore_for_file: file_names

import 'dart:async';

import 'package:agora_care/app/authentication/welcome_page.dart';
import 'package:agora_care/core/constant/colors.dart';
import 'package:agora_care/core/customWidgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
//import 'package:open_mail_app/open_mail_app.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final pinController = TextEditingController();
  String? pin;
  late final bool _isLoading = false;

  StreamController<ErrorAnimationType>? changePinErrorController;
  @override
  void initState() {
    changePinErrorController = StreamController<ErrorAnimationType>();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }

  final user = FirebaseAuth.instance.currentUser;
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
              'Verify it’s you',
              size: 20,
              spacing: -0.1,
              fontWeight: FontWeight.w800,
              colors: AppColor().filledTextField,
            ),
            const Gap(10),
            customDescriptionText(
              'Please check the link sent to your mail inbox or spam to verify your account',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              colors: AppColor().lightTextColor,
            ),
            customDescriptionText(
              user!.email ?? "",
              fontSize: 14,
              fontWeight: FontWeight.w700,
              colors: AppColor().lightTextColor,
            ),
            const Gap(10), // const Gap(50),
            Center(
              child: SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width * 1,
                child: PinCodeTextField(
                  controller: pinController,
                  length: 5,
                  obscureText: true,
                  obscuringCharacter: '*',
                  animationType: AnimationType.fade,
                  cursorColor: AppColor().blackColor,
                  keyboardType: TextInputType.number,
                  blinkDuration: const Duration(milliseconds: 150),
                  blinkWhenObscuring: true,
                  pinTheme: PinTheme(
                      inactiveColor: AppColor().lightTextColor.withOpacity(0.2),
                      activeColor: AppColor().primaryColor,
                      selectedColor: AppColor().primaryColor,
                      selectedFillColor: AppColor().button1Color,
                      inactiveFillColor: AppColor().boxColor,
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 60,
                      fieldWidth: 60,
                      activeFillColor:
                          AppColor().filledTextField.withOpacity(0.5)),
                  animationDuration: const Duration(milliseconds: 300),
                  backgroundColor: Colors.white,
                  enableActiveFill: true,
                  errorAnimationController: changePinErrorController,
                  onCompleted: (v) {
                    if (kDebugMode) {
                      print("Completed");
                    }
                  },
                  onChanged: (value) {
                    pin = value;
                    if (kDebugMode) {
                      print(value);
                    }
                  },
                  beforeTextPaste: (text) {
                    if (kDebugMode) {
                      print("Allowing to paste $text");
                    }
                    //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                    //but you can show anything you want here, like your pop up saying wrong paste format or etc
                    return true;
                  },
                  appContext: context,
                ),
              ),
            ),
            const Gap(20),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: 'Didn’t receive a link?, ',
                  style: TextStyle(
                    fontFamily: 'HK GROTESK',
                    color: AppColor().lightTextColor,
                    fontSize: 14,
                  ),
                  children: [
                    TextSpan(
                      text: 'Resend',
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'HK GROTESK',
                        color: Color(0xFFD27A00),
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          final user = FirebaseAuth.instance.currentUser;
                          if (user != null) {
                            await user.sendEmailVerification();
                          }
                          // Get.to(() => const PrivacyPolicy());
                          // navigate to desired screen or perform an action
                        },
                    ),
                  ]),
            ),
            const Gap(20),
            // CustomFillButton(
            //   buttonText: 'Go to your mail',
            //   textColor: AppColor().button1Color,
            //   buttonColor: AppColor().primaryColor,
            //   onTap: () async {
            //    // final result = await OpenMailApp.openMailApp();

            //     // If no mail apps found, show error
            //     if (!result.didOpen && !result.canOpen) {
            //       showNoMailAppsDialog(context);

            //       // iOS: if multiple mail apps found, show dialog to select.
            //       // There is no native intent/default app system in iOS so
            //       // you have to do it yourself.
            //     } else if (!result.didOpen && result.canOpen) {
            //       showDialog(
            //         context: context,
            //         builder: (_) {
            //           return MailAppPickerDialog(
            //             mailApps: result.options,
            //           );
            //         },
            //       );
            //     }
            //   },
            // ),
            const Expanded(child: SizedBox()),
            CustomFillButton(
              isLoading: _isLoading,
              buttonText: 'Proceed',
              textColor: AppColor().button1Color,
              buttonColor: AppColor().primaryColor,
              onTap: () async {
                Get.to(() => const WelComePage());
                // final user = FirebaseAuth.instance.currentUser;
                // print("The Use details are$user");
                // if (user?.emailVerified ?? false) {
                //   return Get.to(() => const WelComePage());
                // } else {
                //   Get.snackbar("Email Verification", "Go and verify your mail",
                //       duration: const Duration(seconds: 5));
                // }
              },
            ),
            const Gap(50),
          ],
        ),
      ),
    );
  }

  void showNoMailAppsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: customTitleText("Open Mail App"),
          content: customDescriptionText("No mail apps installed"),
          actions: [
            TextButton(
              child: customTitleText("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
}

// // ignore_for_file: file_names

// import 'dart:async';

// import 'package:agora_care/app/authentication/welcome_page.dart';
// import 'package:agora_care/core/constant/colors.dart';
// import 'package:agora_care/core/customWidgets.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:gap/gap.dart';
// import 'package:get/get.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';

// class VerifyEmailPage extends StatefulWidget {
//   const VerifyEmailPage({Key? key}) : super(key: key);

//   @override
//   State<VerifyEmailPage> createState() => _VerifyEmailPageState();
// }

// class _VerifyEmailPageState extends State<VerifyEmailPage> {
//   final pinController = TextEditingController();
//   String? pin;

//   StreamController<ErrorAnimationType>? changePinErrorController;
//   @override
//   void initState() {
//     changePinErrorController = StreamController<ErrorAnimationType>();
//     SystemChannels.textInput.invokeMethod('TextInput.hide');
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColor().whiteColor,
//         elevation: 0,
//         toolbarHeight: 0,
//       ),
//       body: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 24),
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             IconButton(
//               padding: EdgeInsets.zero,
//               onPressed: () => Get.back(),
//               icon: Icon(
//                 CupertinoIcons.back,
//                 color: AppColor().filledTextField,
//               ),
//             ),
//             const Gap(10),
//             customTitleText(
//               'Verify it’s you',
//               size: 20,
//               spacing: -0.1,
//               fontWeight: FontWeight.w800,
//               colors: AppColor().filledTextField,
//             ),
//             const Gap(10),
//             customDescriptionText(
//               'Please enter the code sent to the email',
//               fontSize: 14,
//               fontWeight: FontWeight.w400,
//               colors: AppColor().lightTextColor,
//             ),
//             customDescriptionText(
//               'mrjos***@gmail.com',
//               fontSize: 14,
//               fontWeight: FontWeight.w700,
//               colors: AppColor().lightTextColor,
//             ),
//             const Gap(50),
//             Center(
//               child: SizedBox(
//                 height: 60,
//                 width: MediaQuery.of(context).size.width * 1,
//                 child: PinCodeTextField(
//                   controller: pinController,
//                   length: 5,
//                   obscureText: true,
//                   obscuringCharacter: '*',
//                   animationType: AnimationType.fade,
//                   cursorColor: AppColor().blackColor,
//                   keyboardType: TextInputType.number,
//                   blinkDuration: const Duration(milliseconds: 150),
//                   blinkWhenObscuring: true,
//                   pinTheme: PinTheme(
//                       inactiveColor: AppColor().lightTextColor.withOpacity(0.2),
//                       activeColor: AppColor().primaryColor,
//                       selectedColor: AppColor().primaryColor,
//                       selectedFillColor: AppColor().button1Color,
//                       inactiveFillColor: AppColor().boxColor,
//                       shape: PinCodeFieldShape.box,
//                       borderRadius: BorderRadius.circular(5),
//                       fieldHeight: 60,
//                       fieldWidth: 60,
//                       activeFillColor:
//                           AppColor().filledTextField.withOpacity(0.5)),
//                   animationDuration: const Duration(milliseconds: 300),
//                   backgroundColor: Colors.white,
//                   enableActiveFill: true,
//                   errorAnimationController: changePinErrorController,
//                   onCompleted: (v) {
//                     if (kDebugMode) {
//                       print("Completed");
//                     }
//                   },
//                   onChanged: (value) {
//                     pin = value;
//                     if (kDebugMode) {
//                       print(value);
//                     }
//                   },
//                   beforeTextPaste: (text) {
//                     if (kDebugMode) {
//                       print("Allowing to paste $text");
//                     }
//                     //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
//                     //but you can show anything you want here, like your pop up saying wrong paste format or etc
//                     return true;
//                   },
//                   appContext: context,
//                 ),
//               ),
//             ),
//             const Gap(20),
//             RichText(
//               textAlign: TextAlign.center,
//               text: TextSpan(
//                   text: 'Didn’t receive a code?, ',
//                   style: TextStyle(
//                     fontFamily: 'HK GROTESK',
//                     color: AppColor().lightTextColor,
//                     fontSize: 14,
//                   ),
//                   children: [
//                     TextSpan(
//                       text: 'Resend',
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontFamily: 'HK GROTESK',
//                         color: Color(0xFFD27A00),
//                         fontWeight: FontWeight.bold,
//                         decoration: TextDecoration.underline,
//                       ),
//                       recognizer: TapGestureRecognizer()
//                         ..onTap = () {
//                           // Get.to(() => const PrivacyPolicy());
//                           // navigate to desired screen or perform an action
//                         },
//                     ),
//                   ]),
//             ),
//             const Expanded(child: SizedBox()),
//             CustomFillButton(
//               buttonText: 'Send code',
//               textColor: AppColor().button1Color,
//               buttonColor: AppColor().primaryColor,
//               onTap: () {
//                 Get.to(() => const WelComePage());
//               },
//             ),
//             const Gap(50),
//           ],
//         ),
//       ),
//     );
//   }
// }
