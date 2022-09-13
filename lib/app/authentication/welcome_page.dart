import 'package:agora_care/app/authentication/login_page.dart';
import 'package:agora_care/core/constant/colors.dart';
import 'package:agora_care/core/customWidgets.dart';
import 'package:agora_care/core/custom_form_field.dart';
import 'package:agora_care/services/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class WelComePage extends StatefulWidget {
  const WelComePage({Key? key}) : super(key: key);

  @override
  State<WelComePage> createState() => _WelComePageState();
}

class _WelComePageState extends State<WelComePage> {
  final formKey = GlobalKey<FormState>();
  String? selectedGender;
  final _authController = Get.find<AuthControllers>();
  late bool _isLoading = false;

  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _nextKinController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _nextKinPhoneController = TextEditingController();

  final gender = [
    'Male',
    'Female',
    'Rather Not Say',
  ];

  User? user;

  var profilePicUrl =
      'https://pixel.nymag.com/imgs/daily/vulture/2017/06/14/14-tom-cruise.w700.h700.jpg';

  // @override
  // void initState() {
  //   user = FirebaseAuth.instance.currentUser!().then((user) {
  //     setState(() {
  //       profilePicUrl = user.photoUrl;
  //       nickName = user.displayName;
  //     });
  //   }).catchError((e) {
  //     if (kDebugMode) {
  //       print(e);
  //     }
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: AppColor().whiteColor,
      //   elevation: 0,
      //   toolbarHeight: 0,
      // ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SvgPicture.asset(
                'assets/svgs/welcome.svg',
                // height: 50,
                // width: MediaQuery.of(context).size.width,
                // color: AppColor().whiteColor,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(20),
                    customTitleText(
                      'Welcome! 👋',
                      size: 32,
                      spacing: -0.1,
                      fontWeight: FontWeight.w800,
                      colors: AppColor().filledTextField,
                    ),
                    const Gap(10),
                    customDescriptionText(
                      'We are glad to have you onboard, just a few',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      colors: AppColor().lightTextColor,
                    ),
                    customDescriptionText(
                      'questions and we will be set.',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      colors: AppColor().lightTextColor,
                    ),
                    const Gap(30),
                    CustomTextField(
                      label: 'What should we call you?',
                      hint: 'Enter username',
                      keyType: TextInputType.name,
                      validatorText: '** Field cannot be empty',
                      color: AppColor().lightTextColor,
                      textEditingController: _usernameController,
                    ),
                    const Gap(15),
                    CustomTextField(
                      label: 'What is your fullname?',
                      hint: 'Enter fullname',
                      keyType: TextInputType.name,
                      validatorText: '** Field cannot be empty',
                      color: AppColor().lightTextColor,
                      textEditingController: _fullnameController,
                    ),
                    const Gap(15),
                    CustomTextField(
                      label: 'Phone Number',
                      hint: 'Enter phone number',
                      keyType: TextInputType.phone,
                      validatorText: '** Field cannot be empty',
                      color: AppColor().lightTextColor,
                      textEditingController:
                          _authController.signupPhonenumberController,
                    ),
                    const Gap(15),
                    CustomTextField(
                      label: 'What is your city and postcode?',
                      hint: 'Enter city and postcode',
                      keyType: TextInputType.text,
                      validatorText: '** Field cannot be empty',
                      color: AppColor().lightTextColor,
                      textEditingController: _cityController,
                    ),
                    const Gap(15),
                    CustomTextField(
                      label: 'What is your address?',
                      hint: 'Enter address',
                      keyType: TextInputType.streetAddress,
                      validatorText: '** Field cannot be empty',
                      color: AppColor().lightTextColor,
                      textEditingController: _addressController,
                    ),
                    const Gap(15),
                    CustomTextField(
                      label: 'Next Of Kin',
                      hint: 'Enter kin\'n fullname',
                      keyType: TextInputType.name,
                      validatorText: '** Field cannot be empty',
                      color: AppColor().lightTextColor,
                      textEditingController: _nextKinController,
                    ),
                    const Gap(15),
                    CustomTextField(
                      label: 'Next Of Kin Phone Number',
                      hint: 'Enter kin\'n phone number',
                      keyType: TextInputType.phone,
                      validatorText: '** Field cannot be empty',
                      color: AppColor().lightTextColor,
                      textEditingController: _nextKinPhoneController,
                    ),
                    const Gap(20),
                    CustomFillButton(
                        isLoading: _isLoading,
                        buttonText: 'Get me started',
                        textColor: AppColor().button1Color,
                        buttonColor: AppColor().primaryColor,
                        onTap: () async {
                          // Get.to(() => const UserNavScreen());
                          if (kDebugMode) {
                            print('update profile');
                          }
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              _isLoading = true;
                            });
                            await _authController.userChanges(
                              _usernameController.text,
                              _fullnameController.text,
                              _authController.signupPhonenumberController.text,
                              _addressController.text,
                              _cityController.text,
                              '',
                              _nextKinController.text,
                              _nextKinPhoneController.text,
                            );
                            setState(() {
                              _isLoading = false;
                            });
                            _authController.signOut();
                            Get.to(() => const LoginPage());
                          }
                        }),
                    const Gap(5),
                    // CustomFillButton(
                    //   buttonText: 'Log Out',
                    //   textColor: AppColor().button1Color,
                    //   buttonColor: AppColor().primaryColor,
                    //   onTap: () {
                    //     if (kDebugMode) {
                    //       print("Sign out");
                    //     }
                    //     Get.to(() => const LoginPage());
                    //   },
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildGenderItem(String item) => DropdownMenuItem(
        value: item,
        child: customDescriptionText(
          item,
          fontSize: 14,
        ),
      );
}
