// ignore_for_file: override_on_non_overriding_member, use_build_context_synchronously, unused_local_variable, unused_field
import 'dart:io';

import 'package:agora_care/core/constant/colors.dart';
import 'package:agora_care/core/customWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../../services/auth_controller.dart';

class PhonePage extends StatefulWidget {
  const PhonePage({Key? key}) : super(key: key);

  @override
  State<PhonePage> createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {
  final _authContoller = Get.find<AuthControllers>();
  final formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  String initialCountry = 'NG';

  PhoneNumber number = PhoneNumber(isoCode: 'NG');

  final bool _isLoading = false;
  String email = "";
  String password = "";
  @override
  void iniState() {
    // _passworController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _phoneController.clear();
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
                color: AppColor().primaryColor,
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
                    Container(
                      width: MediaQuery.of(context).size.width * 0.87,
                      margin: const EdgeInsets.only(top: 10.0),
                      //padding: const EdgeInsets.only(left: 0.0, right: 10),

                      // child: IntlPhoneField(
                      //   controller: _phoneController,
                      //   initialCountryCode: 'UK',
                      //   decoration: const InputDecoration(
                      //     labelText: '',
                      //     border: OutlineInputBorder(
                      //       borderSide: BorderSide(color: Colors.white),
                      //     ),
                      //   ),
                      //   onChanged: (phone) {
                      //     if (kDebugMode) {
                      //       print(phone.completeNumber);
                      //     }

                      //   },
                      // ),

                      child: InternationalPhoneNumberInput(
                        onInputChanged: (PhoneNumber number) {
                          print("country code ${number.phoneNumber}");
                          this.number = number;
                        },
                        onInputValidated: (bool value) {
                          print(value);
                        },
                        selectorConfig: const SelectorConfig(
                          selectorType: PhoneInputSelectorType.DROPDOWN,
                        ),
                        ignoreBlank: false,
                        maxLength: 11,
                        autoValidateMode: AutovalidateMode.disabled,
                        selectorTextStyle: const TextStyle(
                          color: Colors.black54,
                        ),
                        initialValue: number,
                        textFieldController:
                            _authContoller.signupPhonenumberController,
                        formatInput: false,
                        // cursorColor: UIData.kbrightColor,
                        hintText: "07012345678",
                        errorMessage: "invalid Phone Number",
                        inputDecoration: InputDecoration(
                          fillColor: Colors.grey[500]!.withOpacity(0.2),
                          filled: true,
                          focusColor: AppColor().primaryColor,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              15,
                            ),
                            borderSide: BorderSide(
                              //color: UIData.kbrightColor,
                              width: 10,
                            ),
                          ),
                          contentPadding: const EdgeInsets.only(
                            bottom: 15,
                            left: 10,
                          ),
                        ),
                        keyboardType: Platform.isIOS
                            ? const TextInputType.numberWithOptions(
                                signed: true,
                                decimal: true,
                              )
                            : TextInputType.number,
                        inputBorder: InputBorder.none,
                        onSaved: (PhoneNumber number) {
                          number = Get.find<AuthControllers>()
                              .signupPhonenumberController as PhoneNumber;
                        },
                        textStyle:
                            Theme.of(context).textTheme.headline4!.copyWith(
                                  color: Colors.black,
                                  //fontFamily: FontFamily.sofiaPro,
                                  fontSize: 14,
                                ),
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Enter your Phone Number';
                          }
                          return null;
                        },
                      ),
                      // alignment: Alignment.centerLeft,
                    ),
                    const Expanded(child: SizedBox()),
                    CustomFillButton(
                      buttonText: 'Send Code',
                      textColor: AppColor().button1Color,
                      buttonColor: AppColor().primaryColor,
                      onTap: () async {
                        if (kDebugMode) {
                          print('Sending OTP');
                        }
                        await _authContoller
                            .sendVerificationCodes(number.phoneNumber);
                      },
                    ),
                    const Gap(50),
                  ],
                ),
              ),
            ),
    );
  }
}
