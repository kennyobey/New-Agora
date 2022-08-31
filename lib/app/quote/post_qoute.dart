import 'package:agora_care/core/custom_form_field.dart';
import 'package:agora_care/services/quote_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
            const Spacer(),
            CustomFillButton(
              buttonText: 'Post quote',
              textColor: AppColor().button1Color,
              buttonColor: AppColor().primaryColor,
              onTap: () async {
                if (kDebugMode) {
                  print('uploading quote');
                }
                final dailyQuote = _quoteTextController.text;
                await _quoteController.creatQuote(
                  dailyQuote: dailyQuote,
                  createdAt: createdTime,
                );
              },
            ),
            const Gap(40)
          ],
        ),
      ),
    );
  }
}
