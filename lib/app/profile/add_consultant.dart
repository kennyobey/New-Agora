// ignore_for_file: prefer_final_fields, must_be_immutable, unnecessary_null_comparison, unused_field

import 'dart:async';

import 'package:agora_care/app/model/user_list_model.dart';
import 'package:agora_care/core/debouncer.dart';
import 'package:agora_care/services/auth_controller.dart';
import 'package:agora_care/widget/bottom_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
  final _authController = Get.find<AuthControllers>();

  final _psycController = TextEditingController();
  Debouncer searchDebouncer = Debouncer(milliseconds: 300);
  StreamController<bool> btnClearController = StreamController<bool>();

  final ScrollController listScrollController = ScrollController();

  int _limit = 20;
  int _limitIncrement = 20;
  String _textSearch = "";
  String _role = "user";
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
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: AppColor().whiteColor,
              ),
              child: Form(
                key: formKey,
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
                    // CustomTextField(
                    //   label: 'Psycologist Email',
                    //   hint: "e.g. someone@gmail.com",
                    //   keyType: TextInputType.emailAddress,
                    //   validatorText: '** Field cannot be empty',
                    //   color: AppColor().lightTextColor,
                    //   textEditingController: _psycController,
                    //   fillColor: AppColor().fillColor,
                    // ),
                    buildSearchBar(),
                    const Gap(20),
                    StreamBuilder<List<UserList>>(
                        stream: _authController.getStreamFireStore(
                          _limit,
                          _textSearch,
                          _role,
                        ),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            if ((snapshot.data!.length ?? 0) > 0) {
                              return Expanded(
                                child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    controller: listScrollController,
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context, index) {
                                      // UserList userList;

                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: buildItem(
                                          context,
                                          snapshot.data[index],
                                        ),
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
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Gap(50),
                                  Center(
                                    child: customDescriptionText(
                                      'No Username Found',
                                    ),
                                  ),
                                ],
                              );
                            }
                          } else {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Gap(50),
                                Center(
                                  child: customDescriptionText(
                                    'No User Yet',
                                  ),
                                ),
                              ],
                            );
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

  Widget buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 1,
          color: AppColor().primaryColor,
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 15,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(CupertinoIcons.search, color: AppColor().primaryColor, size: 20),
          const SizedBox(width: 5),
          Expanded(
            child: TextFormField(
              cursorColor: AppColor().primaryColor2,
              textInputAction: TextInputAction.search,
              controller: _psycController,
              onChanged: (value) {
                searchDebouncer.run(() {
                  if (value.isNotEmpty) {
                    btnClearController.add(true);
                    setState(() {
                      _textSearch = value;
                    });
                  } else {
                    btnClearController.add(false);
                    setState(() {
                      _textSearch = "";
                    });
                  }
                });
              },
              decoration: InputDecoration.collapsed(
                hintText: 'Search nickname (you have to type exact string)',
                hintStyle: TextStyle(fontSize: 13, color: AppColor().textColor),
              ),
              style: const TextStyle(fontSize: 13),
            ),
          ),
          StreamBuilder<bool>(
              stream: btnClearController.stream,
              builder: (context, snapshot) {
                return snapshot.data == true
                    ? GestureDetector(
                        onTap: () {
                          _psycController.clear();
                          btnClearController.add(false);
                          setState(() {
                            _textSearch = "";
                          });
                        },
                        child: Icon(Icons.clear_rounded,
                            color: AppColor().textColor, size: 20))
                    : const SizedBox.shrink();
              }),
        ],
      ),
    );
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
      if (document.uid == currentUserId) {
        return const SizedBox.shrink();
      } else {
        if (kDebugMode) {
          print(
              'Username is ${document.username} and User role is ${document.role}');
        }
        return TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              AppColor().primaryColor.withOpacity(0.2),
            ),
            shape: MaterialStateProperty.all<OutlinedBorder>(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
          ),
          onPressed: () {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: customTitleText(
                      "Change Role",
                      size: 14,
                      fontWeight: FontWeight.bold,
                      colors: AppColor().blackColor,
                    ),
                    content: customDescriptionText(
                      "Are you sure you want to make ${document.username} a consultant",
                      colors: AppColor().textColor,
                      fontSize: 12,
                    ),
                    actions: [
                      // IconButton(
                      //   onPressed: () {
                      //     Navigator.pop(context);
                      //   },
                      //   icon: const Icon(
                      //     Icons.cancel,
                      //     color: Colors.red,
                      //   ),
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomBorderButton(
                            buttonText: 'Cancel',
                            textColor: AppColor().errorColor,
                            borderColor: AppColor().errorColor,
                            width: MediaQuery.of(context).size.width * 0.3,
                            onTap: () {
                              Get.close(1);
                            },
                          ),
                          CustomFillButton(
                              buttonText: 'Continue',
                              textColor: AppColor().whiteColor,
                              buttonColor: AppColor().primaryColor,
                              width: MediaQuery.of(context).size.width * 0.3,
                              onTap: () async {
                                if (kDebugMode) {
                                  print('role change pressed');
                                }
                                // if (formKey.currentState!.validate()) {
                                setState(() {
                                  _isLoading = true;
                                });

                                await _authController.changeConsultant(
                                  document.uid!,
                                  'consultant',
                                );
                                _psycController.clear();
                                setState(() {
                                  _isLoading = false;
                                });
                                Get.close(1);
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
                                    text2:
                                        'Psychologist have been added successfully',
                                    asset: 'assets/svgs/success.svg',
                                    action: () {
                                      Get.close(1);
                                    },
                                  ),
                                );
                              }
                              // },
                              ),
                        ],
                      ),
                      //Leave Chat
                      // IconButton(
                      //   onPressed: () async {
                      //     if (formKey.currentState!.validate()) {
                      //       setState(() {
                      //         _isLoading = true;
                      //       });

                      //       await _authController.changeConsultant(
                      //         document.uid!,
                      //         document.username!,
                      //         document.fullName!,
                      //         'consultant',
                      //         _authController.liveUser.value!.phoneNumber!,
                      //       );
                      //       _psycController.clear();
                      //       setState(() {
                      //         _isLoading = false;
                      //       });
                      //       showModalBottomSheet(
                      //         isScrollControlled: true,
                      //         backgroundColor: AppColor().whiteColor,
                      //         shape: const RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.only(
                      //             topLeft: Radius.circular(25),
                      //             topRight: Radius.circular(25),
                      //           ),
                      //         ),
                      //         context: context,
                      //         builder: (context) => GlobalDialogue(
                      //           text1: 'Consultant/Psychologist',
                      //           text2:
                      //               'Psychologist have been added successfully',
                      //           asset: 'assets/svgs/success.svg',
                      //           action: () {
                      //             Get.close(1);
                      //           },
                      //         ),
                      //       );
                      //     }
                      //   },
                      //   icon: const Icon(
                      //     Icons.done,
                      //     color: Colors.green,
                      //   ),
                      // ),
                    ],
                  );
                });
          },
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
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }
}
