import 'package:agora_care/core/custom_form_field.dart';
import 'package:agora_care/services/quote_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../core/constant/colors.dart';
import '../../core/customWidgets.dart';

class PostQoute extends StatefulWidget {
  const PostQoute({Key? key}) : super(key: key);

  @override
  State<PostQoute> createState() => _PostQouteState();
}

class _PostQouteState extends State<PostQoute> {
  final _quoteTextController = TextEditingController();
  final _quoteController = Get.find<QuoteControllers>();

  DateTime createdTime = DateTime.now();

  String? selectedColor;
  Color color = AppColor().pinkColor;

  final List<Color> colorList = <Color>[
    AppColor().pinkColor,
    AppColor().blueColor,
    AppColor().backgroundColor,
    AppColor().primaryColor,
  ];

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
              "Post quote of the day",
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
            const Gap(20),
            Container(
              height: 45,
              decoration: BoxDecoration(
                color: color,
                border: Border.all(
                  width: 1,
                  color: AppColor().button2Color,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const Gap(30),
            Center(
              child: CustomFillButton(
                buttonText: 'Pick Color',
                textColor: AppColor().button1Color,
                buttonColor: AppColor().primaryColor,
                width: MediaQuery.of(context).size.width * 0.3,
                onTap: () {
                  pickColor(context);
                },
              ),
            ),
            const Spacer(),
            Obx(() {
              return InkWell(
                onTap: () async {
                  if (_quoteController.quoteStatus != QuoteStatus.LOADING) {
                    await Future.delayed(
                      const Duration(milliseconds: 300),
                    );
                    if (kDebugMode) {
                      print('uploading quote');
                    }
                    await _quoteController.creatQuote(
                      dailyQuote: _quoteTextController.text,
                      createdAt: createdTime,
                      // colors: color,
                    );
                  }
                },
                child: Container(
                  height: 45,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: AppColor().primaryColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: (_quoteController.quoteStatus == QuoteStatus.LOADING)
                      ? SizedBox(
                          width: 15,
                          height: 15,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColor().whiteColor,
                            ),
                          ),
                        )
                      : Center(
                          child: customDescriptionText(
                            
                            'Post Quote',
                            colors: AppColor().button1Color,
                            fontSize: 16,
                          ),
                        ),
                ),
              );
            }),
            const Gap(40)
          ],
        ),
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
}
