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

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String? selectedGender;
  final _authContoller = Get.find<AuthControllers>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final gender = [
    'Male',
    'Female',
    'Rather Not Say',
  ];

  bool isEditClicked = false;

  User? user;

  var nickName = 'Tom';
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/chatPic.png',
                      height: 100,
                      width: 100,
                    ),
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
                    hint: _authContoller.liveUser.value!.username == null
                        ? 'Enter username'
                        : _authContoller.liveUser.value!.username!,
                    keyType: TextInputType.name,
                    validatorText: '** Field cannot be empty',
                    color: AppColor().lightTextColor,
                    enabled: isEditClicked ? true : false,
                    textEditingController: _usernameController,
                  ),
                  const Gap(15),
                  CustomTextField(
                    label: 'Fullname',
                    hint: _authContoller.liveUser.value!.username == null
                        ? 'Enter username'
                        : _authContoller.liveUser.value!.username!,
                    keyType: TextInputType.name,
                    validatorText: '** Field cannot be empty',
                    color: AppColor().lightTextColor,
                    enabled: isEditClicked ? true : false,
                    textEditingController: _fullnameController,
                  ),
                  const Gap(15),
                  isEditClicked == true
                      ? SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 5),
                                child: customDescriptionText(
                                  'Select Gender',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  colors: AppColor().textColor,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    width: 1,
                                    color: AppColor().lightTextColor,
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: selectedGender,
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                      size: 24,
                                      color: AppColor().primaryColor,
                                    ),
                                    hint: customDescriptionText(
                                      'Gender',
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    isDense: true,
                                    items: gender.map(buildGenderItem).toList(),
                                    onChanged: (value) {
                                      setState(() => selectedGender = value);
                                    },
                                    onTap: () {},
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customDescriptionText(
                              'Gender',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              colors: AppColor().textColor,
                            ),
                            const Gap(5),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 15,
                              ),
                              decoration: BoxDecoration(
                                color: AppColor().whiteColor,
                                border: Border.all(
                                  width: 1,
                                  color: AppColor().blackColor.withOpacity(0.2),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  const Gap(10),
                                  customDescriptionText(
                                    _authContoller.liveUser.value!.gender ==
                                            null
                                        ? 'Gender'
                                        : _authContoller
                                            .liveUser.value!.gender!,
                                    colors: AppColor().lightTextColor,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                  const Gap(15),
                  CustomTextField(
                    label: 'City',
                    hint: _authContoller.liveUser.value!.postalCode == null
                        ? 'Enter city and postcode'
                        : _authContoller.liveUser.value!.postalCode!,
                    keyType: TextInputType.text,
                    validatorText: '** Field cannot be empty',
                    color: AppColor().lightTextColor,
                    enabled: isEditClicked ? true : false,
                    textEditingController: _cityController,
                  ),
                  const Gap(15),
                  CustomTextField(
                    label: 'Address',
                    hint: _authContoller.liveUser.value!.address == null
                        ? 'Enter address'
                        : _authContoller.liveUser.value!.address!,
                    keyType: TextInputType.streetAddress,
                    validatorText: '** Field cannot be empty',
                    color: AppColor().lightTextColor,
                    enabled: isEditClicked ? true : false,
                    textEditingController: _addressController,
                  ),
                  const Gap(20),
                  isEditClicked
                      ? CustomFillButton(
                          buttonText: 'Update Details',
                          textColor: AppColor().button1Color,
                          buttonColor: AppColor().primaryColor,
                          onTap: () async {
                            // Get.to(() => const UserNavScreen());
                            if (kDebugMode) {
                              print('update profile');
                            }

                            await _authContoller.userChanges(
                              _usernameController.text,
                              _fullnameController.text,
                              selectedGender.toString(),
                              _addressController.text,
                              _cityController.text,
                              '',
                            );
                            setState(() {
                              isEditClicked = !isEditClicked;
                            });
                          },
                        )
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
