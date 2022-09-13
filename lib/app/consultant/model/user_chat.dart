import 'package:agora_care/app/consultant/model/firestore_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserChat {
  String id;
  String profilePic;
  String username;
  String email;

  UserChat({
    required this.id,
    required this.profilePic,
    required this.username,
    required this.email,
  });

  Map<String, String> toJson() {
    return {
      FirestoreConstants.username: username,
      FirestoreConstants.email: email,
      FirestoreConstants.profilePic: profilePic,
    };
  }

  factory UserChat.fromDocument(DocumentSnapshot doc) {
    String email = "";
    String profilePic = "";
    String username = "";
    try {
      email = doc.get(FirestoreConstants.email);
    } catch (e) {
      //
    }
    try {
      profilePic = doc.get(FirestoreConstants.profilePic);
    } catch (e) {
      //
    }
    try {
      username = doc.get(FirestoreConstants.username);
    } catch (e) {
      //
    }
    return UserChat(
      id: doc.id,
      profilePic: profilePic,
      username: username,
      email: email,
    );
  }
}
