// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';

import 'package:agora_care/core/constant/colors.dart';
import 'package:agora_care/core/constant/quote_comment_tile.dart';
import 'package:agora_care/core/customWidgets.dart';
import 'package:agora_care/services/auth_controller.dart';
import 'package:agora_care/services/database_service.dart';
import 'package:agora_care/services/quote_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

class QuoteDetails extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;
  final String userImage;
  final String assetName;
  final String dailyQuote;
  const QuoteDetails({
    Key? key,
    required this.groupId,
    required this.groupName,
    required this.userName,
    required this.userImage,
    required this.assetName,
    required this.dailyQuote,
  }) : super(key: key);

  @override
  State<QuoteDetails> createState() => _QuoteDetailsState();
}

class _QuoteDetailsState extends State<QuoteDetails> {
  var scr = GlobalKey();
  final messageController = TextEditingController();
  Stream<QuerySnapshot>? chat;
  String admin = "";

  final _authController = Get.find<AuthControllers>();
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
  void initState() {
    getChatandAdmin();
    // chat = _quoteContoller.getGroupMembers(widget.groupId);
    super.initState();
  }

  getChatandAdmin() {
    DatabaseService().getComment(widget.groupId).then((val) {
      setState(() {
        chat = val;
      });
    });
    DatabaseService().getQuoteAdmin(widget.groupId).then((val) {
      setState(() {
        admin = val;
      });
    });
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
                    Hero(
                      tag: "img",
                      child: SvgPicture.asset(
                        'assets/svgs/quoteCard.svg',
                      ),
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
                      top: 120,
                      left: 10,
                      right: 10,
                      child: Column(
                        children: [
                          StreamBuilder<QuerySnapshot<Object?>>(
                              stream: _quoteContoller.getDailyQuote(),
                              builder: (context, AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  if (snapshot.data != null) {
                                    return customDescriptionText(
                                      snapshot.data!.docs.last
                                          .data()!['dailyQuote']
                                          .toString(),

                                      // snapshot.hasData.toString(),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      textAlign: TextAlign.center,
                                      colors: AppColor().filledTextField,
                                    );
                                  } else if (snapshot.data == null) {
                                    return SvgPicture.asset(
                                      'assets/svgs/fluent_tap-single-48-filled.svg',
                                    );
                                  } else {
                                    return customDescriptionText(
                                      'No Quote Today',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      textAlign: TextAlign.center,
                                      colors: AppColor().whiteColor,
                                    );
                                  }
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(
                                        color: AppColor().primaryColor),
                                  );
                                }
                              }),
                          const Gap(20),
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
                Expanded(
                    child: Padding(
                  padding: mediaQueryData.viewInsets,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.only(left: 0, right: 0, top: 10),
                    child: Column(
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
                                // onTap: () async {
                                //   await _quoteContoller.sharePost(
                                //       _quoteContoller.allQuotes.last.id!);
                                //   RenderRepaintBoundary boundary =
                                //       scr.currentContext!.findRenderObject()
                                //           as RenderRepaintBoundary;
                                //   var image = await boundary.toImage();
                                //   var byteData = await image.toByteData(
                                //       format: ImageByteFormat.png);
                                //   var pngBytes = byteData!.buffer.asUint8List();
                                //   String tempPath =
                                //       (await getTemporaryDirectory()).path;
                                //   var dates =
                                //       DateTime.now().toLocal().toString();
                                //   await getPdf(pngBytes, dates, tempPath);
                                //   var pathurl = '$tempPath/$dates.pdf';
                                //   await Share.shareFiles([pathurl]);
                                // },
                                onTap: () async {
                                  await Share.share(widget.dailyQuote);
                                },
                                child: SvgPicture.asset(
                                  'assets/svgs/share.svg',
                                  height: 24,
                                ),
                              ),
                              const Gap(10),
                              InkWell(
                                onTap: () async {
                                  setState(() {
                                    isLiked = !isLiked;
                                  });
                                  isLiked
                                      ? _quoteContoller.likePost(
                                          _quoteContoller.allQuotes.last.id!)
                                      : _quoteContoller.unLikePost(
                                          _quoteContoller.allQuotes.last.id!);
                                },
                                child: isLiked
                                    ? Icon(
                                        CupertinoIcons.heart_fill,
                                        color: AppColor().errorColor,
                                      )
                                    : SvgPicture.asset(
                                        'assets/svgs/heart.svg',
                                      ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: chatMComments(),
                        ),
                        Container(
                          padding: const EdgeInsets.all(5),
                          alignment: Alignment.bottomCenter,
                          height: 70,
                          decoration: BoxDecoration(
                            border: Border.all(width: 0.7),
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              (_authController.liveUser.value!.profilePic ==
                                          null ||
                                      _authController
                                              .liveUser.value!.profilePic ==
                                          '')
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
                                            _authController
                                                .liveUser.value!.profilePic!,
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                              const Gap(5),
                              Expanded(
                                child: Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    color: AppColor().chatBox,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 0),
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            controller: messageController,
                                            textInputAction:
                                                TextInputAction.send,
                                            style: TextStyle(
                                              color: AppColor().backgroundColor,
                                            ),
                                            decoration: InputDecoration(
                                              hintText: "Say something...",
                                              hintStyle: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.grey[700],
                                              ),
                                              border: InputBorder.none,
                                            ),
                                            onFieldSubmitted: (value) {
                                              sendComment();
                                            },
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            sendComment();
                                          },
                                          child: customDescriptionText(
                                            'Post',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            colors: AppColor().backgroundColor,
                                          ),
                                        )
                                      ]),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
              ],
            ),
            // DraggableScrollableSheet(
            //   maxChildSize: 0.85,
            //   initialChildSize: 0.35,
            //   minChildSize: 0.2,
            //   builder:
            //       (BuildContext context, ScrollController scrollController) {
            //     return Container(
            //       height: double.infinity,
            //       decoration: BoxDecoration(
            //         color: AppColor().whiteColor,
            //         borderRadius: const BorderRadius.only(
            //           topLeft: Radius.circular(20),
            //           topRight: Radius.circular(20),
            //         ),
            //       ),
            //       child: ListView(
            //         padding: EdgeInsets.zero,
            //         controller: scrollController,
            //         scrollDirection: Axis.vertical,
            //         children: [
            //           Padding(
            //             padding: const EdgeInsets.symmetric(
            //                 vertical: 20, horizontal: 20),
            //             child: Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //               children: [
            //                 customTitleText(
            //                   'Discussions',
            //                   size: 18,
            //                   fontWeight: FontWeight.w700,
            //                   colors: AppColor().primaryColor,
            //                 ),
            //                 const Spacer(),
            //                 InkWell(
            //                   onTap: () async {
            //                     await _quoteContoller.sharePost(
            //                         _quoteContoller.allQuotes.last.id!);
            //                     RenderRepaintBoundary boundary =
            //                         scr.currentContext!.findRenderObject()
            //                             as RenderRepaintBoundary;
            //                     var image = await boundary.toImage();
            //                     var byteData = await image.toByteData(
            //                         format: ImageByteFormat.png);
            //                     var pngBytes = byteData!.buffer.asUint8List();
            //                     String tempPath =
            //                         (await getTemporaryDirectory()).path;
            //                     var dates = DateTime.now().toLocal().toString();
            //                     await getPdf(pngBytes, dates, tempPath);
            //                     var pathurl = '$tempPath/$dates.pdf';
            //                     await Share.shareFiles([pathurl]);
            //                   },
            //                   child: SvgPicture.asset(
            //                     'assets/svgs/share.svg',
            //                     height: 24,
            //                   ),
            //                 ),
            //                 const Gap(10),
            //                 InkWell(
            //                   onTap: () async {
            //                     isLiked
            //                         ? _quoteContoller.likePost(
            //                             _quoteContoller.allQuotes.last.id!)
            //                         : _quoteContoller.unLikePost(
            //                             _quoteContoller.allQuotes.last.id!);

            //                     setState(() {
            //                       isLiked = !isLiked;
            //                     });
            //                   },
            //                   child: isLiked
            //                       ? SvgPicture.asset(
            //                           'assets/svgs/heart.svg',
            //                         )
            //                       : Icon(
            //                           CupertinoIcons.heart_fill,
            //                           color: AppColor().errorColor,
            //                         ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //           // ...List.generate(
            //           //   10,
            //           //   growable: true,
            //           //   (index) => const Padding(
            //           //     padding: EdgeInsets.only(bottom: 10),
            //           //     child: ChatWidget(
            //           //       groupId: '',
            //           //       groupName: '',
            //           //       userName: '',
            //           //     ),
            //           //   ),
            //           // ),
            //           // Padding(
            //           //   padding: mediaQueryData.viewInsets,
            //           //   child: Form(
            //           //     child: Container(
            //           //       height: 80,
            //           //       padding: const EdgeInsets.symmetric(horizontal: 10),
            //           //       decoration: BoxDecoration(
            //           //         color: AppColor().whiteColor,
            //           //         boxShadow: const [
            //           //           BoxShadow(
            //           //             color: Colors.black26,
            //           //             spreadRadius: 0.1,
            //           //             blurRadius: 5,
            //           //             offset: Offset(0.0, 0.05),
            //           //           ),
            //           //         ],
            //           //       ),
            //           //       child: Column(
            //           //         children: [
            //           //           Expanded(
            //           //             child:
            //           //                 // chat messages here
            //           //                 chatMessages(),
            //           //           ),
            //           //           Row(
            //           //             children: [
            //           //               // Image.asset(
            //           //               //   'assets/images/chatPic.png',
            //           //               //   height: 50,
            //           //               // ),
            //           //               const Gap(10),

            //           //               Expanded(
            //           //                 child: Container(
            //           //                   padding: const EdgeInsets.all(5),
            //           //                   alignment: Alignment.bottomCenter,
            //           //                   height: 70,
            //           //                   decoration: BoxDecoration(
            //           //                     border: Border.all(width: 0.7),
            //           //                     color: Colors.white,
            //           //                   ),
            //           //                   child: Row(
            //           //                     mainAxisAlignment:
            //           //                         MainAxisAlignment.spaceBetween,
            //           //                     children: [
            //           //                       SvgPicture.asset(
            //           //                         'assets/svgs/bankofspain.svg',
            //           //                         height: 50,
            //           //                         width: 50,
            //           //                       ),
            //           //                       const Gap(5),
            //           //                       Expanded(
            //           //                         child: Container(
            //           //                           height: 60,
            //           //                           decoration: BoxDecoration(
            //           //                             borderRadius:
            //           //                                 BorderRadius.circular(40),
            //           //                             color: AppColor().chatBox,
            //           //                           ),
            //           //                           padding:
            //           //                               const EdgeInsets.symmetric(
            //           //                                   horizontal: 25,
            //           //                                   vertical: 0),
            //           //                           width: MediaQuery.of(context)
            //           //                               .size
            //           //                               .width,
            //           //                           child: Row(
            //           //                               mainAxisAlignment:
            //           //                                   MainAxisAlignment
            //           //                                       .center,
            //           //                               crossAxisAlignment:
            //           //                                   CrossAxisAlignment
            //           //                                       .center,
            //           //                               children: [
            //           //                                 Expanded(
            //           //                                   child: TextFormField(
            //           //                                     controller:
            //           //                                         messageController,
            //           //                                     textInputAction:
            //           //                                         TextInputAction
            //           //                                             .send,
            //           //                                     style: TextStyle(
            //           //                                       color: AppColor()
            //           //                                           .backgroundColor,
            //           //                                     ),
            //           //                                     decoration:
            //           //                                         InputDecoration(
            //           //                                       hintText:
            //           //                                           "Say something...",
            //           //                                       hintStyle:
            //           //                                           TextStyle(
            //           //                                         fontSize: 14,
            //           //                                         fontWeight:
            //           //                                             FontWeight
            //           //                                                 .w400,
            //           //                                         color: Colors
            //           //                                             .grey[700],
            //           //                                       ),
            //           //                                       border: InputBorder
            //           //                                           .none,
            //           //                                     ),
            //           //                                     onFieldSubmitted:
            //           //                                         (value) {
            //           //                                       sendMessage();
            //           //                                     },
            //           //                                   ),
            //           //                                 ),
            //           //                                 const SizedBox(
            //           //                                   width: 12,
            //           //                                 ),
            //           //                                 GestureDetector(
            //           //                                   onTap: () {
            //           //                                     sendMessage();
            //           //                                   },
            //           //                                   child:
            //           //                                       customDescriptionText(
            //           //                                     'Post',
            //           //                                     fontSize: 12,
            //           //                                     fontWeight:
            //           //                                         FontWeight.w600,
            //           //                                     colors: AppColor()
            //           //                                         .backgroundColor,
            //           //                                   ),
            //           //                                   // Container(
            //           //                                   //   height: 50,
            //           //                                   //   width: 50,
            //           //                                   //   decoration: BoxDecoration(
            //           //                                   //     color: Theme.of(context).primaryColor,
            //           //                                   //     borderRadius: BorderRadius.circular(30),
            //           //                                   //   ),
            //           //                                   //   child: const Center(
            //           //                                   //       child: Icon(
            //           //                                   //     Icons.send,
            //           //                                   //     color: Colors.white,
            //           //                                   //   )),
            //           //                                   // ),
            //           //                                 )
            //           //                               ]),
            //           //                         ),
            //           //                       ),
            //           //                     ],
            //           //                   ),
            //           //                 ),
            //           //                 // child: SizedBox(
            //           //                 //   height: 45,
            //           //                 //   child: TextFormField(
            //           //                 //     autofocus: false,
            //           //                 //     controller: messageController,
            //           //                 //     keyboardType: TextInputType.text,
            //           //                 //     textInputAction: TextInputAction.done,
            //           //                 //     decoration: InputDecoration(
            //           //                 //       isDense: true,
            //           //                 //       fillColor: const Color(0xffFFFFFF),
            //           //                 //       focusedBorder: OutlineInputBorder(
            //           //                 //         borderSide: BorderSide(
            //           //                 //             color: AppColor().lightTextColor,
            //           //                 //             width: 1),
            //           //                 //         borderRadius: const BorderRadius.all(
            //           //                 //           Radius.circular(20),
            //           //                 //         ),
            //           //                 //       ),
            //           //                 //       enabledBorder: OutlineInputBorder(
            //           //                 //         borderSide: BorderSide(
            //           //                 //             color: AppColor().lightTextColor,
            //           //                 //             width: 1),
            //           //                 //         borderRadius: const BorderRadius.all(
            //           //                 //           Radius.circular(20),
            //           //                 //         ),
            //           //                 //       ),
            //           //                 //       border: OutlineInputBorder(
            //           //                 //         borderSide: BorderSide(
            //           //                 //             color: AppColor().lightTextColor,
            //           //                 //             width: 1),
            //           //                 //         borderRadius: const BorderRadius.all(
            //           //                 //           Radius.circular(20),
            //           //                 //         ),
            //           //                 //       ),
            //           //                 //       hintText: 'Add a comment...',
            //           //                 //       suffix: InkWell(
            //           //                 //         onTap: (() {
            //           //                 //           print("Message sent");
            //           //                 //           sendMessage();
            //           //                 //         }),
            //           //                 //         child: customDescriptionText(
            //           //                 //           'Post',
            //           //                 //           fontSize: 12,
            //           //                 //           fontWeight: FontWeight.w600,
            //           //                 //           colors: AppColor().primaryColor,
            //           //                 //         ),
            //           //                 //       ),
            //           //                 //       hintStyle: const TextStyle(
            //           //                 //         fontFamily: 'HK GROTESK',
            //           //                 //         fontSize: 14,
            //           //                 //         fontStyle: FontStyle.normal,
            //           //                 //         fontWeight: FontWeight.normal,
            //           //                 //       ),
            //           //                 //     ),
            //           //                 //     // onFieldSubmitted: onSubmited,
            //           //                 //   ),
            //           //                 // ),
            //           //               ),
            //           //             ],
            //           //           ),
            //           //         ],
            //           //       ),
            //           //     ),
            //           //   ),
            //           // ),
            //           Expanded(child: chatMessages()),
            //           SizedBox(
            //             height: 45,
            //             child: TextFormField(
            //               autofocus: false,
            //               controller: messageController,
            //               keyboardType: TextInputType.text,
            //               textInputAction: TextInputAction.done,
            //               decoration: InputDecoration(
            //                 isDense: true,
            //                 fillColor: const Color(0xffFFFFFF),
            //                 focusedBorder: OutlineInputBorder(
            //                   borderSide: BorderSide(
            //                       color: AppColor().lightTextColor, width: 1),
            //                   borderRadius: const BorderRadius.all(
            //                     Radius.circular(20),
            //                   ),
            //                 ),
            //                 enabledBorder: OutlineInputBorder(
            //                   borderSide: BorderSide(
            //                       color: AppColor().lightTextColor, width: 1),
            //                   borderRadius: const BorderRadius.all(
            //                     Radius.circular(20),
            //                   ),
            //                 ),
            //                 border: OutlineInputBorder(
            //                   borderSide: BorderSide(
            //                       color: AppColor().lightTextColor, width: 1),
            //                   borderRadius: const BorderRadius.all(
            //                     Radius.circular(20),
            //                   ),
            //                 ),
            //                 hintText: 'Add a comment...',
            //                 suffix: InkWell(
            //                   onTap: (() {
            //                     print("Message sent");
            //                     sendMessage();
            //                   }),
            //                   child: customDescriptionText(
            //                     'Post',
            //                     fontSize: 12,
            //                     fontWeight: FontWeight.w600,
            //                     colors: AppColor().primaryColor,
            //                   ),
            //                 ),
            //                 hintStyle: const TextStyle(
            //                   fontFamily: 'HK GROTESK',
            //                   fontSize: 14,
            //                   fontStyle: FontStyle.normal,
            //                   fontWeight: FontWeight.normal,
            //                 ),
            //               ),
            //               onFieldSubmitted: (value) => sendMessage(),
            //             ),
            //           ),
            //         ],
            //       ),
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  chatMComments() {
    return StreamBuilder(
      stream: chat,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return QuoteCommentTile(
                    message: snapshot.data.docs[index]['message'],
                    sender: snapshot.data.docs[index]['sender'],
                    sentByMe:
                        widget.userName == snapshot.data.docs[index]['sender'],
                    groupId: '',
                    like: const [],
                    messageid: '',
                  );
                },
              )
            : Container();
      },
    );
  }

  sendComment() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": widget.userName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseService().sendComment(widget.groupId, chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }
  }
}
