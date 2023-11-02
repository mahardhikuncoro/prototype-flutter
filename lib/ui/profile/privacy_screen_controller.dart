import 'package:eksternal_app/component/button_fill/button_fill.dart';
import 'package:eksternal_app/engine/get_x_creator.dart';
import 'package:eksternal_app/engine/util/route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 25/08/23
 */

class PrivacyScreenController extends GetxController {
    BuildContext context;

    PrivacyScreenController({required this.context});
    ScrollController scrollController = ScrollController();
    final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    late Future<bool> isFirstLogin;
    var isLoading = false.obs;
    var showBtnApprove = false.obs;

    late ButtonFill bfAgree = ButtonFill(
        controller: GetXCreator.putButtonFillController("bfAgree"),
        label: "Saya Setuju", onClick: () async {
            final SharedPreferences pref = await prefs;
            isFirstLogin = pref.setBool('isFirstLogin', false);
            Get.offAllNamed(RoutePage.homePage);
    },
    );
    scrollListener() async {
        scrollController.addListener(() {
            if (scrollController.position.maxScrollExtent == scrollController.position.pixels) {
                bfAgree.controller.enable();
            }
        });
    }

    @override
    Future<void> onInit() async {
        super.onInit();
        isLoading.value = true;
        showBtnApprove.value = Get.arguments;
        isFirstLogin = prefs.then((SharedPreferences prefs) {
            return prefs.getBool('isFirstLogin') ?? true;
        });
        scrollListener();
        bfAgree.controller.disable();
        // if(showBtnApprove.isFalse){
        //     bfAgree.controller.disable()
        // }
        isLoading.value = false;
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

class PrivacyScreenBindings extends Bindings {
    BuildContext context;

    PrivacyScreenBindings({required this.context});

    @override
    void dependencies() {
        Get.lazyPut(() => PrivacyScreenController(context: context));
    }
}

