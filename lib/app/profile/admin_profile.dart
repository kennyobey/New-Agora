// ignore_for_file: use_build_context_synchronously

import 'package:agora_care/app/consultant/userconsultant_messages.dart';
import 'package:agora_care/app/profile/add_consultant.dart';
import 'package:agora_care/core/constant/colors.dart';
import 'package:agora_care/core/customWidgets.dart';
import 'package:agora_care/core/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../helper/helper_function.dart';
import '../../services/auth_controller.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({Key? key}) : super(key: key);

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  String email = "";
  final _authController = Get.find<AuthControllers>();
  String profilePicLink =
      "https://github.com/Damscozy/agora_care/blob/2ce3a6a6952f9aa104921a3f4b50af251c621511/assets/images/chatPic.png";

  gettingUserData() async {
    await HelperFunction.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
  }

  @override
  void initState() {
    _authController.getUserByModel(_authController.liveUser.value!.uid!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().boxColor,
      appBar: AppBar(
        backgroundColor: AppColor().whiteColor,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: AppColor().boxColor,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  customTitleText(
                    'Profile',
                    size: 32,
                    spacing: -0.1,
                    fontWeight: FontWeight.w800,
                    colors: AppColor().filledTextField,
                  ),
                  SvgPicture.asset('assets/svgs/bell.svg'),
                ],
              ),
              const Gap(15),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                decoration: BoxDecoration(
                  color: AppColor().whiteColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _authController.liveUser.value!.admin == true
                                ? Obx(() {
                                    return customDescriptionText(
                                      _authController.liveUser.value!.role ==
                                              null
                                          ? 'Admin'
                                          : _authController
                                              .liveUser.value!.role!,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      colors: AppColor().filledTextField,
                                    );
                                  })
                                : Obx(() {
                                    if (_authController.liveUser.value!.role ==
                                        'consultant') {
                                      return customDescriptionText(
                                        _authController.liveUser.value!.role ==
                                                null
                                            ? 'Your Role'
                                            : _authController
                                                .liveUser.value!.role!,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        colors: AppColor().filledTextField,
                                      );
                                    } else if (_authController
                                            .liveUser.value!.admin ==
                                        true) {
                                      return customDescriptionText(
                                        _authController.liveUser.value!.role ==
                                                null
                                            ? 'Your Role'
                                            : _authController
                                                .liveUser.value!.role!,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        colors: AppColor().filledTextField,
                                      );
                                    } else {
                                      return customDescriptionText(
                                        _authController
                                                    .liveUser.value!.fullName ==
                                                null
                                            ? 'Your Name'
                                            : _authController
                                                .liveUser.value!.fullName!,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        colors: AppColor().filledTextField,
                                      );
                                    }
                                  }),
                            const Gap(5),
                            customDescriptionText(
                              _authController.liveUser.value == null &&
                                      _authController.liveUser.value!.email ==
                                          null
                                  ? 'example@mail.com'
                                  : _authController.liveUser.value!.email!,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              colors: Colors.black,
                            ),
                          ],
                        ),
                        const Gap(5),
                        Obx(() {
                          if (_authController.liveUser.value!.profilePic ==
                                  null ||
                              _authController.liveUser.value!.profilePic ==
                                  "") {
                            return Image.asset(
                              "assets/images/placeholder.png",
                              height: 50,
                              width: 50,
                            );
                          } else {
                            return Image.network(
                              _authController.liveUser.value!.profilePic!,
                              height: 50,
                              width: 50,
                            );
                          }
                        }),
                      ],
                    ),
                    const Gap(10),
                  ],
                ),
              ),
              const Gap(40),
              customDescriptionText(
                'Action',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                colors: AppColor().filledTextField,
              ),
              const Gap(15),
              CustomContainer(
                trailing: SvgPicture.asset(
                  'assets/svgs/keyboard_arrow_right.svg',
                  height: 14,
                ),
                titleText: 'Settings',
                onTap: () {
                  // Get.to(() => SettingsPage());
                },
              ),
              const Gap(15),
              Obx(
                () {
                  if (_authController.liveUser.value!.role == 'consultant') {
                    return Container();
                  } else if (_authController.liveUser.value!.admin == true) {
                    return CustomContainer(
                      trailing: SvgPicture.asset(
                        'assets/svgs/keyboard_arrow_right.svg',
                        height: 14,
                      ),
                      titleText: 'Add Consultant',
                      onTap: () {
                        Get.to(() => const AddConsultant());
                      },
                    );
                  } else {
                    return CustomContainer(
                      trailing: SvgPicture.asset(
                        'assets/svgs/keyboard_arrow_right.svg',
                        height: 14,
                      ),
                      titleText: 'Consult a psychologist',
                      onTap: () {
                        Get.to(() => const UserConsultantMessage());
                      },
                    );
                  }
                },
              ),
              const Gap(15),
              CustomContainer(
                trailing: SvgPicture.asset(
                  'assets/svgs/keyboard_arrow_right.svg',
                  height: 14,
                ),
                titleText: 'Log out',
                onTap: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Logout"),
                          content:
                              const Text("Are you sure you want to logout?"),
                          actions: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.cancel,
                                color: Colors.red,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                await _authController.signOut();
                              },
                              icon: const Icon(
                                Icons.done,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        );
                      });
                  // print("The email is ${email}");
                  // AuthController.instance.signOut();

                  // Get.to(() => const AccountStatement());
                },
              ),
              const Gap(20),
              _authController.liveUser.value!.admin == true
                  ? Container()
                  : CustomBorderButton(
                      borderColor: AppColor().errorColor,
                      buttonText: 'Delete Account',
                      textSize: 14,
                      textColor: AppColor().errorColor,
                      onTap: () async {
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: customDescriptionText(
                                  "Delete Account",
                                  fontWeight: FontWeight.bold,
                                  colors: AppColor().primaryColor,
                                ),
                                content: customDescriptionText(
                                    "Are you sure you want to delete your account?"),
                                actions: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(
                                      Icons.cancel,
                                      color: Colors.red,
                                    ),
                                  ),
                                  //Leave Chat
                                  IconButton(
                                    onPressed: () async {
                                      await _authController.deleteUserAccount(
                                          _authController.liveUser.value!.uid!);
                                    },
                                    icon: const Icon(
                                      Icons.done,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              );
                            });
                      },
                    )
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector recommendedCells({
    Color? colors,
    String? title,
    String? assetName,
  }) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.only(right: 10, bottom: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          width: MediaQuery.of(context).size.width * 0.35,
          height: MediaQuery.of(context).size.height * 0.2,
          decoration: BoxDecoration(
            color: colors,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                assetName!,
                height: 30,
                color: AppColor().whiteColor,
              ),
              const Gap(10),
              customTitleText(
                title!,
                textAlign: TextAlign.left,
                colors: AppColor().whiteColor,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector otherCells({
    Color? colors,
    String? title,
    String? assetName,
    String? assetName2,
  }) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.only(right: 10, bottom: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
            color: AppColor().whiteColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                decoration: BoxDecoration(
                  color: colors,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      assetName!,
                      height: 24,
                      color: AppColor().whiteColor,
                    ),
                  ],
                ),
              ),
              const Gap(5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  customTitleText(
                    title!,
                    textAlign: TextAlign.left,
                    colors: AppColor().textColor,
                    size: 16,
                  ),
                  const Gap(5),
                  Row(
                    children: [
                      SvgPicture.asset(
                        assetName2!,
                        height: 16,
                        color: AppColor().textColor,
                      ),
                      const Gap(5),
                      customTitleText(
                        '14,000',
                        textAlign: TextAlign.left,
                        size: 12,
                        colors: AppColor().textColor,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
