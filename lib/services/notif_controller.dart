// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'auth_controller.dart';

class FCMService {
  final _authController = Get.find<AuthControllers>();
  processNotification(Map<String, dynamic> event) async {
    if (event.containsKey('type')) {
      if (event['type'] == 'chat') {
        DocumentSnapshot<Object?> user =
            await _authController.userCollection.doc(event['sender']).get();
        // Get.to(
        // () => DeliveryProgressView(
        //   order: Order(id: event['id']),
        //   rider: AppUser.fromJson(user.data()),
        // ),
        // );
      } else if (event['type'] == 'chat') {
        // Get.to(
        //   () => OrderChatView(
        //     receiverId: event['sender'],
        //   ),
        // );
      } else if (event['type'] == 'quotes') {
        // Get.to(
        //   () => RiderRateQuoutedView(
        //     order: Order(id: event['id']),
        //   ),
        // );
      }
    }
  }
}
