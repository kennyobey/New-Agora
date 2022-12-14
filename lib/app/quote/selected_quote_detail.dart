// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously, iterable_contains_unrelated_type

import 'dart:io';
import 'dart:typed_data';

import 'package:agora_care/app/model/message_model.dart';
import 'package:agora_care/app/model/quote_model.dart';
import 'package:agora_care/app/quote/userlist.dart';
import 'package:agora_care/core/constant/colors.dart';
import 'package:agora_care/core/constant/selectedquote_comment_tile.dart';
import 'package:agora_care/core/customWidgets.dart';
import 'package:agora_care/services/auth_controller.dart';
import 'package:agora_care/services/database_service.dart';
import 'package:agora_care/services/quote_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

// ignore: must_be_immutable
class SelectedQuoteDetails extends StatefulWidget {
  final String quoteId;
  final String quoteText;
  final String groupId;
  final String userName;
  final String userImage;
  final List<dynamic> likes;
  final List<dynamic> share;
  final String reply;
  const SelectedQuoteDetails({
    Key? key,
    required this.quoteId,
    required this.quoteText,
    required this.groupId,
    required this.userName,
    required this.userImage,
    required this.likes,
    required this.share,
    required this.reply,
  }) : super(key: key);

  @override
  State<SelectedQuoteDetails> createState() => _SelectedQuoteDetailsState();
}

class _SelectedQuoteDetailsState extends State<SelectedQuoteDetails> {
  Stream<QuerySnapshot>? chat;
  var scr = GlobalKey();

  String admin = "";
  final commentController = TextEditingController();
  final ScrollController listScrollController = ScrollController();

  final _authController = Get.find<AuthControllers>();
  final _quoteContoller = Get.find<QuoteControllers>();

  List<QueryDocumentSnapshot> listMessage = [];

  _scrollListener() {
    if (!listScrollController.hasClients) return;
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange &&
        _limit <= listMessage.length) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  bool isLiked = false;
  int _limit = 20;
  final int _limitIncrement = 20;

  int reply = 0;
  List<dynamic> like = [];
  List<dynamic> share = [];
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
    listScrollController.addListener(_scrollListener);

    _quoteContoller.streamDailyQuote();
    reply = int.parse(widget.reply);
    share = widget.share;
    like = widget.likes;
    _quoteContoller.listenToQuote(widget.quoteId).listen((event) {
      final quote = QuoteModel.fromJson(event.data(), event.id);
      reply = quote.reply ?? 0;
      share = quote.share ?? [];
      like = quote.likes ?? [];
      setState(() {});
    });
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
                      top: 120,
                      left: 10,
                      right: 10,
                      child: Column(
                        children: [
                          customDescriptionText(
                            widget.quoteText,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            textAlign: TextAlign.center,
                            colors: AppColor().filledTextField,
                          ),
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
                                  customDescriptionText(
                                    share.length.toString(),
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
                                  const Gap(5),
                                  customDescriptionText(
                                    like.length.toString(),
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
                                    reply.toString(),
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
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              customTitleText(
                                'Discussions',
                                size: 18,
                                fontWeight: FontWeight.w700,
                                colors: AppColor().primaryColor,
                              ),
                              const Spacer(),
                              _authController.liveUser.value!.admin == true
                                  ? InkWell(
                                      onTap: () {
                                        Get.to(() => const AllUserList());
                                      },
                                      child: customTitleText(
                                        "View Users",
                                        size: 14,
                                        colors: AppColor().errorColor,
                                        // decoration: TextDecoration.underline,
                                      ),
                                    )
                                  : InkWell(
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
                                        await _quoteContoller
                                            .sharePost(widget.quoteId);
                                        Share.share(widget.quoteText);
                                      },
                                      child: SvgPicture.asset(
                                        'assets/svgs/share.svg',
                                        height: 24,
                                      ),
                                    ),
                              _authController.liveUser.value!.admin == true
                                  ? Container()
                                  : const Gap(10),
                              _authController.liveUser.value!.admin == true
                                  ? Container()
                                  : InkWell(
                                      onTap: () async {
                                        setState(() {
                                          isLiked = !isLiked;
                                        });
                                        isLiked
                                            ? _quoteContoller
                                                .likePost(widget.quoteId)
                                            : _quoteContoller
                                                .unLikePost(widget.quoteId);
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
                        chatComments(),
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
                                          '' ||
                                      _authController
                                          .liveUser.value!.profilePic!.isEmpty)
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
                                            controller: commentController,
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
          ],
        ),
      ),
    );
  }

  Widget chatComments() {
    return Flexible(
      child: widget.groupId.isNotEmpty
          ? StreamBuilder<QuerySnapshot>(
              stream: chat,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  listMessage = snapshot.data!.docs;
                  if (listMessage.isNotEmpty) {
                    return ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemBuilder: (context, index) => SelectedQuoteCommentTile(
                        time: snapshot.data!.docs[index]['time'],
                        message: snapshot.data!.docs[index]['message'],
                        sender: snapshot.data!.docs[index]['sender'],
                        sentByMe: widget.userName ==
                            snapshot.data!.docs[index]['sender'],
                        groupId: _quoteContoller.allQuotes.last.id!,
                        // like: const [],
                        like: snapshot.data!.docs[index]['like'],
                        messageid: snapshot.data!.docs[index].id,
                      ),
                      itemCount: snapshot.data?.docs.length,
                      reverse: false,
                      controller: listScrollController,
                    );
                  } else {
                    return const Center(child: Text("No message here yet..."));
                  }
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColor().primaryColor,
                    ),
                  );
                }
              },
            )
          : Center(
              child: CircularProgressIndicator(
                color: AppColor().primaryColor,
              ),
            ),
    );
  }

  sendComment() {
    if (commentController.text.isNotEmpty) {
      final chatMessageMap = SelectedCommentModel(
        message: commentController.text,
        sender: widget.userName,
        time: DateTime.now(),
        like: [],
        comment: [],
      );
      if (listScrollController.hasClients) {
        listScrollController.animateTo(0,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }

      DatabaseService().sendComment(widget.groupId, chatMessageMap.toJson());
      _quoteContoller.chatList(
        widget.quoteId,
      );
      setState(() {
        commentController.clear();
      });

      SystemChannels.textInput.invokeMethod('TextInput.hide');
    }
  }
}
