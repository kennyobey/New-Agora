// ignore_for_file: unnecessary_null_comparison, unused_field, constant_identifier_names

import 'package:agora_care/app/model/quote_model.dart';
import 'package:agora_care/app/model/user_model.dart';
import 'package:agora_care/services/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

enum QuoteStatus { LOADING, ERROR, EMPTY, SUCCESS }

class QuoteControllers extends GetxController {
  final _authController = Get.find<AuthControllers>();
  final bool isLoading = false;

  final Rx<List<QuoteModel>> _quoteList = Rx([]);
  List<QuoteModel> get allQuotes => _quoteList.value;

  final CollectionReference quotesCollection =
      FirebaseFirestore.instance.collection("quotes");
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  Rx<UserModel> liveUser = UserModel().obs;
  UserModel get users => liveUser.value;

  FirebaseAuth auth = FirebaseAuth.instance;
  final _userDoc = FirebaseFirestore.instance.collection("users");

  final _newQuote = FirebaseFirestore.instance.collection("quotes");

  final Rx<QuoteStatus> _quoteStatus = Rx(QuoteStatus.EMPTY);
  QuoteStatus get quoteStatus => _quoteStatus.value;

  @override
  void onInit() async {
    super.onInit();
    getQuotes();
    getDailyQuote();

    final now = DateTime.now();
    if (FirebaseAuth.instance.currentUser != null) {
      final newUser = await _authController
          .getUserByModel(FirebaseAuth.instance.currentUser!.uid);
      liveUser(newUser);

      if (newUser.lastLoginTime!.difference(now).inDays >= 1 &&
          newUser.weeklyLoginTime!.difference(now).inDays >= 1) {
        _newQuote.doc(quotesCollection.id).update({
          "share": sharePost(quotesCollection.id),
          "likes": likePost(quotesCollection.id),
          "views": viewPost(quotesCollection.id),
        });

        final newUser = await _authController
            .getUserByModel(FirebaseAuth.instance.currentUser!.uid);
        liveUser(newUser);
        if (kDebugMode) {
          print("user value gotten user ${liveUser.value.toJson()}");
        }
      }
    }
  }

//Fetch  Stream dailyQuote
  Stream<QuerySnapshot<Object?>> getDailyQuote() {
    final quotes = quotesCollection.snapshots();
    // getQuotes();
    return quotes;
  }

  // Stream<List<QuoteModel>> getDailyQuote() => FirebaseFirestore.instance
  //     .collection('quotes')
  //     .snapshots()
  //     .map((snapshot) =>
  //         snapshot.docs.map((doc) => QuoteModel.fromJson(doc.data())).toList());

  //Fetch Once dailyQuote
  Future getQuotes() async {
    _quoteStatus(QuoteStatus.LOADING);
    try {
      quotesCollection.snapshots().listen((event) {
        List<QuoteModel> list = [];
        for (var element in event.docs) {
          final quote = QuoteModel.fromJson(element.data()!);
          _quoteStatus(QuoteStatus.SUCCESS);
          list.add(quote);
          if (kDebugMode) {
            print('quote is:${quote.toJson()}');
          }
        }
        _quoteList(list);
      });
    } catch (ex) {
      //
    }
  }

  Future sharePost(String quoteId) async {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.update(_newQuote.doc(quoteId), {
        "share": FieldValue.arrayUnion([_authController.liveUser.value.uid!])
      });
    });
  }

  Future likePost(String quoteId) async {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.update(_newQuote.doc(quoteId), {
        "likes": FieldValue.arrayUnion([_authController.liveUser.value.uid!])
      });
    });
  }

  Future viewPost(String quoteId) async {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.update(
        _newQuote.doc(quoteId),
        {
          "views": FieldValue.increment(1),
        },
      );
    });
  }

  // Create Quotes
  Future creatQuote({
    required String dailyQuote,
    required DateTime createdAt,
  }) async {
    final docUser = FirebaseFirestore.instance.collection("quotes").doc();

    // Saving to model
    final user = QuoteModel(
      dailyQuote: dailyQuote,
      likes: [],
      share: [],
      reply: [],
      chats: [],
      views: 0,
      createdAt: createdAt,
    );
    final json = user.toJson();

    // Direct Saving
    // final json = {
    //   "dailyQuotes": dailyQuote,
    // };

    // Create reference and write data to Firebase
    await docUser.set(json);
  }
}
