// To parse this JSON data, do
//
//     final quoteModel = quoteModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

QuoteModel quoteModelFromJson(String str) =>
    QuoteModel.fromJson(json.decode(str), "");

String quoteModelToJson(QuoteModel data) => json.encode(data.toJson());

class QuoteModel {
  QuoteModel({
    this.id,
    this.likes,
    this.share,
    this.color,
    this.chats,
    this.views = 0,
    this.reply,
    this.dailyQuote,
    this.createdAt,
  });

  final String? id;
  final List<dynamic>? likes;
  final List<dynamic>? share;
  final List<dynamic>? chats;
  final String? dailyQuote;
  final int? views;
  final Color? color;
  final List<dynamic>? reply;
  DateTime? createdAt;

  factory QuoteModel.fromJson(dynamic json, String id) => QuoteModel(
        id: id,
        dailyQuote: json["dailyQuote"],
        color: json["color"],
        likes: json["likes"] == null
            ? null
            : List<dynamic>.from(json["likes"].map((x) => x)),
        share: json["share"] == null
            ? null
            : List<dynamic>.from(json["share"].map((x) => x)),
        chats: json["chats"] == null
            ? null
            : List<dynamic>.from(json["chats"].map((x) => x)),
        views: json["views"],
        reply: json["reply"] == null
            ? null
            : List<dynamic>.from(json["reply"].map((x) => x)),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "dailyQuote": dailyQuote,
        "color": color,
        "likes":
            likes == null ? null : List<dynamic>.from(likes!.map((x) => x)),
        "share":
            share == null ? null : List<dynamic>.from(share!.map((x) => x)),
        "chats":
            chats == null ? null : List<dynamic>.from(chats!.map((x) => x)),
        "views": views,
        "reply":
            reply == null ? null : List<dynamic>.from(reply!.map((x) => x)),
        "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
      };
}
