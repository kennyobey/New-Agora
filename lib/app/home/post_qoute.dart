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
  final TextEditingController _qouteController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.only(left: 20.0, top: 50, right: 20, bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(50),
            customDescriptionText(
              "Post quote of the day",
              fontSize: 20,
              fontWeight: FontWeight.w700,
              colors: AppColor().lightTextColor,
            ),
            CustomTextField(
              label: 'Quote',
              hint: "Type in quote",
              minLines: 2,
              maxLines: 5,
              keyType: TextInputType.text,
              validatorText: '** Field cannot be empty',
              color: AppColor().lightTextColor,
              textEditingController: _qouteController,
              fillColor: AppColor().fillColor,
            ),
            const Spacer(),
            CustomFillButton(
              buttonText: 'Post quote',
              textColor: AppColor().button1Color,
              buttonColor: AppColor().primaryColor,
            ),
            const Gap(40)
          ],
        ),
      ),
    );
  }
}
