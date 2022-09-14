// ignore_for_file: unnecessary_null_comparison

import 'package:agora_care/app/model/message_model.dart';
import 'package:agora_care/core/constant/colors.dart';
import 'package:agora_care/services/auth_controller.dart';
import 'package:agora_care/services/quote_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../customWidgets.dart';

class QuoteCommentTile extends StatefulWidget {
  final String message;
  final String messageid;
  final String sender;
  final String groupId;
  final String? time;
  final List<dynamic> like;
  final bool sentByMe;

  const QuoteCommentTile({
    Key? key,
    required this.messageid,
    required this.message,
    required this.sender,
    required this.groupId,
    required this.like,
    required this.time,
    required this.sentByMe,
  }) : super(key: key);

  @override
  State<QuoteCommentTile> createState() => _QuoteCommentTileState();
}

class _QuoteCommentTileState extends State<QuoteCommentTile> {
  final _authController = Get.find<AuthControllers>();
  final _quoteController = Get.find<QuoteControllers>();
  bool isLiked = false;
  Stream<QuerySnapshot>? chat;

  CommentModel? _messageModel;

  @override
  void initState() {
    _quoteController.quotesCollection
        .doc(widget.like.toString())
        .snapshots()
        .listen((event) {
      _messageModel = CommentModel.fromJson(event.data(), event.id);
      setState(() {});
    });
    super.initState();
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
          leading: _authController.liveUser.value!.profilePic == null
              ? Image.asset(
                  'assets/images/placeholder.png',
                  height: 50,
                  width: 50,
                )
              : Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(80),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        _authController.liveUser.value!.profilePic!,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
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
                      }
                      _quoteController.comment(
                          widget.groupId, widget.messageid);
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
                          ? _quoteController.likeQuotePost(
                              widget.groupId, widget.messageid)
                          : _quoteController.unLikeQuotePost(
                              widget.groupId, widget.messageid);
                      setState(() {});
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
                    widget.time == null
                        ? '0hrs'
                        : DateFormat.jm()
                            .format(DateTime.parse(widget.time!.toString())),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    colors: AppColor().lightbackgroundColor,
                  ),
                  const Gap(20),
                  // customDescriptionText(
                  //   '${widget.like == null ? '0' : widget.like.length.toString()} likes',
                  //   fontSize: 10,
                  //   fontWeight: FontWeight.w500,
                  //   colors: AppColor().lightbackgroundColor,
                  // ),
                  // customDescriptionText(
                  //   _messageModel == null
                  //       ? '0'
                  //       : _messageModel!.like!.length.toString(),
                  //   fontSize: 10,
                  //   fontWeight: FontWeight.w500,
                  //   colors: AppColor().lightbackgroundColor,
                  // ),

                  StreamBuilder(
                    stream: chat,
                    builder: (context, snapshot) {
                      return snapshot.hasData
                          ? customDescriptionText(
                              '${widget.like == null ? '0' : widget.like.length.toString()} likes',
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              colors: AppColor().lightbackgroundColor,
                            )
                          : customDescriptionText(
                              '${widget.like == null ? '0' : widget.like.length.toString()} likes',
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              colors: AppColor().lightbackgroundColor,
                            );
                    },
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
