import 'package:agora_care/core/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../core/constant/colors.dart';
import '../../core/customWidgets.dart';

class PostQoute extends StatefulWidget {
  const PostQoute({Key? key}) : super(key: key);

  @override
  State<PostQoute> createState() => _PostQouteState();
}

class _PostQouteState extends State<PostQoute> {
  final _quoteController = TextEditingController();

  Future creatQuote({required String dailyQuote}) async {
    return;
  }

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
              textEditingController: _quoteController,
              fillColor: AppColor().fillColor,
            ),
            const Spacer(),
            CustomFillButton(
              buttonText: 'Post quote',
              textColor: AppColor().button1Color,
              buttonColor: AppColor().primaryColor,
              onTap: () {
                final dailyQuote = _quoteController.text;
              },
            ),
            const Gap(40)
          ],
        ),
      ),
    );
  }
}
