// ignore_for_file: prefer_final_fields, must_be_immutable, unnecessary_null_comparison

import 'package:agora_care/app/model/user_list_model.dart';
import 'package:agora_care/core/custom_form_field.dart';
import 'package:agora_care/services/auth_controller.dart';
import 'package:agora_care/widget/bottom_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../core/constant/colors.dart';
import '../../core/customWidgets.dart';

class AddConsultant extends StatefulWidget {
  const AddConsultant({Key? key}) : super(key: key);

  @override
  State<AddConsultant> createState() => _AddConsultantState();
}

class _AddConsultantState extends State<AddConsultant> {
  final formKey = GlobalKey<FormState>();
  final _psycController = TextEditingController();
  final _authController = Get.find<AuthControllers>();

  final ScrollController listScrollController = ScrollController();

  int _limit = 20;
  int _limitIncrement = 20;
  String _textSearch = "";
  late String currentUserId;

  DateTime createdTime = DateTime.now();

  String? selectedColor;
  Color color = AppColor().pinkColor;

  final List<Color> colorList = <Color>[
    AppColor().pinkColor,
    AppColor().blueColor,
    AppColor().backgroundColor,
    AppColor().primaryColor,
  ];

  bool _isLoading = false;

  void scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  @override
  void initState() {
    if (_authController.getUserByModel(_authController.liveUser.value!.uid!) !=
        null) {
      // _authController.liveUser.listen(((p0) async {
      currentUserId = _authController
          .getUserByModel(_authController.liveUser.value!.uid!)
          .toString();
    }
    super.initState();
  }

  @override
  void dispose() {
    _psycController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor().whiteColor,
        elevation: 0,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AppColor().primaryColor,
              ),
            )
          : Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customDescriptionText(
                      "Add Consultants/Psychologist",
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      colors: AppColor().lightTextColor,
                    ),
                    const Gap(30),
                    CustomTextField(
                      label: 'Psycologist Email',
                      hint: "e.g. someone@gmail.com",
                      // minLines: 2,
                      // maxLines: 5,
                      keyType: TextInputType.emailAddress,
                      validatorText: '** Field cannot be empty',
                      color: AppColor().lightTextColor,
                      textEditingController: _psycController,
                      fillColor: AppColor().fillColor,
                    ),
                    const Gap(20),
                    StreamBuilder<List<UserList>>(
                        // stream: _authController.getStreamFireStore(
                        //     _limit, _textSearch),
                        stream: _authController.readUserList(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            if ((snapshot.data!.length ?? 0) > 0) {
                              return Expanded(
                                child: ListView.builder(
                                    padding: const EdgeInsets.all(10),
                                    controller: listScrollController,
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context, index) {
                                      return buildItem(
                                        context,
                                        snapshot.data[index],
                                      );
                                    }),
                              );
                            } else if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: AppColor().primaryColor,
                                ),
                              );
                            } else {
                              return Container(
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
                                    child: Image.asset(
                                      "assets/images/placeholder.png",
                                      height: 50,
                                      width: 50,
                                    ),
                                  ),
                                ),
                              );
                            }
                          } else {
                            return customDescriptionText('No members yet');
                          }
                        }),
                    // SizedBox(
                    //   height: MediaQuery.of(context).size.height * 0.5,
                    //   child: StreamBuilder<List<UserList>>(
                    //       stream: _authController.readUserList(),
                    //       builder: (context, snapshot) {
                    //         if (snapshot.hasError) {
                    //           return customDescriptionText('Error');
                    //         } else if (snapshot.hasData) {
                    //           if (snapshot.data != null ||
                    //               snapshot.data!.isNotEmpty) {
                    //             final myuser = snapshot.data!;
                    //             return ListView(
                    //               children: myuser.map(buildUser).toList(),
                    //             );
                    //           } else {
                    //             return customDescriptionText('No members yet');
                    //           }
                    //         } else {
                    //           return Center(
                    //             child: CircularProgressIndicator(
                    //               color: AppColor().primaryColor,
                    //             ),
                    //           );
                    //         }
                    //       }),
                    // ),
                    // const Spacer(),
                    // CustomFillButton(
                    //   buttonText: 'Proceed',
                    //   textColor: AppColor().button1Color,
                    //   buttonColor: AppColor().primaryColor,
                    //   isLoading: _isLoading,
                    //   onTap: () async {
                    //     await Future.delayed(
                    //       const Duration(milliseconds: 300),
                    //     );
                    //     if (kDebugMode) {
                    //       print('add psychologist');
                    //     }
                    //     changePsyRole();
                    //   },
                    // ),
                    const Gap(40)
                  ],
                ),
              ),
            ),
    );
  }

  changePsyRole() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      await _authController.changeConsultant(
        _authController.liveUser.value!.uid!,
        _authController.liveUser.value!.username!,
        _authController.liveUser.value!.fullName!,
        _psycController.text,
        _authController.liveUser.value!.postalCode!,
      );
      _psycController.clear();
      setState(() {
        _isLoading = false;
      });
      showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: AppColor().whiteColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        context: context,
        builder: (context) => GlobalDialogue(
          text1: 'Consultant/Psychologist',
          text2: 'Psychologist have been added successfully',
          asset: 'assets/svgs/success.svg',
          action: () {
            Get.close(1);
          },
        ),
      );
    }
  }

  void pickColor(BuildContext context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: customDescriptionText(
            'Pick Color',
            colors: AppColor().button1Color,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildColorPicker(),
              CustomFillButton(
                buttonText: 'Select',
                textColor: AppColor().button1Color,
                buttonColor: AppColor().primaryColor,
                width: MediaQuery.of(context).size.width * 0.3,
                onTap: () {
                  Get.close(1);
                },
              ),
            ],
          ),
        ),
      );

  Widget buildColorPicker() => BlockPicker(
        pickerColor: color,
        // enableAlpha: false,
        // showLabel: false,
        availableColors: [
          AppColor().pinkColor,
          AppColor().blueColor,
          AppColor().backgroundColor,
          AppColor().primaryColor,
        ],
        onColorChanged: (color) => setState(() {
          this.color = color;
        }),
      );

  Widget buildUser(UserList user) => ListTile(
        leading: Obx(() {
          if (_authController.liveUser.value!.profilePic == null ||
              _authController.liveUser.value!.profilePic == "") {
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
        title: Row(
          children: [
            customTitleText(
              "Username: ",
              size: 14,
              fontWeight: FontWeight.w700,
              colors: AppColor().lightTextColor,
            ),
            const Gap(5),
            customDescriptionText(
              (user.username == null || user.username!.isEmpty)
                  ? 'No username yet'
                  : user.username!,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              colors: AppColor().lightTextColor,
            ),
          ],
        ),
        subtitle: Row(
          children: [
            customTitleText(
              'Email:',
              size: 14,
              fontWeight: FontWeight.w700,
              colors: AppColor().lightTextColor,
            ),
            const Gap(5),
            customDescriptionText(
              user.email!,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              colors: AppColor().lightTextColor,
            ),
          ],
        ),
      );

  Widget buildItem(BuildContext context, UserList? document) {
    if (document != null) {
      // UserModel userChat = UserModel();
      // if (userChat.uid == currentUserId) {
      // UserList? userChat;
      if (document.uid == currentUserId) {
        return const SizedBox.shrink();
      } else {
        return Container(
          margin: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
          child: TextButton(
            // ignore: sort_child_properties_last
            child: Row(
              children: [
                Material(
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                  clipBehavior: Clip.hardEdge,
                  child: document != null
                      ? Image.network(
                          document.profilePic!,
                          fit: BoxFit.cover,
                          width: 50,
                          height: 50,
                          loadingBuilder: (
                            BuildContext context,
                            Widget child,
                            ImageChunkEvent? loadingProgress,
                          ) {
                            if (loadingProgress == null) return child;
                            return SizedBox(
                              width: 50,
                              height: 50,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColor().primaryColor,
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, object, stackTrace) {
                            return Icon(
                              Icons.account_circle,
                              size: 50,
                              color: AppColor().primaryColor,
                            );
                          },
                        )
                      : Icon(
                          Icons.account_circle,
                          size: 50,
                          color: AppColor().primaryColor,
                        ),
                ),
                Flexible(
                  child: Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.fromLTRB(10, 0, 0, 5),
                          child: Text(
                            'Username: ${document.username!}',
                            maxLines: 1,
                            style: TextStyle(color: AppColor().primaryColor),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Text(
                            'User Email: ${document.email!}',
                            maxLines: 1,
                            style: TextStyle(color: AppColor().primaryColor),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {},
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(AppColor().whiteColor),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }
}
