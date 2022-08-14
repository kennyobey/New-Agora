import 'package:agora_care/core/constant/colors.dart';
import 'package:agora_care/core/customWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class QuoteDetails extends StatefulWidget {
  const QuoteDetails({Key? key}) : super(key: key);

  @override
  State<QuoteDetails> createState() => _QuoteDetailsState();
}

class _QuoteDetailsState extends State<QuoteDetails> {
  final commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: AppColor().primaryColor,
          // image: const DecorationImage(
          //     image: AssetImage('assets/images/need_help.png'),
          //     fit: BoxFit.cover),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Gap(50),
                Row(
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => Get.back(),
                      icon: Icon(
                        CupertinoIcons.back,
                        color: AppColor().whiteColor,
                      ),
                    ),
                    const Spacer(
                      flex: 1,
                    ),
                    const Gap(30),
                    customTitleText(
                      'Quote of the day',
                      size: 16,
                      fontWeight: FontWeight.w700,
                      colors: AppColor().whiteColor,
                    ),
                    const Spacer(
                      flex: 2,
                    ),
                  ],
                ),
                const Gap(20),
                Stack(
                  children: [
                    SvgPicture.asset(
                      'assets/svgs/quoteCard.svg',
                    ),
                    Positioned(
                      top: 35,
                      left: 100,
                      right: 100,
                      child: SvgPicture.asset(
                        'assets/svgs/quote_Icon.svg',
                      ),
                    ),
                    Positioned(
                      top: 150,
                      left: 10,
                      right: 10,
                      child: Column(
                        children: [
                          customDescriptionText(
                            '“Be yourself everyone else is already taken.”',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            textAlign: TextAlign.center,
                            colors: AppColor().filledTextField,
                          ),
                          const Gap(30),
                          Divider(
                            thickness: 1,
                            indent: 20,
                            endIndent: 20,
                            color: AppColor().whiteColor.withOpacity(0.7),
                          ),
                          const Gap(20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/svgs/share_filled.svg',
                              ),
                              const Gap(5),
                              Column(
                                children: [
                                  customDescriptionText(
                                    '1k+',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    colors: AppColor().textColor,
                                  ),
                                  customDescriptionText(
                                    'shares',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    colors: AppColor().textColor,
                                  ),
                                ],
                              ),
                              const Gap(10),
                              Container(
                                height: 30,
                                width: 1,
                                color: AppColor().lightTextColor,
                              ),
                              const Gap(10),
                              SvgPicture.asset(
                                'assets/svgs/heart_filled.svg',
                              ),
                              const Gap(5),
                              Column(
                                children: [
                                  customDescriptionText(
                                    '1k+',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    colors: AppColor().textColor,
                                  ),
                                  customDescriptionText(
                                    'likes',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    colors: AppColor().textColor,
                                  ),
                                ],
                              ),
                              const Gap(10),
                              Container(
                                height: 30,
                                width: 1,
                                color: AppColor().lightTextColor,
                              ),
                              const Gap(10),
                              SvgPicture.asset(
                                'assets/svgs/messages_filed.svg',
                              ),
                              const Gap(5),
                              Column(
                                children: [
                                  customDescriptionText(
                                    '12k+',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    colors: AppColor().textColor,
                                  ),
                                  customDescriptionText(
                                    'chats',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    colors: AppColor().textColor,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            DraggableScrollableSheet(
              maxChildSize: 0.85,
              initialChildSize: 0.35,
              minChildSize: 0.2,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColor().whiteColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    controller: scrollController,
                    scrollDirection: Axis.vertical,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            customTitleText(
                              'Discussions',
                              size: 18,
                              fontWeight: FontWeight.w700,
                              colors: AppColor().primaryColor,
                            ),
                            const Spacer(),
                            SvgPicture.asset(
                              'assets/svgs/share.svg',
                              height: 24,
                            ),
                            const Gap(10),
                            SvgPicture.asset(
                              'assets/svgs/heart.svg',
                            ),
                          ],
                        ),
                      ),
                      ...List.generate(
                        10,
                        growable: true,
                        (index) => const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: ChatWidget(),
                        ),
                      ),
                      Padding(
                        padding: mediaQueryData.viewInsets,
                        child: Form(
                          child: Container(
                            height: 80,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: AppColor().whiteColor,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  spreadRadius: 0.1,
                                  blurRadius: 5,
                                  offset: Offset(0.0, 0.05),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/chatPic.png',
                                  height: 50,
                                ),
                                const Gap(10),
                                Expanded(
                                  child: SizedBox(
                                    height: 45,
                                    child: TextFormField(
                                      autofocus: false,
                                      controller: commentController,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.done,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        fillColor: const Color(0xffFFFFFF),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppColor().lightTextColor,
                                              width: 1),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppColor().lightTextColor,
                                              width: 1),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppColor().lightTextColor,
                                              width: 1),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                        ),
                                        hintText: 'Add a comment...',
                                        suffix: customDescriptionText(
                                          'Post',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          colors: AppColor().primaryColor,
                                        ),
                                        hintStyle: const TextStyle(
                                          fontFamily: 'HK GROTESK',
                                          fontSize: 14,
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      // onFieldSubmitted: onSubmited,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
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
