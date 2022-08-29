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
    this.gender,
    this.postalCode,
    this.address,
    this.profilePic,
    this.reference,
    this.admin,
    this.lastLoginTime,
    this.createdAt,
    this.updatedAt,
  });

  final String? uid;
  final String? email;
  final String? fullName;
  final String? username;
  final String? gender;
  final int? postalCode;
  final String? address;
  final String? profilePic;
  final String? reference;
  final bool? admin;
  DateTime? lastLoginTime;
  final DateTime? createdAt;
  DateTime? updatedAt;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        uid: json["uid"],
        email: json["email"],
        fullName: json["fullName"],
        username: json["username"],
        gender: json["gender"],
        postalCode: json["postalCode"],
        address: json["address"],
        profilePic: json["profilePic"],
        reference: json["reference"],
        admin: json["admin"],
        lastLoginTime: json["lastLoginTime"] == null
            ? null
            : DateTime.parse(json["lastLoginTime"]),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
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
        "reference": reference,
        "admin": admin,
        "lastLoginTime":
            lastLoginTime == null ? null : lastLoginTime!.toIso8601String(),
        "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt!.toIso8601String(),
      };
}
