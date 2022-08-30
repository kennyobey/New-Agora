// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:agora_care/core/constant/colors.dart';
import 'package:agora_care/core/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class GlobalBottomDialogue extends StatefulWidget {
  VoidCallback? back;
  VoidCallback? next;
  GlobalBottomDialogue({Key? key, required this.back, required this.next})
      : super(key: key);

  @override
  State<GlobalBottomDialogue> createState() => _GlobalBottomDialogueState();
}

class _GlobalBottomDialogueState extends State<GlobalBottomDialogue> {
  TextEditingController pinController = TextEditingController();

  StreamController<ErrorAnimationType>? pinErrorController;
  StreamController<ErrorAnimationType>? errorController;

  final _formKeyData = GlobalKey<FormState>();

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
            color: AppColor().whiteColor,
            child: Stack(
              alignment: AlignmentDirectional.topStart,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                  child: Form(
                    key: _formKeyData,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        customTitleText(
                          'What are cells?',
                          size: 32,
                          fontWeight: FontWeight.w700,
                          colors: AppColor().filledTextField,
                        ),
                        const Gap(20),
                        SvgPicture.asset('assets/svgs/cells.svg'),
                        const Gap(20),
                        customDescriptionText(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Et magna egestas senectus tellus est, mauris. Consequat eget non sapien a fermentum, pellentesque erat. Non non tortor id consectetur proin. Egestas sociis auctor volutpat mattis vitae, dolor pulvinar volutpat.',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          colors: AppColor().blackColor,
                        ),
                        const Gap(30),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CustomBorderButton(
                                  buttonText: 'Maybe later',
                                  textColor: AppColor()
                                      .filledTextField
                                      .withOpacity(0.7),
                                  borderColor: AppColor().lightbackgroundColor,
                                  width:
                                      MediaQuery.of(context).size.width * 0.33,
                                  onTap: widget.back!,
                                ),
                                // const Gap(14),
                                CustomFillButton(
                                  buttonText: 'Let’s go',
                                  textColor: AppColor().whiteColor,
                                  buttonColor: AppColor().primaryColor,
                                  width:
                                      MediaQuery.of(context).size.width * 0.33,
                                  onTap: widget.next!,
                                ),
                              ],
                            ),
                            const Gap(40),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
