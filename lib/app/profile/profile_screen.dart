// ignore_for_file: use_build_context_synchronously

import 'package:agora_care/app/consultant/userconsultant_messages.dart';
import 'package:agora_care/app/profile/add_consultant.dart';
import 'package:agora_care/app/profile/edit_profile.dart';
import 'package:agora_care/app/profile/support.dart';
import 'package:agora_care/core/constant/colors.dart';
import 'package:agora_care/core/customWidgets.dart';
import 'package:agora_care/core/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../helper/helper_function.dart';
import '../../services/auth_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
      appBar: AppBar(
        backgroundColor: AppColor().whiteColor,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: AppColor().boxColor,
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
                        // FutureBuilder<UserModel>(
                        //     future: _authController.getUserByModel(
                        //         _authController.liveUser.value!.uid!),
                        //     builder: (BuildContext context, snapshot) {
                        //       if (snapshot.connectionState ==
                        //               ConnectionState.done &&
                        //           snapshot.hasData) {
                        //         return Container(
                        //           height: 60,
                        //           width: 60,
                        //           decoration: BoxDecoration(
                        //             borderRadius: BorderRadius.circular(80),
                        //             image: DecorationImage(
                        //               image: CachedNetworkImageProvider(
                        //                 snapshot.data!.profilePic!,
                        //               ),
                        //               fit: BoxFit.cover,
                        //             ),
                        //           ),
                        //         );
                        //       } else if (snapshot.connectionState ==
                        //           ConnectionState.waiting) {
                        //         return Center(
                        //           child: CircularProgressIndicator(
                        //             color: AppColor().primaryColor,
                        //           ),
                        //         );
                        //       } else {
                        //         return Container(
                        //           decoration: BoxDecoration(
                        //             color: AppColor().whiteColor,
                        //             border: Border.all(
                        //               width: 2,
                        //               color: AppColor().primaryColor,
                        //             ),
                        //             shape: BoxShape.circle,
                        //           ),
                        //           child: Center(
                        //             child: CircleAvatar(
                        //               radius: 50,
                        //               backgroundColor: AppColor().whiteColor,
                        //               child: Image.asset(
                        //                 "assets/images/placeholder.png",
                        //                 height: 50,
                        //                 width: 50,
                        //               ),
                        //             ),
                        //           ),
                        //         );
                        //       }
                        //     }),
                      ],
                    ),
                    (_authController.liveUser.value!.admin == true ||
                            _authController.liveUser.value!.role ==
                                'consultant')
                        ? Container()
                        : const Gap(15),
                    (_authController.liveUser.value!.admin == true ||
                            _authController.liveUser.value!.role ==
                                'consultant')
                        ? Container()
                        : const Divider(
                            height: 1,
                            thickness: 1,
                          ),
                    (_authController.liveUser.value!.admin == true ||
                            _authController.liveUser.value!.role ==
                                'consultant')
                        ? Container()
                        : const Gap(15),
                    (_authController.liveUser.value!.admin == true ||
                            _authController.liveUser.value!.role ==
                                'consultant')
                        ? Container()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/svgs/streak.svg',
                              ),
                              const Gap(5),
                              Obx(() {
                                return customDescriptionText(
                                  // '5',
                                  _authController.liveUser.value!.streak == null
                                      ? '0'
                                      : _authController.liveUser.value!.streak
                                          .toString(),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  colors: AppColor().textColor,
                                );
                              }),
                              const Gap(5),
                              customDescriptionText(
                                'Streak',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                colors: AppColor().lightTextColor,
                              ),
                              const Gap(30),
                              /////
                              Container(
                                height: 15,
                                width: 1.5,
                                color: AppColor().lightTextColor,
                              ),
                              /////
                              const Gap(30),
                              SvgPicture.asset(
                                'assets/svgs/calender.svg',
                              ),
                              const Gap(5),
                              Obx(() {
                                return customDescriptionText(
                                  // '20',
                                  _authController.liveUser.value!.weeks == null
                                      ? '0'
                                      : _authController.liveUser.value!.weeks
                                          .toString(),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  colors: AppColor().textColor,
                                );
                              }),
                              const Gap(5),
                              customDescriptionText(
                                'Weeks',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                colors: AppColor().lightTextColor,
                              ),
                              const Gap(40),
                              Icon(
                                Icons.keyboard_arrow_right,
                                color: AppColor().blackColor,
                              ),
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
              _authController.liveUser.value!.admin == true
                  ? Container()
                  : const Gap(15),

              // CustomContainer(
              //   selectedColor: Theme.of(context).primaryColor,
              //   selected: true,
              //   trailing: const Icon(
              //     Icons.group,
              //     size: 30,
              //   ),
              //   titleText: 'Groups',
              //   onTap: () {
              //     // Get.to(() => const CellInfo());
              //   },
              // ),
              // const Gap(15),
              // CustomContainer(
              //   trailing: SvgPicture.asset(
              //     'assets/svgs/keyboard_arrow_right.svg',
              //     height: 14,
              //   ),
              //   titleText: 'Quote Page',
              //   // onTap: () {
              //   //   Get.to(() => const QuotePage());
              //   // },
              // ),
              // const Gap(15),

              // CustomContainer(
              //   selectedColor: Theme.of(context).primaryColor,
              //   selected: true,
              //   trailing: const Icon(
              //     Icons.group,
              //     size: 30,
              //   ),
              //   titleText: 'Groups',
              //   onTap: () {
              //     Get.to(() => const GroupScreen());
              //   },
              // ),
              // const Gap(15),
              // CustomContainer(
              //   trailing: SvgPicture.asset(
              //     'assets/svgs/keyboard_arrow_right.svg',
              //     height: 14,
              //   ),
              //   titleText: 'Quote Page',
              //   onTap: () {
              //     Get.to(() => const QuotePage());
              //   },
              // ),
              // const Gap(15),

              _authController.liveUser.value!.admin == true
                  ? Container()
                  : CustomContainer(
                      trailing: SvgPicture.asset(
                        'assets/svgs/keyboard_arrow_right.svg',
                        height: 14,
                      ),
                      titleText: 'Edit profile',
                      onTap: () {
                        Get.to(() => const EditProfile());
                      },
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
              (_authController.liveUser.value!.admin == true ||
                      _authController.liveUser.value!.role == 'consultant')
                  ? Container()
                  : const Gap(15),
              (_authController.liveUser.value!.admin == true ||
                      _authController.liveUser.value!.role == 'consultant')
                  ? Container()
                  : CustomContainer(
                      trailing: SvgPicture.asset(
                        'assets/svgs/keyboard_arrow_right.svg',
                        height: 14,
                      ),
                      titleText: 'Support',
                      onTap: () {
                        Get.to(() => const SupportPage());
                      },
                    ),
              (_authController.liveUser.value!.admin == true ||
                      _authController.liveUser.value!.role == 'consultant')
                  ? Container()
                  : const Gap(15),
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
