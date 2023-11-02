import 'package:eksternal_app/component/edit_field/edit_field.dart';
import 'package:eksternal_app/engine/get_x_creator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 11/07/23
 */

class CardFloorController extends GetxController {
    String tag;
    BuildContext context;
    CardFloorController({required this.tag, required this.context});

    Rx<List<int>> index = Rx<List<int>>([]);
    Rx<List<EditField>> efFloorName = Rx<List<EditField>>([]);

    var itemCount = 0.obs;
    var expanded = false.obs;
    var isShow = true.obs;
    var isLoadApi = false.obs;
    var numberList = 0.obs;

    void expand() => expanded.value = true;
    void collapse() => expanded.value = false;
    void visibleCard() => isShow.value = true;
    void InvisibleCard() => isShow.value = false;

    @override
    void onInit() {
        super.onInit();
    }

    @override
    void onReady() {
        super.onReady();
        addCard();
    }

    @override
    void onClose() {
        super.onClose();
    }

    addCard() {
        index.value.add(numberList.value);
        int idx = numberList.value;
        efFloorName.value.add(EditField(
            controller: GetXCreator.putEditFieldController(
                "efFloorName${idx}"),
            label: "Nama Lantai*",
            hint: "Ketik di sini",
            alertText: "Kolom Ini Harus Di Isi",
            textUnit: "",
            inputType: TextInputType.text,
            maxInput: 50,
            onTyping: (value, control) {
            }
        ));
        itemCount.value = index.value.length;
        numberList.value++;
    }

    removeCard(int idx) {
        index.value.removeWhere((item) => item == idx);
        itemCount.value = index.value.length;
    }

    removeAll() {
        index.value.clear();
        efFloorName.value.clear();
        itemCount.value =0;
        numberList.value=0;
        index.refresh();
        efFloorName.refresh();
    }

    List validation() {
        bool isValid = true;
        String error = "";
        for (int i = 0; i < index.value.length; i++) {
            int whichItem = index.value[i];
            if (efFloorName.value[whichItem].getInput().isEmpty) {
                efFloorName.value[whichItem].controller.showAlert();
                Scrollable.ensureVisible(efFloorName.value[whichItem].controller.formKey.currentContext!);
                isValid = false;
                return [isValid, error];
            }
        }

        return [isValid, error];
    }

}

class CardSensorBindings extends Bindings {
    String tag;
    BuildContext context;
    CardSensorBindings({required this.tag, required this.context});

    @override
    void dependencies() {
        Get.lazyPut<CardFloorController>(() => CardFloorController(tag: tag, context: context));
    }
}
