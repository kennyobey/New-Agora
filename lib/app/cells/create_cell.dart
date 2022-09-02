import 'package:agora_care/core/custom_form_field.dart';
import 'package:agora_care/services/auth_controller.dart';
import 'package:agora_care/services/database_service.dart';
import 'package:agora_care/services/quote_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../core/constant/colors.dart';
import '../../core/customWidgets.dart';

class CreateCell extends StatefulWidget {
  const CreateCell({Key? key}) : super(key: key);

  @override
  State<CreateCell> createState() => _CreateCellState();
}

class _CreateCellState extends State<CreateCell> {
  final _cellNameController = TextEditingController();
  final _qouteTextController = TextEditingController();
  final _authController = Get.find<AuthControllers>();
  final _qouteController = Get.find<QuoteControllers>();

  bool _isLoading = false;

  String email = "";
  String userName = "";
  String groupName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor().whiteColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customDescriptionText(
              "Create a new cell",
              fontSize: 20,
              fontWeight: FontWeight.w700,
              colors: AppColor().lightTextColor,
            ),
            const Gap(30),
            CustomTextField(
              label: 'Cell name',
              hint: "Enter the name of this cell",
              minLines: 1,
              maxLines: 2,
              keyType: TextInputType.text,
              validatorText: '** Field cannot be empty',
              color: AppColor().lightTextColor,
              textEditingController: _cellNameController,
              fillColor: AppColor().fillColor,
            ),
            const Gap(20),
            CustomTextField(
              label: 'Description',
              hint: "Enter cell description",
              minLines: 2,
              maxLines: 5,
              keyType: TextInputType.text,
              validatorText: '** Field cannot be empty',
              color: AppColor().lightTextColor,
              textEditingController: _qouteTextController,
              fillColor: AppColor().fillColor,
            ),
            const Spacer(),
            CustomFillButton(
              isLoading: _isLoading,
              buttonText: 'Create Cell',
              textColor: AppColor().button1Color,
              buttonColor: AppColor().primaryColor,
              onTap: () async {
                if (kDebugMode) {
                  print('Creating Cell');
                }
                setState(() {
                  _isLoading = true;
                });
                DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                    .createGroup(
                  _authController.liveUser.value!.email!,
                  FirebaseAuth.instance.currentUser!.uid,
                  _cellNameController.text,
                )
                    .whenComplete(() {
                  _isLoading = false;
                  setState(() {});
                  Get.back();
                });
              },
            ),
            const Gap(40)
          ],
        ),
      ),
    );
  }
}
