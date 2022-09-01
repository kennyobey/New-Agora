import 'package:agora_care/core/custom_form_field.dart';
import 'package:agora_care/services/quote_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../core/constant/colors.dart';
import '../../core/customWidgets.dart';

class PostQoute extends StatefulWidget {
  const PostQoute({Key? key}) : super(key: key);

  @override
  State<PostQoute> createState() => _PostQouteState();
}

class _PostQouteState extends State<PostQoute> {
  final _quoteTextController = TextEditingController();
  final _quoteController = Get.find<QuoteControllers>();

  DateTime createdTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor().whiteColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customDescriptionText(
              "Post quote of the day",
              fontSize: 20,
              fontWeight: FontWeight.w700,
              colors: AppColor().lightTextColor,
            ),
            const Gap(30),
            CustomTextField(
              label: 'Quote',
              hint: "Type in quote",
              minLines: 2,
              maxLines: 5,
              keyType: TextInputType.text,
              validatorText: '** Field cannot be empty',
              color: AppColor().lightTextColor,
              textEditingController: _quoteTextController,
              fillColor: AppColor().fillColor,
            ),
            const Spacer(),
            // Obx(() {
            //   return InkWell(
            //     onTap: () async {
            //       if (_quoteController.quoteQuoteStatus != QuoteQuoteStatus.LOADING) {
            //         if (kDebugMode) {
            //           print('uploading quote');
            //         }
            //         await _quoteController.creatQuote(
            //           dailyQuote: _quoteTextController.text,
            //           createdAt: createdTime,
            //         );
            //       }
            //     },
            //     child: CustomFillButton(
            //       buttonText: 'Post quote',
            //       textColor: AppColor().button1Color,
            //       buttonColor: AppColor().primaryColor,
            //       // onTap: () async {
            //       //   if (_quoteController.quoteQuoteStatus != QuoteQuoteStatus.LOADING) {
            //       //     if (kDebugMode) {
            //       //       print('uploading quote');
            //       //     }
            //       //     await _quoteController.creatQuote(
            //       //       dailyQuote: _quoteTextController.text,
            //       //       createdAt: createdTime,
            //       //     );
            //       //     // } else {
            //       //     //   (_quoteController.quoteQuoteStatus == QuoteQuoteStatus.LOADING)
            //       //     //       ? SizedBox(
            //       //     //           width: 15,
            //       //     //           height: 15,
            //       //     //           child: Center(
            //       //     //             child: CircularProgressIndicator(
            //       //     //               color: AppColor().whiteColor,
            //       //     //             ),
            //       //     //           ),
            //       //     //         )
            //       //     //       : (_quoteController.quoteQuoteStatus != QuoteQuoteStatus.LOADING);
            //       //   }
            //       // },
            //     ),
            //   );
            // }),
            Obx(() {
              return InkWell(
                onTap: () async {
                  if (_quoteController.quoteStatus != QuoteStatus.LOADING) {
                    await Future.delayed(
                      const Duration(milliseconds: 300),
                    );
                    if (kDebugMode) {
                      print('uploading quote');
                    }
                    await _quoteController.creatQuote(
                      dailyQuote: _quoteTextController.text,
                      createdAt: createdTime,
                    );
                  }
                },
                child: Container(
                  height: 45,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: AppColor().primaryColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: (_quoteController.quoteStatus == QuoteStatus.LOADING)
                      ? SizedBox(
                          width: 15,
                          height: 15,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColor().whiteColor,
                            ),
                          ),
                        )
                      : Center(
                          child: customDescriptionText(
                            'Post quote',
                            colors: AppColor().button1Color,
                            fontSize: 16,
                          ),
                        ),
                ),
              );
            }),
            const Gap(40)
          ],
        ),
      ),
    );
  }
}
