import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import '../customWidgets.dart';
import 'colors.dart';

class Cells extends StatelessWidget {
  const Cells(
      {Key? key,
      required this.title,
      required this.members,
      required this.time})
      : super(key: key);

  final String title;
  final String members;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SvgPicture.asset(
            'assets/svgs/bankofspain.svg',
            height: 50,
            width: 50,
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customDescriptionText(
                title,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                colors: AppColor().lightTextColor,
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  customDescriptionText(
                    members,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    colors: AppColor().lightTextColor,
                  ),
                  const Gap(30),
                  customDescriptionText(
                    time,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    colors: AppColor().lightTextColor,
                  ),
                ],
              ),
            ],
          ),
        ]);
  }
}
