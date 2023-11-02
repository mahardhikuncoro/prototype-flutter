import 'package:eksternal_app/component/button_fill/button_fill.dart';
import 'package:eksternal_app/component/button_outline/button_outline.dart';
import 'package:eksternal_app/component/edit_field/edit_field.dart';
import 'package:eksternal_app/component/time_picker/time_picker_field.dart';
import 'package:eksternal_app/engine/get_x_creator.dart';
import 'package:eksternal_app/engine/model/controller_data_model.dart';
import 'package:eksternal_app/engine/model/device_model.dart';
import 'package:eksternal_app/engine/model/error/error.dart';
import 'package:eksternal_app/engine/model/device_setting_model.dart';
import 'package:eksternal_app/engine/model/response/cooler_response.dart';
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

class CoolerSetupController extends GetxController {
    BuildContext context;

    CoolerSetupController({required this.context});

    ScrollController scrollController = ScrollController();
    Rx<Map<String, bool>> mapList = Rx<Map<String, bool>>({});

    var isLoading = false.obs;
    late Device device;
    late ControllerData controllerData;
    var isEdit = false.obs;

    late ButtonFill bfYesSetCooler;
    late ButtonOutline boNoSetCooler;
    late EditField efTargetTempColler = EditField(
        controller: GetXCreator.putEditFieldController(
            "efTargetTempColler"),
        label: "Target Suhu",
        hint: "Ketik disini",
        alertText: "Target Suhuharus di isi",
        textUnit: "°C",
        inputType: TextInputType.number,
        maxInput: 4,
        onTyping: (value, control) {
        }
    );
    late TimePickerField tmPickerDurationCoolerOn = TimePickerField(
        controller: GetXCreator.putTimePickerController(
            "tmPickerDurationOnCooler"),
        label: "Durasi Nyala",
        hint: "00:00:00",
        flag: TimePickerField.TIME_HOURS_AND_MINUTES,
        alertText: "Durasi Nyala harus di isi",
        onTimeSelected: (String time) {
            tmPickerDurationCoolerOn.controller.setTextSelected("${time}");},
    );
    late TimePickerField tmPickerCoolerOffDuration = TimePickerField(
        controller: GetXCreator.putTimePickerController(
            "tmPickerFanOffDurationCooler"),
        label: "Durasi Mati",
        hint: "00:00:00",
        flag: TimePickerField.TIME_HOURS_AND_MINUTES,
        alertText: "Durasi Mati harus di isi",
        onTimeSelected: (String time) {tmPickerCoolerOffDuration.controller.setTextSelected("${time}"); },
    );

    @override
    void onInit() {
        super.onInit();
        device = Get.arguments[0];
        controllerData = Get.arguments[1];
        isLoading.value = true;
        boNoSetCooler = ButtonOutline(
            controller: GetXCreator.putButtonOutlineController("boNoSetCooler"),
            label: "Tidak",
            onClick: () {
                Get.back();
            },
        );
        bfYesSetCooler = ButtonFill(
            controller: GetXCreator.putButtonFillController("bfYesSetCooler"),
            label: "Ya",
            onClick: () {
                settingCooler();
            },
        );
        getDataCooler();
    }

    @override
    void onClose() {
        super.onClose();
    }

    @override
    void onReady() {
        super.onReady();
        tmPickerDurationCoolerOn.controller.disable();
    }

    /// The function `getDataCooler` retrieves cooler data from an API and handles
    /// different response scenarios.
    void getDataCooler(){
        Service.push(
            service: ListApi.getCoolerData,
            context: context,
            body: [GlobalVar.auth!.token!, GlobalVar.auth!.id, GlobalVar.xAppId!,
                ListApi.pathDeviceData("cooler/detail",device.deviceSummary!.coopCodeId!, device.deviceSummary!.deviceId!)],
            listener: ResponseListener(onResponseDone: (code, message, body, id, packet){
                if ((body as CoolerResponse).data != null){
                    loadData((body).data!);
                }
                isLoading.value = false;
            }, onResponseFail: (code, message, body, id, packet){
                isLoading.value = false;
                Get.snackbar(
                    "Pesan",
                    "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                    snackPosition: SnackPosition.TOP,
                    colorText: Colors.white,
                    backgroundColor: Colors.red,
                );
            }, onResponseError: (exception, stacktrace, id, packet){
                print("object ${exception}");
                Get.snackbar(
                    "Pesan",
                    "Terjadi kesalahan internal",
                    snackPosition: SnackPosition.TOP,
                    duration: Duration(seconds: 5),
                    colorText: Colors.white,
                    backgroundColor: Colors.red,
                );

            },  onTokenInvalid: GlobalVar.invalidResponse()));
    }
    
    /// The function loads data into various input fields and controllers based on
    /// the device settings, and enables or disables them based on whether it is in
    /// edit mode or not.
    ///
    /// Args:
    ///   deviceSetting (DeviceSetting): The deviceSetting parameter is an object of
    /// type DeviceSetting. It contains properties such as temperatureTarget,
    /// onlineDuration, offlineDuration, and isEdit.
    void loadData(DeviceSetting deviceSetting){
        efTargetTempColler.setInput("${deviceSetting.temperatureTarget}");
        tmPickerDurationCoolerOn.controller.setTextSelected("${deviceSetting.onlineDuration}");
        tmPickerCoolerOffDuration.controller.setTextSelected("${deviceSetting.offlineDuration}");

        if(isEdit.isTrue){
            efTargetTempColler.controller.enable();
            tmPickerDurationCoolerOn.controller.enable();
            tmPickerCoolerOffDuration.controller.enable();
        }else{
            efTargetTempColler.controller.disable();
            tmPickerDurationCoolerOn.controller.disable();
            tmPickerCoolerOffDuration.controller.disable();
        }
    }

    /// The function `settingCooler()` is responsible for setting up a cooler device
    /// and handling the response from the server.
    void settingCooler() {
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
                        ListApi.pathSetController("cooler/detail", device.deviceSummary!.coopCodeId!),
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

    /// The function `validationEdit()` checks if certain input fields are empty and
    /// returns a list indicating whether the validation was successful and an error
    /// message if applicable.
    ///
    /// Returns:
    ///   a list containing two elements: a boolean value and an empty string.
    List validationEdit() {
        List ret = [true, ""];

        if (efTargetTempColler.getInput().isEmpty) {
            efTargetTempColler.controller.showAlert();
            Scrollable.ensureVisible(
                efTargetTempColler.controller.formKey.currentContext!);
            return ret = [false, ""];
        }
        if (tmPickerDurationCoolerOn.getLastTimeSelectedText().isEmpty) {
            tmPickerDurationCoolerOn.controller.showAlert();
            Scrollable.ensureVisible(
                tmPickerDurationCoolerOn.controller.formKey.currentContext!);
            return ret = [false, ""];
        }
        if (tmPickerCoolerOffDuration.getLastTimeSelectedText().isEmpty) {
            tmPickerCoolerOffDuration.controller.showAlert();
            Scrollable.ensureVisible(
                tmPickerCoolerOffDuration.controller.formKey.currentContext!);
            return ret = [false, ""];
        }
        return ret;
    }

    /// The function generates a payload for fan setup by retrieving input values
    /// for cooling pad temperature, time on cooling pad, and time off cooling pad.
    ///
    /// Returns:
    ///   a DeviceSetting object.
    DeviceSetting generatePayloadFanSetup(){
        return DeviceSetting(deviceId : controllerData.deviceId,  coolingPadTemperature : efTargetTempColler.getInputNumber(), timeOnCoolingPad: tmPickerDurationCoolerOn.getLastTimeSelectedText(), timeOffCoolingPad: tmPickerCoolerOffDuration.getLastTimeSelectedText());
    }


}

class CoolerSetupBindings extends Bindings {
    BuildContext context;

    CoolerSetupBindings({required this.context});

    @override
    void dependencies() {
        Get.lazyPut(() => CoolerSetupController(context: context));
    }
}

