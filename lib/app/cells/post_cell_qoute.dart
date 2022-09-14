// ignore_for_file: prefer_final_fields, must_be_immutable

import 'package:agora_care/core/custom_form_field.dart';
import 'package:agora_care/services/cell_controller.dart';
import 'package:agora_care/widget/bottom_modal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../core/constant/colors.dart';
import '../../core/customWidgets.dart';

class PostCellQoute extends StatefulWidget {
  final String groupId;
  const PostCellQoute({Key? key, required this.groupId}) : super(key: key);

  @override
  State<PostCellQoute> createState() => _PostCellQouteState();
}

class _PostCellQouteState extends State<PostCellQoute> {
  final formKey = GlobalKey<FormState>();
  final _quoteTextController = TextEditingController();
  final _cellController = Get.find<CellControllers>();

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

  @override
  void dispose() {
    _quoteTextController.clear();
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
                      "Post cell quote for discussion",
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      colors: AppColor().lightTextColor,
                    ),
                    const Gap(30),
                    CustomTextField(
                      label: 'Quote',
                      hint: "Type in quote",
                      minLines: 2,
                      maxLines: 5,
                      keyType: TextInputType.text,
                      validatorText: '** Field cannot be empty',
                      color: AppColor().lightTextColor,
                      textEditingController: _quoteTextController,
                      fillColor: AppColor().fillColor,
                    ),
                    const Spacer(),
                    CustomFillButton(
                      buttonText: 'Proceed',
                      textColor: AppColor().button1Color,
                      buttonColor: AppColor().primaryColor,
                      isLoading: _isLoading,
                      onTap: () async {
                        await Future.delayed(
                          const Duration(milliseconds: 300),
                        );
                        if (kDebugMode) {
                          print('uploading quote');
                        }
                        postQuote();
                      },
                    ),
                    const Gap(40)
                  ],
                ),
              ),
            ),
    );
  }

  postQuote() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await _cellController.createCellQuote(
        cellId: widget.groupId,
        cellQuote: _quoteTextController.text,
      );
      _quoteTextController.clear();
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
          text1: 'Cell Quote successfully uploaded',
          text2: 'The quote for the day has been uploaded',
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
}
