// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:agora_care/core/constant/colors.dart';
import 'package:agora_care/core/customWidgets.dart';
import 'package:agora_care/services/quote_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

// ignore: must_be_immutable
class SelectedQuoteDetails extends StatefulWidget {
  String quoteId;
  String quoteText;
  SelectedQuoteDetails({
    Key? key,
    required this.quoteId,
    required this.quoteText,
  }) : super(key: key);

  @override
  State<SelectedQuoteDetails> createState() => _SelectedQuoteDetailsState();
}

class _SelectedQuoteDetailsState extends State<SelectedQuoteDetails> {
  var scr = GlobalKey();
  final commentController = TextEditingController();

  final _quoteContoller = Get.find<QuoteControllers>();

  bool isLiked = false;

  Future getPdf(Uint8List screenShot, time, tempPath) async {
    pw.Document pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Expanded(
            child: pw.Image(
              pw.MemoryImage(screenShot),
              fit: pw.BoxFit.contain,
            ),
          );
        },
      ),
    );
    var pathurl = '$tempPath/$time.pdf';
    if (kDebugMode) {
      print('PATH URL: $pathurl');
      File pdfFile = File(pathurl);
      pdfFile.writeAsBytesSync(await pdf.save());
    }
  }

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
                      size: 18,
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
                          // customDescriptionText(
                          //   '“Be yourself everyone else is already taken.”',
                          //   fontSize: 20,
                          //   fontWeight: FontWeight.w700,
                          //   textAlign: TextAlign.center,
                          //   colors: AppColor().filledTextField,
                          // ),
                          // StreamBuilder<QuerySnapshot<Object?>>(
                          //     stream: _quoteContoller.getDailyQuote(),
                          //     builder: (context, AsyncSnapshot snapshot) {
                          //       if (snapshot.hasData) {
                          //         if (snapshot.data != null) {
                          //           return customDescriptionText(
                          //             snapshot.data!.docs.last
                          //                 .data()!['dailyQuote']
                          //                 .toString(),

                          //             // snapshot.hasData.toString(),
                          //             fontSize: 20,
                          //             fontWeight: FontWeight.w700,
                          //             textAlign: TextAlign.center,
                          //             colors: AppColor().filledTextField,
                          //           );
                          //         } else if (snapshot.data == null) {
                          //           return SvgPicture.asset(
                          //             'assets/svgs/fluent_tap-single-48-filled.svg',
                          //           );
                          //         } else {
                          //           return customDescriptionText(
                          //             'No Quote Today',
                          //             fontSize: 16,
                          //             fontWeight: FontWeight.w700,
                          //             textAlign: TextAlign.center,
                          //             colors: AppColor().whiteColor,
                          //           );
                          //         }
                          //       } else {
                          //         return Center(
                          //           child: CircularProgressIndicator(
                          //               color: AppColor().primaryColor),
                          //         );
                          //       }
                          //     }),
                          customDescriptionText(
                            widget.quoteText,
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
                                  Obx(() {
                                    return customDescriptionText(
                                      _quoteContoller.allQuotes.last.share!
                                                  .length ==
                                              null
                                          ? '0'
                                          : _quoteContoller
                                              .allQuotes.last.share!.length
                                              .toString(),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      colors: AppColor().textColor,
                                    );
                                  }),
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
                                  const Gap(5),
                                  Obx(() {
                                    return customDescriptionText(
                                      _quoteContoller.allQuotes.last.likes!
                                                  .length ==
                                              null
                                          ? '0'
                                          : _quoteContoller
                                              .allQuotes.last.likes!.length
                                              .toString(),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      colors: AppColor().textColor,
                                    );
                                  }),
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
                                    _quoteContoller
                                                .allQuotes.last.chats!.length ==
                                            null
                                        ? '0'
                                        : _quoteContoller
                                            .allQuotes.last.chats!.length
                                            .toString(),
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
                            InkWell(
                              onTap: () async {
                                await _quoteContoller.sharePost(
                                    _quoteContoller.allQuotes.last.id!);
                                RenderRepaintBoundary boundary =
                                    scr.currentContext!.findRenderObject()
                                        as RenderRepaintBoundary;
                                var image = await boundary.toImage();
                                var byteData = await image.toByteData(
                                    format: ImageByteFormat.png);
                                var pngBytes = byteData!.buffer.asUint8List();
                                String tempPath =
                                    (await getTemporaryDirectory()).path;
                                var dates = DateTime.now().toLocal().toString();
                                await getPdf(pngBytes, dates, tempPath);
                                var pathurl = '$tempPath/$dates.pdf';
                                await Share.shareFiles([pathurl]);
                              },
                              child: SvgPicture.asset(
                                'assets/svgs/share.svg',
                                height: 24,
                              ),
                            ),
                            const Gap(10),
                            InkWell(
                              onTap: () async {
                                isLiked
                                    ? _quoteContoller.likePost(
                                        _quoteContoller.allQuotes.last.id!)
                                    : _quoteContoller.unLikePost(
                                        _quoteContoller.allQuotes.last.id!);

                                setState(() {
                                  isLiked = !isLiked;
                                });
                              },
                              child: isLiked
                                  ? SvgPicture.asset(
                                      'assets/svgs/heart.svg',
                                    )
                                  : Icon(
                                      CupertinoIcons.heart_fill,
                                      color: AppColor().errorColor,
                                    ),
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