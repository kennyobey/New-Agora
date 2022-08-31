// To parse this JSON data, do
//
//     final userList = userListFromJson(jsonString);

import 'dart:convert';

UserList userListFromJson(String str) => UserList.fromJson(json.decode(str));

String userListToJson(UserList data) => json.encode(data.toJson());

class UserList {
  UserList({
    this.uid,
    this.email,
    this.fullName,
    this.username,
    this.gender,
    this.postalCode,
    this.address,
    this.profilePic,
    this.streak = 0,
    this.weeks = 0,
    this.role,
    this.admin,
    this.lastLoginTime,
    this.weeklyLoginTime,
    this.updatedAt,
  });

  final String? uid;
  final String? email;
  final String? fullName;
  final String? username;
  final String? gender;
  final String? postalCode;
  final String? address;
  final String? profilePic;
  final int? streak;
  final int? weeks;
  final bool? admin;
  final String? role;
  DateTime? lastLoginTime;
  DateTime? weeklyLoginTime;
  DateTime? updatedAt;

  factory UserList.fromJson(Map<String, dynamic> json) => UserList(
        uid: json["uid"],
        email: json["email"],
        fullName: json["fullName"],
        username: json["username"],
        gender: json["gender"],
        postalCode: json["postalCode"],
        address: json["address"],
        profilePic: json["profilePic"],
        streak: json["streak"],
        weeks: json["weeks"],
        admin: json["admin"],
        role: json["role"],
        lastLoginTime: json["lastLoginTime"] == null
            ? null
            : DateTime.parse(json["lastLoginTime"]),
        weeklyLoginTime: json["weeklyLoginTime"] == null
            ? null
            : DateTime.parse(json["weeklyLoginTime"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "email": email,
        "fullName": fullName,
        "username": username,
        "gender": gender,
        "postalCode": postalCode,
        "address": address,
        "profilePic": profilePic,
        "streak": streak,
        "weeks": weeks,
        "admin": admin,
        "role": role,
        "lastLoginTime":
            lastLoginTime == null ? null : lastLoginTime!.toIso8601String(),
        "weeklyLoginTime":
            weeklyLoginTime == null ? null : weeklyLoginTime!.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt!.toIso8601String(),
      };
}
