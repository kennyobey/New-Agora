import 'package:flutter/material.dart';
// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:agora_care/app/group_screen/group_info.dart';
import 'package:agora_care/core/constant/colors.dart';
import 'package:agora_care/core/constant/message_tile.dart';
import 'package:agora_care/core/customWidgets.dart';
import 'package:agora_care/services/database_service.dart';
import 'package:agora_care/services/quote_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

class DetialsScreen extends StatefulWidget {
  @override
  _DetialsScreenState createState() => _DetialsScreenState();
}

class _DetialsScreenState extends State<DetialsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: 'img',
                  child: SvgPicture.asset(
                    'assets/svgs/quoteCard.svg',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Rome Is a Beautiful Place",
                        style: TextStyle(
                          color: Color(0xFF1a1a1a),
                          fontSize: 24.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text("hello")
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 22.0, left: 10.0),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 28.0,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
