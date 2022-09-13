// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:io';

import 'package:agora_care/core/constant/colors.dart';
import 'package:agora_care/core/customWidgets.dart';
import 'package:agora_care/core/custom_form_field.dart';
import 'package:agora_care/services/auth_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String? selectedGender;
  final _authController = Get.find<AuthControllers>();
  final formKey = GlobalKey<FormState>();
  late bool _isLoading = false;

  PickedFile? file;

  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _nextKinController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _nextKinPhoneController = TextEditingController();

  final gender = [
    'Male',
    'Female',
    'Rather Not Say',
  ];

  bool isEditClicked = false;

  User? user;
  late String profilePicLink;

  var nickName = 'Tom';
  var profilePicUrl =
      'https://pixel.nymag.com/imgs/daily/vulture/2017/06/14/14-tom-cruise.w700.h700.jpg';

  @override
  void initState() {
    profilePicLink = _authController.liveUser.value!.profilePic!;
    super.initState();
  }

  void pickUploadProfilePic() async {
    file = await ImagePicker.platform.pickImage(
      source: ImageSource.gallery,
      maxHeight: 512,
      maxWidth: 512,
      imageQuality: 90,
    );
    if (file != null) {
      await _authController.updateAvatar(
        File(file!.path),
      );
    }

    Reference ref = FirebaseStorage.instance.ref("profilepic/${file!.path}");
    // Reference ref = FirebaseStorage.instance.ref().child("profilepic/");

    await ref.putFile(File(file!.path));

    ref.getDownloadURL().then((value) async {
      if (kDebugMode) {
        print(" Image link is $value");
      }
      if (kDebugMode) {
        print(" Image profilelink is $profilePicUrl");
      }
      setState(() {
        profilePicLink = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: AppColor().whiteColor,
      //   elevation: 0,
      //   toolbarHeight: 0,
      // ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  SvgPicture.asset(
                    'assets/svgs/welcome.svg',
                    // color: AppColor().whiteColor,
                  ),
                  Positioned(
                    top: 65,
                    child: customTitleText(
                      'Profile Details',
                      size: 24,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Positioned(
                            top: 20,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () => Get.back(),
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: AppColor().primaryColor,
                              ),
                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColor().whiteColor,
                                  border: Border.all(
                                    width: 2,
                                    color: AppColor().primaryColor,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundColor: AppColor().whiteColor,
                                    child: profilePicLink == ""
                                        ? Image.asset(
                                            'assets/images/placeholder.png',
                                            height: 100,
                                            width: 100,
                                          )
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(80),
                                                image: DecorationImage(
                                                  image:
                                                      CachedNetworkImageProvider(
                                                    // _authController.liveUser
                                                    //     .value!.profilePic!,
                                                    profilePicLink,
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          right: 125,
                          bottom: 1,
                          child: GestureDetector(
                            onTap: () async {
                              isEditClicked ? pickUploadProfilePic() : null;
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: AppColor().primaryColor,
                              ),
                              child: const Center(
                                child: Icon(
                                  CupertinoIcons.camera,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isEditClicked = !isEditClicked;
                            });
                          },
                          child: customDescriptionText(
                            isEditClicked ? 'Cancel Edit' : 'Edit Details',
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                            colors: isEditClicked
                                ? AppColor().errorColor
                                : AppColor().primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Gap(30),
                    CustomTextField(
                      label: 'Username',
                      hint: _authController.liveUser.value!.username == null
                          ? 'Enter username'
                          : _authController.liveUser.value!.username!,
                      keyType: TextInputType.name,
                      validatorText: '** Field cannot be empty',
                      color: AppColor().lightTextColor,
                      enabled: isEditClicked ? true : false,
                      textEditingController: _usernameController,
                    ),
                    const Gap(15),
                    CustomTextField(
                      label: 'Fullname',
                      hint: _authController.liveUser.value!.username == null
                          ? 'Enter username'
                          : _authController.liveUser.value!.username!,
                      keyType: TextInputType.name,
                      validatorText: '** Field cannot be empty',
                      color: AppColor().lightTextColor,
                      enabled: isEditClicked ? true : false,
                      textEditingController: _fullnameController,
                    ),
                    const Gap(15),
                    CustomTextField(
                      label: 'Phone Number',
                      hint: _authController.liveUser.value!.phoneNumber == null
                          ? 'Enter phone number'
                          : _authController.liveUser.value!.phoneNumber!,
                      keyType: TextInputType.phone,
                      validatorText: '** Field cannot be empty',
                      color: AppColor().lightTextColor,
                      enabled: isEditClicked ? true : false,
                      textEditingController:
                          _authController.signupPhonenumberController,
                    ),
                    const Gap(15),
                    CustomTextField(
                      label: 'City',
                      hint: _authController.liveUser.value!.postalCode == null
                          ? 'Enter city and postcode'
                          : _authController.liveUser.value!.postalCode!,
                      keyType: TextInputType.text,
                      validatorText: '** Field cannot be empty',
                      color: AppColor().lightTextColor,
                      enabled: isEditClicked ? true : false,
                      textEditingController: _cityController,
                    ),
                    const Gap(15),
                    CustomTextField(
                      label: 'Address',
                      hint: _authController.liveUser.value!.address == null
                          ? 'Enter address'
                          : _authController.liveUser.value!.address!,
                      keyType: TextInputType.streetAddress,
                      validatorText: '** Field cannot be empty',
                      color: AppColor().lightTextColor,
                      enabled: isEditClicked ? true : false,
                      textEditingController: _addressController,
                    ),
                    const Gap(15),
                    CustomTextField(
                      label: 'Next Of Kin',
                      hint: _authController.liveUser.value!.nextOfKin == null
                          ? 'Enter kin\'n fullname'
                          : _authController.liveUser.value!.nextOfKin!,
                      keyType: TextInputType.name,
                      validatorText: '** Field cannot be empty',
                      color: AppColor().lightTextColor,
                      enabled: isEditClicked ? true : false,
                      textEditingController: _nextKinController,
                    ),
                    const Gap(15),
                    CustomTextField(
                      label: 'Next Of Kin Phone Number',
                      hint: _authController.liveUser.value!.nexKinPhone == null
                          ? 'Enter kin\'n phone number'
                          : _authController.liveUser.value!.nexKinPhone!,
                      keyType: TextInputType.phone,
                      validatorText: '** Field cannot be empty',
                      color: AppColor().lightTextColor,
                      enabled: isEditClicked ? true : false,
                      textEditingController: _nextKinPhoneController,
                    ),
                    const Gap(20),
                    isEditClicked
                        ? CustomFillButton(
                            isLoading: _isLoading,
                            buttonText: 'Update Details',
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
                                  _authController
                                      .signupPhonenumberController.text,
                                  _addressController.text,
                                  _cityController.text,
                                  '',
                                  _nextKinController.text,
                                  _nextKinPhoneController.text,
                                );
                                setState(() {
                                  isEditClicked = !isEditClicked;
                                });
                                Get.snackbar(
                                  'Alert',
                                  'Profile Updated Successfully',
                                );
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            })
                        : Container(),
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
