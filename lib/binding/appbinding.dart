import 'package:agora_care/services/auth_controller.dart';
import 'package:agora_care/services/cell_controller.dart';
import 'package:get/get.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthControllers(), permanent: true);
    Get.put(CellControllers(), permanent: true);
  }
}
