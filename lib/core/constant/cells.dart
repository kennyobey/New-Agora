import 'package:agora_care/app/group_screen/chat_page.dart';
import 'package:agora_care/core/constant/colors.dart';
import 'package:agora_care/core/customWidgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class Cells extends StatelessWidget {
  Cells(
      {Key? key,
      required this.groupId,
      required this.members,
      required this.time,
      required this.groupName,
      required this.assetName,
      required this.userName,
      required this.memberId})
      : super(key: key);

  final String members;
  final String time;
  final String? groupId;
  final String? groupName;
  final String? assetName;
  final String? userName;
  List<String>? memberId;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (kDebugMode) {
          print('Joining Group');
          print("me");
        }
        Get.to(
          () => ChatPage(
            groupId: groupId!,
            groupName: groupName!,
            userName: userName!,
            member: memberId!,
          ),
        );
      },
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/svgs/bankofspain.svg',
            height: 50,
            width: 50,
          ),
          const Gap(10),
          Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customDescriptionText(
                groupName!.toUpperCase(),
                fontSize: 14,
                fontWeight: FontWeight.w600,
                colors: AppColor().lightTextColor,
              ),
              const Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.people_alt_outlined,
                        color: AppColor().lightTextColor,
                        size: 14,
                      ),
                      const Gap(10),
                      customDescriptionText(
                        "$members members",
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        colors: AppColor().lightTextColor,
                      ),
                    ],
                  ),
                  const Gap(40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
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
            ],
          ),
        ],
      ),
      // child: Row(
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       SvgPicture.asset(
      //         'assets/svgs/bankofspain.svg',
      //         height: 50,
      //         width: 50,
      //       ),
      //       const Gap(15),
      //       Row(
      //         children: [
      //           Column(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               customDescriptionText(
      //                 groupName!,
      //                 fontSize: 14,
      //                 fontWeight: FontWeight.w600,
      //                 colors: AppColor().lightTextColor,
      //               ),
      //               const SizedBox(
      //                 height: 5,
      //               ),
      //               Row(
      //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                 crossAxisAlignment: CrossAxisAlignment.end,
      //                 children: [
      //                   Row(
      //                     children: [
      //                       Icon(
      //                         Icons.people_alt_outlined,
      //                         color: AppColor().lightTextColor,
      //                         size: 14,
      //                       ),
      //                       const Gap(10),
      //                       customDescriptionText(
      //                         "$members members",
      //                         fontSize: 10,
      //                         fontWeight: FontWeight.w600,
      //                         colors: AppColor().lightTextColor,
      //                       ),
      //                     ],
      //                   ),
      //                   const Gap(30),
      //                   customDescriptionText(
      //                     time,
      //                     fontSize: 10,
      //                     fontWeight: FontWeight.w600,
      //                     colors: AppColor().lightTextColor,
      //                   ),
      //                 ],
      //               ),
      //             ],
      //           ),
      //         ],
      //       ),
      //     ]),
    );
  }
}
