import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 17/07/23
 */

class EditFieldQRController extends GetxController {
    String tag;
    EditFieldQRController({required this.tag});
    QRViewController? qrviewController;
    final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

    final FocusNode focusNode = FocusNode();

    var activeField = true.obs;
    var showField = true.obs;
    var showTooltip = false.obs;
    var hideLabel = false.obs;
    var alertText = "".obs;
    var formKey = GlobalKey<FormState>();

    void showAlert() => showTooltip.value = true;
    void hideAlert() => showTooltip.value = false;
    void enable() => activeField.value = true;
    void disable() => activeField.value = false;
    void invisibleLabel() => hideLabel.value = true;
    void visibleLabel() => hideLabel.value = false;
    void visibleField() => showField.value = true;
    void invisibleField() => showField.value = false;

    void setAlertText(String text) => alertText.value = text;

    @override
    void onClose() {
        super.onClose();
        focusNode.dispose();
    }
}

class EditFieldBinding extends Bindings {
    @override
    void dependencies() {
        Get.lazyPut<EditFieldQRController>(() => EditFieldQRController(tag: ""));
    }
}
