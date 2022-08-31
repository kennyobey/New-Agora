import 'package:agora_care/app/model/user_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import '../customWidgets.dart';
import 'colors.dart';

class Members extends StatelessWidget {
  Members({
    Key? key,
    // required this.title,
    // required this.active,
    // required this.streak,
    // required this.weeks,
    required this.userList,
  }) : super(key: key);

  // final String title;
  // final String active;
  // final String streak;
  // final String weeks;
  UserList userList;

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
                userList.username!,
                fontSize: 14,
                fontWeight: FontWeight.w700,
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
                    'active',
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    colors: AppColor().lightTextColor,
                  ),
                  const Gap(30),
                  SvgPicture.asset(
                    'assets/svgs/streak.svg',
                  ),
                  const Gap(5),
                  customDescriptionText(
                    userList.streak!.toString(),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    colors: AppColor().lightTextColor,
                  ),
                  const Gap(10),
                  SvgPicture.asset(
                    'assets/svgs/calender.svg',
                  ),
                  const Gap(5),
                  customDescriptionText(
                    userList.weeks!.toString(),
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
