import 'package:deal_or_not_deal/pages/SelectUser/input_form.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 5), () {
      Get.to(const InputForum());
    });
  }
}
