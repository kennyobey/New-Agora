// ignore_for_file: unnecessary_null_comparison

import 'package:agora_care/core/constant/colors.dart';
import 'package:agora_care/services/cell_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../customWidgets.dart';

class MessageTile extends StatefulWidget {
  final String message;
  final String messageid;
  final String sender;
  final String groupId;
  final List<dynamic> like;
  final bool sentByMe;

  const MessageTile({
    Key? key,
    required this.messageid,
    required this.message,
    required this.sender,
    required this.groupId,
    required this.like,
    required this.sentByMe,
  }) : super(key: key);

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  final _cellController = Get.find<CellControllers>();
  bool isLiked = false;
  Stream<QuerySnapshot>? chats;
  FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 4,
        bottom: 4,
        left: widget.sentByMe ? 0 : 10,
        right: widget.sentByMe ? 10 : 0,
      ),
      alignment: widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: widget.sentByMe
            ? const EdgeInsets.only(left: 10)
            : const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: widget.sentByMe
              ? const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                )
              : const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
          color: widget.sentByMe
              ? AppColor().primaryColor2.withOpacity(0.3)
              : AppColor().whiteColor,
        ),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: SvgPicture.asset(
            'assets/svgs/bankofspain.svg',
            height: 50,
            width: 50,
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              customDescriptionText(
                widget.sender.toUpperCase(),
                fontSize: 14,
                fontWeight: FontWeight.w700,
                colors: AppColor().primaryColor,
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () async {
                      if (kDebugMode) {
                        print('Message ID is ${widget.messageid}');
                        print('Request Comment');
                      }
                      focusNode.requestFocus();
                      _cellController.comment(widget.groupId, widget.messageid);
                    },
                    child: SvgPicture.asset(
                      'assets/svgs/reply.svg',
                    ),
                  ),
                  const Gap(10),
                  InkWell(
                    onTap: () async {
                      if (kDebugMode) {
                        print('Message ID is ${widget.messageid}');
                      }
                      setState(() {
                        isLiked = !isLiked;
                      });
                      isLiked
                          ? _cellController.likePost(
                              widget.groupId, widget.messageid)
                          : _cellController.unLikePost(
                              widget.groupId, widget.messageid);
                      if (kDebugMode) {
                        print('Like State Changed');
                      }
                    },
                    child: isLiked
                        ? SvgPicture.asset(
                            'assets/svgs/filled_thumb.svg',
                          )
                        : SvgPicture.asset(
                            'assets/svgs/thumb.svg',
                          ),
                  ),
                ],
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customDescriptionText(
                widget.message,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                colors: AppColor().lightTextColor,
              ),
              const Gap(5),
              Row(
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
                    '${widget.like.length == null ? '0' : widget.like.length.toString()} likes',
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    colors: AppColor().lightbackgroundColor,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
