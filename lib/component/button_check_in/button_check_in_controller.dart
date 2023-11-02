import 'package:get/get.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 04/07/23
 */

class ButtonCheckInController extends GetxController {
    String tag;
    ButtonCheckInController({required this.tag});

    RxString error = "".obs;
    var isShow = false.obs;
    var isSuccess = false.obs;
    void showLabel(bool success, String value) {
        error.value = value;
        isSuccess.value = success;
        isShow.value = true;
    }

    void hideLabel() => isShow.value = false;
}

class ButtonCheckInBindings extends Bindings {
    @override
    void dependencies() {
        Get.lazyPut<ButtonCheckInController>(() => ButtonCheckInController(tag: ""));
    }
}
