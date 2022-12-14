// ignore_for_file: unnecessary_null_comparison, unused_field, constant_identifier_names

import 'package:agora_care/app/model/quote_model.dart';
import 'package:agora_care/app/model/user_model.dart';
import 'package:agora_care/core/constants.dart';
import 'package:agora_care/services/auth_controller.dart';
import 'package:agora_care/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

enum QuoteStatus { LOADING, ERROR, EMPTY, SUCCESS }

class QuoteControllers extends GetxController {
  final _authController = Get.find<AuthControllers>();

  static QuoteControllers to = Get.find();
  DatabaseService? uid;
  DocumentReference? groupDocumentReference;

  final Rx<QuoteStatus> _quoteStatus = Rx(QuoteStatus.EMPTY);
  QuoteStatus get quoteStatus => _quoteStatus.value;

  Rx<UserModel> liveUser = UserModel().obs;
  UserModel get users => liveUser.value;

  Rx<QuoteModel?> selectedQuote = Rx(null);

  final Rx<List<QuoteModel>> _quoteList = Rx([]);
  List<QuoteModel> get allQuotes => _quoteList.value;

  final CollectionReference quotesCollection =
      FirebaseFirestore.instance.collection("quotes");
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference messagesCollection = FirebaseFirestore.instance
      .collection("quotes")
      .doc()
      .collection('messages');

  FirebaseAuth auth = FirebaseAuth.instance;
  final _userDoc = FirebaseFirestore.instance.collection("users");
  final _newQuote = FirebaseFirestore.instance.collection("quotes");
  final _newMessage = FirebaseFirestore.instance
      .collection("quotes")
      .doc()
      .collection('messages');
  Stream<DocumentSnapshot<Map<String, dynamic>>> listenToQuote(String id) {
    return _newQuote.doc(id).snapshots();
  }

  @override
  void onInit() async {
    super.onInit();
    selectedQuote.listen((p0) {
//    if(p0!=null){

// _newQuote.doc(p0.id).snapshots().l

//    }
    });

    _authController.liveUser.listen((p0) async {
      if (p0 != null) {
        getQuotes();
        getDailyQuote();
        streamDailyQuote();

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
              "reply": viewPost(quotesCollection.id),
            });
            _newMessage.doc(messagesCollection.id).update({
              "like": likeQuotePost(quotesCollection.id, messagesCollection.id),
              "comment": comment(quotesCollection.id, messagesCollection.id),
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
    });
  }

//Fetch  Stream dailyQuote
  Stream<QuerySnapshot<Object?>> getDailyQuote() {
    final quotes = quotesCollection.orderBy("createdAt").snapshots();
    return quotes;
  }

  joinedOrNot(
    String userName,
    String groupId,
    String groupname,
  ) async {
    await DatabaseService(uid: _authController.liveUser.value!.uid)
        .isUserJoined(groupname, groupId, userName)
        .then((value) {
      update();
    });
  }

  Future likeQuotePost(String quoteId, String messageId) async {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.update(
          _newQuote.doc(quoteId).collection('messages').doc(messageId), {
        "like": FieldValue.arrayUnion([_authController.liveUser.value!.uid!])
      });
    });
  }

  Future unLikeQuotePost(String quoteId, String messageId) async {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.update(
          _newQuote.doc(quoteId).collection('messages').doc(messageId), {
        "like": FieldValue.arrayRemove([_authController.liveUser.value!.uid!])
      });
    });
  }

  Future comment(String quoteId, String messageId) async {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.update(
          _newQuote.doc(quoteId).collection("messages").doc(messageId), {
        "comment": FieldValue.arrayUnion([_authController.liveUser.value!.uid!])
      });
    });
  }

  //Fetch Once dailyQuote
  Future getQuotes() async {
    _quoteStatus(QuoteStatus.LOADING);
    try {
      quotesCollection.orderBy("createdAt").snapshots().listen((event) {
        List<QuoteModel> list = [];
        for (var element in event.docs) {
          final quote = QuoteModel.fromJson(element.data()!, element.id);
          list.add(quote);
          if (kDebugMode) {
            print('ID is: ${element.id}');
            print('quote is: ${quote.toJson()}');
          }
          _quoteStatus(QuoteStatus.SUCCESS);
        }
        // List<QuoteModel> reversedList = list.reversed.toList();

        _quoteList([]);

        _quoteList(list);
        // _quoteList(reversedList);
      });
    } catch (ex) {
      //
    }
  }

  Stream<List<QuoteModel>> streamDailyQuote() {
    // try {
    quotesCollection.orderBy("createdAt").snapshots().listen((event) {
      List<QuoteModel> list = [];
      for (var element in event.docs) {
        final quote = QuoteModel.fromJson(element.data()!, element.id);
        list.add(quote);
        if (kDebugMode) {
          print('STREAM ID is: ${element.id}');
          print(' stream quote is: ${quote.toJson()}');
        }
        _quoteStatus(QuoteStatus.SUCCESS);
      }
      List<QuoteModel> reversedList = List.from(list.reversed);

      _quoteList([]);

      _quoteList(reversedList);
    });
    // } catch (ex) {
    //   //
    // }
    return quotesCollection.orderBy("createdAt").snapshots().map((snapshot) =>
        snapshot.docs
            .map((doc) => QuoteModel.fromJson(doc.data(), doc.id))
            .toList());
  }

  Future sharePost(String quoteId) async {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.update(_newQuote.doc(quoteId), {
        "share": FieldValue.arrayUnion([_authController.liveUser.value!.uid!])
      });
    });
  }

  Future likePost(String quoteId) async {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.update(_newQuote.doc(quoteId), {
        "likes": FieldValue.arrayUnion([_authController.liveUser.value!.uid!])
      });
    });
  }

  Future unLikePost(String quoteId) async {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.update(_newQuote.doc(quoteId), {
        "likes": FieldValue.arrayRemove([_authController.liveUser.value!.uid!])
      });
    });
  }

  Future viewPost(String quoteId) async {
    if (kDebugMode) {
      print("quote id is $quoteId");
    }
    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.update(_newQuote.doc(quoteId), {
        "views": FieldValue.arrayUnion([_authController.liveUser.value!.uid!]),
      });
    });
  }

  Future chatList(String quoteId) async {
    if (kDebugMode) {
      print("quote id is $quoteId");
    }
    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.update(_newQuote.doc(quoteId), {
        "chats": FieldValue.arrayUnion([_authController.liveUser.value!.uid!]),
        "reply": FieldValue.increment(1),
      });
    });
  }

  // Create Quotes
  Future creatQuote({
    required String dailyQuote,
    required String groupId,
    required String admin,
    required String email,
    required DateTime createdAt,
  }) async {
    // _quoteStatus(QuoteStatus.LOADING);
    try {
      final docUser = FirebaseFirestore.instance.collection("quotes");

      // Saving to model
      final user = QuoteModel(
        dailyQuote: dailyQuote,
        groupId: groupId,
        likes: [],
        share: [],
        reply: 0,
        // reply: [],
        chats: [],
        views: [],
        members: [],
        admin: admin,
        email: email,
        recentMessage: '',
        recentMessageSender: '',
        createdAt: DateTime.now(),
      );
      final json = user.toJson();

      // Create reference and write data to Firebase
      await docUser.add(json);

      await sendHttpNotification(
          title: 'Agora Care', body: 'Todays Quote Has Been Posted');

      await sendFirebaseNotification(
        avatar:
            "https://images.unsplash.com/photo-1593642532842-98d0fd5ebc1a?ixid=MXwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=2250&q=80",
        message: 'Todays Quote has been posted',
        id: quotesCollection.id,
        userId: _authController.liveUser.value!.uid!,
      );

      await groupDocumentReference!.update({
        "members": FieldValue.arrayUnion(
            ["${uid!}_${_authController.liveUser.value!.email}"]),
        "chats": groupDocumentReference!.id,
      });

      DocumentReference quoteDocumentReference = quotesCollection.doc(uid!.uid);
      return await quoteDocumentReference.update({
        "chats":
            FieldValue.arrayUnion(["${groupDocumentReference!.id}_$dailyQuote"])
      });
    } catch (ex) {
      //
    }
  }
}
