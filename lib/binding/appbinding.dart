import 'package:agora_care/services/auth_controller.dart';
import 'package:agora_care/services/cell_controller.dart';
import 'package:agora_care/services/chat_provider.dart';
import 'package:agora_care/services/fcm_controller.dart';
import 'package:agora_care/services/notif_controller.dart';
import 'package:agora_care/services/quote_controller.dart';
import 'package:get/get.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthControllers(), permanent: true);
    Get.put(CellControllers(), permanent: true);
    Get.put(QuoteControllers(), permanent: true);
    Get.put(NotifControllers(), permanent: true);
    Get.put(ChatProvider(), permanent: true);
    Get.put(FCMService(), permanent: true);
  }
}
