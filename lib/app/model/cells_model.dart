// To parse this JSON data, do
//
//     final cellModel = cellModelFromJson(jsonString);

import 'dart:convert';

CellModel cellModelFromJson(String str) =>
    CellModel.fromJson(json.decode(str), '');

String cellModelToJson(CellModel data) => json.encode(data.toJson());

class CellModel {
  CellModel({
    this.id,
    this.groupId,
    this.groupIcon,
    this.groupName,
    this.email,
    this.fullName,
    this.description,
    this.recentMessageSender,
    this.members,
    this.recentMessage,
    this.profilePic,
    this.admin,
    this.recentMessageTime,
    this.createdAt,
    this.updatedAt,
  });

  final String? id;
  final String? groupId;
  final String? groupIcon;
  final String? groupName;
  final String? description;
  final String? email;
  final String? fullName;
  final String? recentMessageSender;
  final String? recentMessageTime;
  final List<dynamic>? members;
  final String? recentMessage;
  final String? profilePic;
  final String? admin;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory CellModel.fromJson(dynamic json, String id) => CellModel(
        id: id,
        groupId: json["groupId"],
        groupIcon: json["groupIcon"],
        groupName: json["groupName"],
        email: json["email"],
        fullName: json["fullName"],
        description: json["description"],
        recentMessageSender: json["recentMessageSender"],
        recentMessageTime: json["recentMessageTime"],
        members: json["members"] == null
            ? null
            : List<dynamic>.from(json["members"].map((x) => x)),
        recentMessage: json["recentMessage"],
        profilePic: json["profilePic"],
        admin: json["admin"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "groupId": groupId,
        "groupIcon": groupIcon,
        "groupName": groupName,
        "email": email,
        "fullName": fullName,
        "description": description,
        "recentMessageSender": recentMessageSender,
        "members":
            members == null ? null : List<dynamic>.from(members!.map((x) => x)),
        "recentMessage": recentMessage,
        "profilePic": profilePic,
        "admin": admin,
        "recentMessageTime": recentMessageTime,
        "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt!.toIso8601String(),
      };
}
