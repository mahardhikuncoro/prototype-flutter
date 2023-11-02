import 'package:eksternal_app/engine/util/global_var.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 13/07/23
 */

class TabDeviceController extends GetxController with GetSingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void onInit() {
    super.onInit();
    controller = TabController(vsync: this, length: 3);
    controller.addListener(() {
      if(controller.indexIsChanging){
        if(controller.index == 0){
          GlobalVar.track("Click_tab_smart_monitoring");
        }else if(controller.index == 1){
          GlobalVar.track("Click_tab_smart_controller");
        }else if(controller.index == 2){
          GlobalVar.track("Click_tab_smart_camera");
        }

      }
      // controller.
    });
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }
}