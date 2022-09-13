// To parse this JSON data, do
//
//     final messageModel = messageModelFromJson(jsonString);

import 'dart:convert';

MessageModel messageModelFromJson(String str) =>
    MessageModel.fromJson(json.decode(str), '');

String messageModelToJson(MessageModel data) => json.encode(data.toJson());

class MessageModel {
  MessageModel({
    this.message,
    this.sender,
    this.time,
    this.like,
    this.comment,
  });

  final String? message;
  final String? sender;
  DateTime? time;
  final List<dynamic>? like;
  final List<dynamic>? comment;

  factory MessageModel.fromJson(dynamic json, String id) => MessageModel(
        message: json["message"],
        sender: json["sender"],
        time: json["time"] == null ? null : DateTime.parse(json["time"]),
        like: json["like"] == null
            ? null
            : List<dynamic>.from(json["like"]!.map((x) => x)),
        comment: json["comment"] == null
            ? null
            : List<dynamic>.from(json["comment"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "sender": sender,
        "time": time == null ? null : time!.toIso8601String(),
        "like": like == null ? null : List<dynamic>.from(like!.map((x) => x)),
        "comment":
            comment == null ? null : List<dynamic>.from(comment!.map((x) => x)),
      };
}

CommentModel commentModelFromJson(String str) =>
    CommentModel.fromJson(json.decode(str), '');

String commentModelToJson(CommentModel data) => json.encode(data.toJson());

class CommentModel {
  CommentModel({
    this.message,
    this.sender,
    this.time,
    this.like,
    this.comment,
  });

  final String? message;
  final String? sender;
  DateTime? time;
  final List<dynamic>? like;
  final List<dynamic>? comment;

  factory CommentModel.fromJson(dynamic json, String id) => CommentModel(
        message: json["message"],
        sender: json["sender"],
        time: json["time"] == null ? null : DateTime.parse(json["time"]),
        like: json["like"] == null
            ? null
            : List<dynamic>.from(json["like"]!.map((x) => x)),
        comment: json["comment"] == null
            ? null
            : List<dynamic>.from(json["comment"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "sender": sender,
        "time": time == null ? null : time!.toIso8601String(),
        "like": like == null ? null : List<dynamic>.from(like!.map((x) => x)),
        "comment":
            comment == null ? null : List<dynamic>.from(comment!.map((x) => x)),
      };
}
