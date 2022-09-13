import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';

class FirestoreConstants {
  static String id = FirebaseAuth.instance.currentUser!.uid;
  static const pathMessageCollection = "messages";
  static const username = "username";
  static const email = "email";
  static const profilePic = "profilePic";
  static const chattingWith = "chattingWith";
  static const idFrom = "idFrom";
  static const idTo = "idTo";
  static const timestamp = "timestamp";
  static const content = "content";
  static const type = "type";
}
