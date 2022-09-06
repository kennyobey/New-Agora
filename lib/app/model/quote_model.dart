// To parse this JSON data, do
//
//     final quoteModel = quoteModelFromJson(jsonString);

import 'dart:convert';

QuoteModel quoteModelFromJson(String str) =>
    QuoteModel.fromJson(json.decode(str), "");

String quoteModelToJson(QuoteModel data) => json.encode(data.toJson());

class QuoteModel {
  QuoteModel({
    this.id,
    this.likes,
    this.share,
    this.email,
    this.chats,
    this.views,
    this.reply,
    this.admin,
    this.groupId,
    this.groupName,
    this.members,
    this.dailyQuote,
    this.createdAt,
    this.recentMessage,
    this.recentMessageSender,
    this.recentMessageTime,
  });

  final String? id;
  final String? admin;
  final String? email;
  final String? groupId;
  final String? groupName;
  final String? dailyQuote;
  final List<dynamic>? likes;
  final List<dynamic>? share;
  final List<dynamic>? chats;
  final List<dynamic>? views;
  final List<dynamic>? members;
  final List<dynamic>? reply;
  final String? recentMessage;
  final String? recentMessageSender;
  final String? recentMessageTime;
  DateTime? createdAt;

  factory QuoteModel.fromJson(dynamic json, String id) => QuoteModel(
        id: id,
        groupId: id,
        admin: json["admin"],
        email: json["email"],
        groupName: json["groupName"],
        dailyQuote: json["dailyQuote"],
        recentMessage: json["recentMessage"],
        recentMessageTime: json["recentMessageTime"],
        recentMessageSender: json["recentMessageSender"],
        members: json["members"] == null
            ? null
            : List<dynamic>.from(json["members"].map((x) => x)),
        likes: json["likes"] == null
            ? null
            : List<dynamic>.from(json["likes"].map((x) => x)),
        views: json["views"] == null
            ? null
            : List<dynamic>.from(json["views"].map((x) => x)),
        share: json["share"] == null
            ? null
            : List<dynamic>.from(json["share"].map((x) => x)),
        chats: json["chats"] == null
            ? null
            : List<dynamic>.from(json["chats"].map((x) => x)),
        // views: json["views"],
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
        "groupId": groupId,
        "email": email,
        "admin": admin,
        "groupName": groupName,
        "recentMessage": recentMessage,
        "recentMessageTime": recentMessageTime,
        "recentMessageSender": recentMessageSender,
        "members":
            members == null ? null : List<dynamic>.from(members!.map((x) => x)),

        "likes":
            likes == null ? null : List<dynamic>.from(likes!.map((x) => x)),
        "views":
            views == null ? null : List<dynamic>.from(views!.map((x) => x)),
        "share":
            share == null ? null : List<dynamic>.from(share!.map((x) => x)),
        "chats":
            chats == null ? null : List<dynamic>.from(chats!.map((x) => x)),
        // "views": views,
        "reply":
            reply == null ? null : List<dynamic>.from(reply!.map((x) => x)),
        "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
      };
}
