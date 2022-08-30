// To parse this JSON data, do
//
//     final cellModel = cellModelFromJson(jsonString);

import 'dart:convert';

CellModel cellModelFromJson(String str) => CellModel.fromJson(json.decode(str));

String cellModelToJson(CellModel data) => json.encode(data.toJson());

class CellModel {
  CellModel({
    this.groupId,
    this.email,
    this.fullName,
    this.recentMessageSender,
    this.groupName,
    this.members,
    this.recentMessage,
    this.profilePic,
    this.likes = 0,
    this.replies = 0,
    this.streak = 0,
    this.weeks = 0,
    this.role,
    this.admin,
    this.recentMessageTime,
    this.weeklyLoginTime,
    this.updatedAt,
  });

  final String? groupId;
  final String? groupName;
  final String? email;
  final String? fullName;
  final String? recentMessageSender;
  final String? members;
  final String? recentMessage;
  final String? profilePic;
  final int? streak;
  final int? likes;
  final int? replies;
  final int? weeks;
  final bool? admin;
  final String? role;
  DateTime? recentMessageTime;
  DateTime? weeklyLoginTime;
  DateTime? updatedAt;

  factory CellModel.fromJson(Map<String, dynamic> json) => CellModel(
        groupId: json["groupId"],
        email: json["email"],
        fullName: json["fullName"],
        recentMessageSender: json["recentMessageSender"],
        groupName: json["groupName"],
        members: json["members"],
        recentMessage: json["recentMessage"],
        profilePic: json["profilePic"],
        streak: json["streak"],
        likes: json["likes"],
        replies: json["replies"],
        weeks: json["weeks"],
        admin: json["admin"],
        role: json["role"],
        recentMessageTime: json["recentMessageTime"] == null
            ? null
            : DateTime.parse(json["recentMessageTime"]),
        weeklyLoginTime: json["weeklyLoginTime"] == null
            ? null
            : DateTime.parse(json["weeklyLoginTime"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "groupId": groupId,
        "email": email,
        "fullName": fullName,
        "recentMessageSender": recentMessageSender,
        "groupName": groupName,
        "members": members,
        "recentMessage": recentMessage,
        "profilePic": profilePic,
        "streak": streak,
        "likes": likes,
        "replies": replies,
        "weeks": weeks,
        "admin": admin,
        "role": role,
        "recentMessageTime": recentMessageTime == null
            ? null
            : recentMessageTime!.toIso8601String(),
        "weeklyLoginTime":
            weeklyLoginTime == null ? null : weeklyLoginTime!.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt!.toIso8601String(),
      };
}
