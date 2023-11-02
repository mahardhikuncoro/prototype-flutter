import 'package:eksternal_app/component/button_outline/button_outline_controller.dart';
import 'package:eksternal_app/component/button_fill/button_fill_controller.dart';
import 'package:eksternal_app/component/card_camera/card_camera_controller.dart';
import 'package:eksternal_app/component/card_floor/card_floor_controller.dart';
import 'package:eksternal_app/component/card_sensor/card_sensor_controller.dart';
import 'package:eksternal_app/component/date_time_field/datetime_field_controller.dart';
import 'package:eksternal_app/component/edit_field/edit_field_controller.dart';
import 'package:eksternal_app/component/edit_field_qr/edit_field_qrcode_controller.dart';
import 'package:eksternal_app/component/expandable/expandable_controller.dart';
import 'package:eksternal_app/component/expandable_device/expandable_device_controller.dart';
import 'package:eksternal_app/component/graph_view/graph_view_controller.dart';
import 'package:eksternal_app/component/item_decrease_temp/item_decrease_temperature_controller.dart';
import 'package:eksternal_app/component/item_historical_smartcamera/item_historical_smartcamera_controller.dart';
import 'package:eksternal_app/component/item_take_picture/item_take_picture_controller.dart';
import 'package:eksternal_app/component/password_field/password_field_controller.dart';
import 'package:eksternal_app/component/spinner_field/spinner_field_controller.dart';
import 'package:eksternal_app/component/switch_button/switch_button_controller.dart';
import 'package:eksternal_app/component/time_picker/time_picker_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 04/07/23
 */

class GetXCreator {

    static EditFieldController putEditFieldController(String tag) {
        return Get.put(EditFieldController(tag: tag), tag: tag);
    }

    static PasswordFieldController putPasswordFieldController(String tag) {
        return Get.put(PasswordFieldController(tag: tag), tag: tag);
    }


    static ButtonFillController putButtonFillController(String tag) {
        return Get.put(ButtonFillController(tag: tag), tag: tag);
    }

    static ButtonOutlineController putButtonOutlineController(String tag) {
        return Get.put(ButtonOutlineController(tag: tag), tag: tag);
    }

    static SpinnerFieldController putSpinnerFieldController(String tag) {
        return Get.put(SpinnerFieldController(tag: tag), tag: tag);
    }

    static CardSensorController putCardSensorController(String tag, BuildContext context) {
        return Get.put(CardSensorController(tag: tag, context: context), tag: tag);
    }
    static CardCameraController putCardCameraController(String tag, BuildContext context) {
        return Get.put(CardCameraController(tag: tag, context: context), tag: tag);
    }

    static CardFloorController putCardFloorController(String tag, BuildContext context) {
        return Get.put(CardFloorController(tag: tag, context: context), tag: tag);
    }

    static EditFieldQRController putEditFieldQRController(String tag) {
        return Get.put(EditFieldQRController(tag: tag), tag: tag);
    }

    static ExpandableDeviceController putAccordionDeviceController(String tag, BuildContext context) {
        return Get.put(ExpandableDeviceController(tag: tag, context: context), tag: tag);
    }

    static ExpandableController putAccordionController(String tag) {
        return Get.put(ExpandableController(tag: tag), tag: tag);
    }

    static ItemDecreaseTemperatureController putItemDecreaseController(String tag, BuildContext context) {
        return Get.put(ItemDecreaseTemperatureController(tag: tag, context: context), tag: tag);
    }

    static DateTimeFieldController putDateTimeFieldController(String tag) {
        return Get.put(DateTimeFieldController(tag: tag), tag: tag);
    }

    static SwitchButtonController putSwitchButtonController(String tag) {
        return Get.put(SwitchButtonController(tag: tag), tag: tag);
    }

    static GraphViewController putGraphViewController(String tag) {
        return Get.put(GraphViewController(tag: tag), tag: tag);
    }

    static TimePickerController putTimePickerController(String tag) {
        return Get.put(TimePickerController(tag: tag), tag: tag);
    }

    static ItemHistoricalSmartCameraController putHistoricalSmartCameraController(String tag, BuildContext context) {
        return Get.put(ItemHistoricalSmartCameraController(tag: tag, context: context), tag: tag);
    }

    static ItemTakePictureCameraController putItemTakePictureController(String tag, BuildContext context) {
        return Get.put(ItemTakePictureCameraController(tag: tag, context: context), tag: tag);
    }

/*

    static MediaFieldController putMediaFieldController(String tag) {
        return Get.put(MediaFieldController(tag: tag), tag: tag);
    }

    static SpinnerMultiFieldController putSpinnerMultiFieldController(String tag) {
        return Get.put(SpinnerMultiFieldController(tag: tag), tag: tag);
    }

    static SuggestFieldController putSuggestFieldController(String tag) {
        return Get.put(SuggestFieldController(tag: tag), tag: tag);
    }

    static SkuCardPurchaseController putSkuCardPurchaseController(String tag, BuildContext context) {
        return Get.put(SkuCardPurchaseController(tag: tag, context: context), tag: tag);
    }

    static SkuCardOrderController putSkuCardOrderController(String tag, BuildContext context) {
        return Get.put(SkuCardOrderController(tag: tag, context: context), tag: tag);
    }
    static SkuCardRemarkController putSkuCardRemarkController(String tag, BuildContext context) {
        return Get.put(SkuCardRemarkController(tag: tag, context: context), tag: tag);
    }
    static SkuRejectController putSkuCardRejectSO(String tag, List<Products?> products) {
        return Get.put(SkuRejectController(tag: tag, products: products), tag: tag,);
    }
    static SkuCardGrController putSkuCardGrOrder(String tag, List<Products?> products) {
        return Get.put(SkuCardGrController(tag: tag, products: products), tag: tag,);
    }*/
}