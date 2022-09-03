// ignore_for_file: must_be_immutable

import 'package:agora_care/core/constant/colors.dart';
import 'package:agora_care/core/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class GlobalDialogue extends StatefulWidget {
  String? text1;
  String? text2;
  String? asset;
  VoidCallback? action;
  GlobalDialogue({
    Key? key,
    required this.text1,
    required this.text2,
    required this.asset,
    required this.action,
  }) : super(key: key);

  @override
  State<GlobalDialogue> createState() => _GlobalDialogueState();
}

class _GlobalDialogueState extends State<GlobalDialogue> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Listener(
      onPointerUp: (_) {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          currentFocus.focusedChild?.unfocus();
        }
      },
      child: Padding(
        padding: mediaQueryData.viewInsets,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: AppColor().whiteColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Gap(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => Get.close(1),
                      child: SvgPicture.asset(
                        'assets/svgs/close.svg',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                SvgPicture.asset(
                  widget.asset!,
                ),
                const Gap(30),
                customTitleText(
                  widget.text1!,
                  size: 20,
                  fontWeight: FontWeight.w700,
                  colors: AppColor().filledTextField,
                ),
                const Gap(10),
                customDescriptionText(
                  widget.text2!,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  colors: AppColor().blackColor,
                ),
                const Gap(50),
                CustomBorderButton(
                  buttonText: 'Close',
                  textColor: AppColor().filledTextField.withOpacity(0.7),
                  borderColor: AppColor().lightbackgroundColor,
                  onTap: widget.action!,
                ),
                const Gap(60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
