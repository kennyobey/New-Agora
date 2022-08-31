import 'package:agora_care/core/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import '../customWidgets.dart';

class MessageTile extends StatefulWidget {
  final String message;
  final String sender;
  final bool sentByMe;

  const MessageTile(
      {Key? key,
      required this.message,
      required this.sender,
      required this.sentByMe})
      : super(key: key);

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: widget.sentByMe ? 0 : 24,
          right: widget.sentByMe ? 24 : 0),
      alignment: widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: widget.sentByMe
            ? const EdgeInsets.only(left: 30)
            : const EdgeInsets.only(right: 30),
        padding:
            const EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: widget.sentByMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  )
                : const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
            color:
                // color: widget.sentByMe
                //     ? Theme.of(context).primaryColor
                Colors.white),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/svgs/bankofspain.svg',
              height: 50,
              width: 50,
            ),
            const Gap(5),
            Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customDescriptionText(
                  widget.sender,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  colors: AppColor().lightTextColor,
                ),
                customDescriptionText(
                  widget.message,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  colors: AppColor().lightTextColor,
                ),
                customDescriptionText(
                  widget.message,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  colors: AppColor().lightTextColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ChatWidget extends StatefulWidget {
  const ChatWidget({Key? key}) : super(key: key);

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Expanded(
        //   child: ListView.builder(
        //       padding: EdgeInsets.zero,
        //       scrollDirection: Axis.vertical,
        //       itemCount: 10,
        //       itemBuilder: (BuildContext context, int index) {
        //         return
        ListTile(
          leading: Image.asset('assets/images/chatPic.png'),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  customTitleText(
                    'Melish karuntha',
                    size: 14,
                    fontWeight: FontWeight.w700,
                    colors: AppColor().primaryColor,
                  ),
                  const Gap(10),
                  SvgPicture.asset(
                    'assets/svgs/comment_verify.svg',
                  ),
                  const Spacer(),
                  SvgPicture.asset(
                    'assets/svgs/reply.svg',
                  ),
                  const Gap(10),
                  SvgPicture.asset(
                    'assets/svgs/thumb.svg',
                  ),
                ],
              ),
              customDescriptionText(
                'Lorem ipsum ad amet sit lorema akad mu il shaprew',
                width: MediaQuery.of(context).size.width * 0.6,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                colors: AppColor().primaryColor,
              ),
            ],
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              customDescriptionText(
                '19hrs',
                fontSize: 10,
                fontWeight: FontWeight.w500,
                colors: AppColor().lightbackgroundColor,
              ),
              const Gap(20),
              customDescriptionText(
                '143 likes',
                fontSize: 10,
                fontWeight: FontWeight.w500,
                colors: AppColor().lightbackgroundColor,
              ),
              // const Spacer(),
            ],
          ),
          // trailing: Row(
          //   children: [
          //     SvgPicture.asset(
          //       'assets/svgs/reply.svg',
          //     ),
          //     SvgPicture.asset(
          //       'assets/svgs/thumb.svg',
          //     ),
          //   ],
          // ),
          isThreeLine: true,
        ),
        //         ;
        //       }),
        // ),
      ],
    );
  }
}
