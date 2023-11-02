import 'dart:io';
import 'package:eksternal_app/component/date_time_field/datetime_field.dart';
import 'package:eksternal_app/engine/get_x_creator.dart';
import 'package:eksternal_app/engine/model/coop_model.dart';
import 'package:eksternal_app/engine/model/record_model.dart';
import 'package:eksternal_app/engine/util/global_var.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 28/08/23
 */

class TakePictureResultController extends GetxController {
    BuildContext context;
    TakePictureResultController({required this.context});

    ScrollController scrollController = ScrollController();
    Rx<Map<String, bool>> mapList = Rx<Map<String, bool>>({});
    Rx<List<RecordCamera>> recordImages = Rx<List<RecordCamera>>([]);

    var isLoading = false.obs;
    var isLoadMore = false.obs;
    var pageSmartMonitor = 1.obs;
    var pageSmartController = 1.obs;
    var pageSmartCamera = 1.obs;
    var limit = 10.obs;
    var totalCamera = 0.obs;

    late RecordCamera record;
    late Coop coop;

    late String localPath;
    late bool permissionReady;
    late TargetPlatform? platform;
    bool isTakePicture = false;

    late DateTimeField dtftakePicture = DateTimeField(
        controller: GetXCreator.putDateTimeFieldController(
            "dtftakePicture"),
        label: "Jam Ambil Gambar",
        hint: "Pilih Jam Ambil Gambar",
        flag: DateTimeField.ALL_FLAG,
        alertText: "Jam Ambil Gambar harus di isi", onDateTimeSelected: (DateTime time) {
        GlobalVar.track("Click_time_filter");
        dtftakePicture.controller.setTextSelected("${time.day}/${time.month}/${time.year} ${time.hour}:${time.minute}");
    },
    );

    ScrollController scrollCameraController = ScrollController();

    scrollPurchaseListener() async {
        scrollCameraController.addListener(() {
            if (scrollCameraController.position.maxScrollExtent == scrollCameraController.position.pixels) {
                isLoadMore.value = true;
                pageSmartMonitor++;
            }
        });
    }

    @override
    void onInit() {
        super.onInit();
        GlobalVar.track("Open_ambil_gambar_page");
        if (Platform.isAndroid) {
            platform = TargetPlatform.android;
        } else {
            platform = TargetPlatform.iOS;
        }
        isTakePicture = Get.arguments[0];
        coop = Get.arguments[2];

        recordImages.value.clear();
        recordImages = Get.arguments[1];
        totalCamera.value = recordImages.value.length;

    }

    @override
    void onClose() {
        super.onClose();
    }

    @override
    void onReady() {
        super.onReady();
    }


}

class TakePictureResultBindings extends Bindings {
    BuildContext context;

    TakePictureResultBindings({required this.context});

    @override
    void dependencies() {
        Get.lazyPut(() => TakePictureResultController(context: context));
    }
}

