import 'package:agora_care/core/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gap/gap.dart';

import '../../core/constant/colors.dart';
import '../../core/customWidgets.dart';

class CreateCell extends StatefulWidget {
  const CreateCell({Key? key}) : super(key: key);

  @override
  State<CreateCell> createState() => _CreateCellState();
}

class _CreateCellState extends State<CreateCell> {
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
              "Create a new cell",
              fontSize: 20,
              fontWeight: FontWeight.w700,
              colors: AppColor().lightTextColor,
            ),
            const Gap(20),
            CustomTextField(
              label: 'Cell name',
              hint: "Enter the name of this cell",
              minLines: 1,
              maxLines: 2,
              keyType: TextInputType.text,
              validatorText: '** Field cannot be empty',
              color: AppColor().lightTextColor,
              textEditingController: _qouteController,
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
              textEditingController: _qouteController,
              fillColor: AppColor().fillColor,
            ),
            const Spacer(),
            CustomFillButton(
              buttonText: 'Create Cell',
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
