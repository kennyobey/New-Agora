import 'package:agora_care/app/group_screen/chat_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../customWidgets.dart';
import 'colors.dart';

class Cells extends StatelessWidget {
  Cells({
    Key? key,
    required this.groupId,
    required this.members,
    required this.time,
    required this.groupName,
    required this.assetName,
    required this.userName,
  }) : super(key: key);

  final String members;
  final String time;
  final String? groupId;
  final String? groupName;
  final String? assetName;
  final String? userName;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (kDebugMode) {
          print('Joining Group');
        }
        Get.to(
          () => ChatPage(
            groupId: groupId!,
            groupName: groupName!,
            userName: userName!,
          ),
        );
      },
      child: Row(
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
                  groupName!,
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
          ]),
    );
  }
}
