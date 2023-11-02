import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 05/07/23
 */

class PasswordFieldController extends GetxController {

    String tag;
    PasswordFieldController({required this.tag});

    var activeField = true.obs;
    var showTooltip = false.obs;
    var showLengthAlert = false.obs;
    var showPasswordAlert = false.obs;
    var goodLength =false.obs;
    var goodPassword = false.obs;
    var hideLabel = false.obs;
    var obscure = false.obs;
    var formKey = GlobalKey<FormState>();


    void beGoodLength() => goodLength.value = true;
    void beBadLength() => goodLength.value = false;
    void beGoodPassword() => goodPassword.value = true;
    void beBadPassword() => goodPassword.value = false;
    void showAlertLength() => showLengthAlert.value = true;
    void hideAlertLength() => showLengthAlert.value = false;
    void showAlertPassword() => showPasswordAlert.value = true;
    void hideAlertPassword() => showPasswordAlert.value = false;
    void showAlert() => showTooltip.value = true;
    void hideAlert() => showTooltip.value = false;
    void enable() => activeField.value = true;
    void disable() => activeField.value = false;
    void invisibleLabel() => hideLabel.value = true;
    void visibleLabel() => hideLabel.value = false;
    void showPassword() => obscure.value = true;
    void hidePassword() => obscure.value = false;
}

class PasswordFieldBinding extends Bindings {
    @override
    void dependencies() {
        Get.lazyPut<PasswordFieldController>(() => PasswordFieldController(tag: ""));
    }
}