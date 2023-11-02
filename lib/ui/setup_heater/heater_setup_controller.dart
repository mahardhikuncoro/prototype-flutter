import 'package:eksternal_app/component/button_fill/button_fill.dart';
import 'package:eksternal_app/component/button_outline/button_outline.dart';
import 'package:eksternal_app/component/edit_field/edit_field.dart';
import 'package:eksternal_app/engine/get_x_creator.dart';
import 'package:eksternal_app/engine/model/controller_data_model.dart';
import 'package:eksternal_app/engine/model/device_model.dart';
import 'package:eksternal_app/engine/model/error/error.dart';
import 'package:eksternal_app/engine/model/device_setting_model.dart';
import 'package:eksternal_app/engine/request/service.dart';
import 'package:eksternal_app/engine/request/transport/interface/response_listener.dart';
import 'package:eksternal_app/engine/util/global_var.dart';
import 'package:eksternal_app/engine/util/list_api.dart';
import 'package:eksternal_app/engine/util/mapper/mapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 28/07/23
 */

class HeaterSetupController extends GetxController {
    BuildContext context;

    HeaterSetupController({required this.context});

    ScrollController scrollController = ScrollController();
    Rx<Map<String, bool>> mapList = Rx<Map<String, bool>>({});

    var isLoading = false.obs;
    late Device device;
    late ControllerData controllerData;
    late ButtonFill bfYesSetHeater;
    late ButtonOutline boNoSetHeater;
    late EditField efDiffTempHeater = EditField(
        controller: GetXCreator.putEditFieldController(
            "efDiffTempHeater"),
        label: "Perbedaan Suhu",
        hint: "Ketik disini",
        alertText: "Perbedaan Suhu harus di isi",
        textUnit: "°C",
        inputType: TextInputType.number,
        maxInput: 4,
        onTyping: (value, control) {
        }
    );

    @override
    void onInit() {
        super.onInit();
        device = Get.arguments[0];
        controllerData = Get.arguments[1];
        boNoSetHeater = ButtonOutline(
            controller: GetXCreator.putButtonOutlineController("boNoSetHeater"),
            label: "Tidak",
            onClick: () {
                Get.back();
            },
        );
        bfYesSetHeater = ButtonFill(
            controller: GetXCreator.putButtonFillController("bfYesSetHeater"),
            label: "Ya",
            onClick: () {
                settingHeater();
            },
        );

    }

    @override
    void onClose() {
        super.onClose();
    }

    @override
    void onReady() {
        super.onReady();
    }

    /// The function `settingHeater()` is responsible for setting up the heater
    /// device and handling the response from the server.
    void settingHeater() {
        Get.back();
        List ret = validationEdit();
        if (ret[0]) {
            isLoading.value = true;
            try {
                DeviceSetting payload = generatePayloadFanSetup();
                Service.push(
                    service: ListApi.setController,
                    context: context,
                    body: [GlobalVar.auth!.token, GlobalVar.auth!.id, GlobalVar.xAppId,
                        ListApi.pathSetController("heater", device.deviceSummary!.coopCodeId!),
                        Mapper.asJsonString(payload)],
                    listener:ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                            Get.back();
                            isLoading.value = false;
                        },
                        onResponseFail: (code, message, body, id, packet) {
                            isLoading.value = false;
                            Get.snackbar("Alert", (body as ErrorResponse).error!.message!, snackPosition: SnackPosition.TOP,
                                duration: Duration(seconds: 5),
                                backgroundColor: Colors.red,
                                colorText: Colors.white);
                        },
                        onResponseError: (exception, stacktrace, id, packet) {
                            isLoading.value = false;
                            Get.snackbar("Alert","Terjadi kesalahan internal", snackPosition: SnackPosition.TOP,
                                duration: Duration(seconds: 5),
                                backgroundColor: Colors.red,
                                colorText: Colors.white);
                        },
                        onTokenInvalid: GlobalVar.invalidResponse()
                    ),
                );
            } catch (e,st) {
                Get.snackbar("ERROR", "Error : $e \n Stacktrace->$st",
                    snackPosition: SnackPosition.BOTTOM,
                    duration: Duration(seconds: 5),
                    backgroundColor: Color(0xFFFF0000),
                    colorText: Colors.white);
            }

        }
    }

    /// The `validationEdit` function checks if the `efDiffTempHeater` input is
    /// empty and returns a list indicating whether the validation passed or failed.
    ///
    /// Returns:
    ///   The method `validationEdit()` is returning a list. The list contains two
    /// elements: a boolean value and an empty string.
    List validationEdit() {
        List ret = [true, ""];

        if (efDiffTempHeater.getInput().isEmpty) {
            efDiffTempHeater.controller.showAlert();
            Scrollable.ensureVisible(
                efDiffTempHeater.controller.formKey.currentContext!);
            return ret = [false, ""];
        }
        return ret;
    }

    /// The function generates a payload for fan setup with the device ID and
    /// temperature target.
    ///
    /// Returns:
    ///   a DeviceSetting object.
    DeviceSetting generatePayloadFanSetup(){
        return DeviceSetting(deviceId : controllerData.deviceId,  temperatureTarget : efDiffTempHeater.getInputNumber());
    }


}

class HeaterSetupBindings extends Bindings {
    BuildContext context;

    HeaterSetupBindings({required this.context});

    @override
    void dependencies() {
        Get.lazyPut(() => HeaterSetupController(context: context));
    }
}

