import 'package:get/get.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 04/07/23
 */


class ButtonFillController extends GetxController {

    String tag;
    ButtonFillController({required this.tag});

    var activeField = true.obs;
    void enable() => activeField.value = true;
    void disable() => activeField.value = false;
}

class ButtonFillBinding extends Bindings {

    @override
    void dependencies() {
        Get.lazyPut<ButtonFillController>(() => ButtonFillController(tag: "tag"));
    }
}