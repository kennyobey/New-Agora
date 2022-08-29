// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuoteWidget extends StatelessWidget {
  String? quote = "";
  String? author = "";
  var onShareClick;
  var onLikeClick;
  var onNextClick;
  var onPrClick;
  var bgColor;

  QuoteWidget({
    Key? key,
    this.bgColor,
    this.quote,
    this.author,
    this.onNextClick,
    this.onPrClick,
    this.onShareClick,
    this.onLikeClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgColor,
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          Image.asset(
            "assets/quote.png",
            height: 30,
            width: 30,
            color: Colors.white,
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            quote!,
            style: GoogleFonts.lato(
              textStyle: const TextStyle(color: Colors.white, fontSize: 30),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            author!,
            style: GoogleFonts.lato(
              textStyle: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
