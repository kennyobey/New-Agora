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
    this.uid,
    this.tags,
    this.groupId,
    this.groupIcon,
    this.groupName,
    this.email,
    this.description,
    this.recentMessage,
    this.recentMessageSender,
    this.recentMessageTime,
    this.members,
    this.profilePic,
    this.admin,
    this.createdAt,
    this.updatedAt,
    this.cellQuote,
  });

  final String? id;
  final String? uid;
  final List<String>? tags;
  final String? groupId;
  final String? groupIcon;
  final String? groupName;
  final String? description;
  final String? email;
  final String? recentMessage;
  final String? recentMessageSender;
  final String? recentMessageTime;
  final List<String>? members;
  final String? profilePic;
  final String? admin;
  DateTime? createdAt;
  DateTime? updatedAt;
  final String? cellQuote;

  factory CellModel.fromJson(dynamic json, String id) => CellModel(
        id: id,
        uid: json["uid"],
        groupId: id,
        groupIcon: json["groupIcon"],
        groupName: json["groupName"],
        email: json["email"],
        description: json["description"],
        recentMessageSender: json["recentMessageSender"],
        recentMessageTime: json["recentMessageTime"],
        members: json["members"] == null
            ? []
            : List<String>.from(json["members"].map((x) => x)),
        tags: json["tags"] == null
            ? []
            : List<String>.from(json["tags"].map((x) => x)),
        recentMessage: json["recentMessage"],
        profilePic: json["profilePic"],
        admin: json["admin"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        cellQuote: json["cellQuote"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uid": uid,
        "groupId": groupId,
        "groupIcon": groupIcon,
        "groupName": groupName,
        "email": email,
        "description": description,
        "recentMessageSender": recentMessageSender,
        "members":
            members == null ? null : List<dynamic>.from(members!.map((x) => x)),
        "tags": tags == null ? null : List<dynamic>.from(tags!.map((x) => x)),
        "recentMessage": recentMessage,
        "profilePic": profilePic,
        "admin": admin,
        "recentMessageTime": recentMessageTime,
        "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt!.toIso8601String(),
        "cellQuote": cellQuote,
      };
}
