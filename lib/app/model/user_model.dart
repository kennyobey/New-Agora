// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.uid,
    this.email,
    this.fullName,
    this.username,
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
    this.phoneNumber,
    this.nextOfKin,
    this.nexKinPhone,
  });

  final String? uid;
  final String? email;
  final String? fullName;
  final String? username;
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

  final String? phoneNumber;
  final String? nextOfKin;
  final String? nexKinPhone;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        uid: json["uid"],
        email: json["email"],
        fullName: json["fullName"],
        username: json["username"],
        postalCode: json["postalCode"],
        address: json["address"],
        profilePic: json["profilePic"],
        streak: json["streak"],
        weeks: json["weeks"],
        admin: json["admin"] ?? false,
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
        phoneNumber: json["phoneNumber"],
        nextOfKin: json["nextOfKin"],
        nexKinPhone: json["nexKinPhone"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "email": email,
        "fullName": fullName,
        "username": username,
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
        "phoneNumber": phoneNumber,
        "nextOfKin": nextOfKin,
        "nexKinPhone": nexKinPhone,
      };
}
