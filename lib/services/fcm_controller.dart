// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'auth_controller.dart';

class FCMService {
  final _authController = Get.find<AuthControllers>();
  processNotification(Map<String, dynamic> event) async {
    if (event.containsKey('type')) {
      if (event['type'] == 'messages') {
        DocumentSnapshot<Object?> user =
            await _authController.userCollection.doc(event['sender']).get();
      } else if (event['type'] == 'cells') {
      } else if (event['type'] == 'quotes') {
        //
      }
    }
  }
}
